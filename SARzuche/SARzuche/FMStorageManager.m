//
//  FMStorageManager.m
//  FMLibrary
//
//  Created by leks on 13-4-8.
//  Copyright (c) 2013年 House365. All rights reserved.
//

#import "FMStorageManager.h"
#import "FMUMath.h"

#define G_BASE_LOCALE_DIR [FMStorageManager baseStoragePath]
#define G_BASE_DATA_LOCALE_DIR [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define CACHE_IMAGE_FOLDER @"cimages"
#define CACHE_FILE_FOLDER @"cfiles"
#define CACHE_DATA_FOLDER @"cdata"
#define CACHE_TMP_FOLDER @"ctmp"

#define kFMStorageTypeImage @"image"
#define kFMStorageTypeData @"data"
#define kFMStorageTypeFile @"file"
#define kFMStorageTypeTmp @"tmp"
#define kFMStorageTypeNeverRelease @"never release"

#define PATH_IMAGE_FOLDER [NSString stringWithFormat:@"%@/%@", G_BASE_LOCALE_DIR, CACHE_IMAGE_FOLDER]
#define PATH_FILE_FOLDER [NSString stringWithFormat:@"%@/%@", G_BASE_DATA_LOCALE_DIR, CACHE_FILE_FOLDER]
#define PATH_DATA_FOLDER [NSString stringWithFormat:@"%@/%@", G_BASE_DATA_LOCALE_DIR, CACHE_DATA_FOLDER]
#define PATH_TMP_FOLDER [NSString stringWithFormat:@"%@/%@", G_BASE_LOCALE_DIR, CACHE_TMP_FOLDER]

#define MAX_CACHE_COUNT 50

@implementation FMStorageManager
@synthesize memoryStorageDatas = _memoryStorageDatas;

-(void)dealloc
{
    [_memoryStorageDatas release];
    [super dealloc];
}

-(id)init
{
    if (self = [super init]) {
        self.memoryStorageDatas = [[NSMutableDictionary alloc] initWithCapacity:5];
        [self.memoryStorageDatas setObject:[NSMutableDictionary dictionaryWithCapacity:10] forKey:kFMStorageTypeImage];
        [self.memoryStorageDatas setObject:[NSMutableDictionary dictionaryWithCapacity:10] forKey:kFMStorageTypeData];
        [self.memoryStorageDatas setObject:[NSMutableDictionary dictionaryWithCapacity:10] forKey:kFMStorageTypeFile];
        [self.memoryStorageDatas setObject:[NSMutableDictionary dictionaryWithCapacity:10] forKey:kFMStorageTypeTmp];
        [self.memoryStorageDatas setObject:[NSMutableDictionary dictionaryWithCapacity:10] forKey:kFMStorageTypeNeverRelease];
    }
    
    return self;
}

+(id)sharedInstance
{
    static id _sharedInstance = nil;
    if (!_sharedInstance) {
        _sharedInstance = [[[self class] alloc] init];
    }
    
    return _sharedInstance;
}

#pragma mark - 内存数据存取方法
//储存内存数据方法
-(void)saveObject:(id)object withKey:(id)key type:(FMStorageType)type
{
    [object retain];
    NSMutableDictionary *cache_datas = [NSMutableDictionary dictionaryWithCapacity:10];
    NSString *type_key = nil;
    
    switch (type) {
        case FMStorageTypeImage:
            type_key = kFMStorageTypeImage;
            break;
        case FMStorageTypeData:
            type_key = kFMStorageTypeData;
            break;
        case FMStorageTypeFile:
            type_key = kFMStorageTypeFile;
            break;
        case FMStorageTypeTmp:
            type_key = kFMStorageTypeTmp;
            break;
        case FMStorageTypeNeverRelease:
            type_key = kFMStorageTypeNeverRelease;
            break;
        default:
            break;
    }
    
    if ([self.memoryStorageDatas objectForKey:type_key]) {
        cache_datas = [_memoryStorageDatas objectForKey:type_key];
    }
//    if (object) [cache_datas setObject:object forKey:key];
    
    @synchronized(self)
    {
        if (cache_datas.count > MAX_CACHE_COUNT && ![type_key isEqualToString:kFMStorageTypeData]) {
//            [self clearMemoryDatas:cache_datas];
            NSArray *allKeys = [cache_datas allKeys];
            NSString *randomKey = [allKeys objectAtIndex:0];
            [cache_datas removeObjectForKey:randomKey];
        }
        if (object) [cache_datas setObject:object forKey:key];
    }
    
    [self.memoryStorageDatas setObject:cache_datas forKey:type_key];
    
    [object autorelease];
}

//读取内存数据方法
-(id)readObjectForKey:(NSString*)key type:(FMStorageType)type
{
    NSMutableDictionary *cache_datas = nil;
    NSString *type_key = nil;
    
    switch (type) {
        case FMStorageTypeImage:
            type_key = kFMStorageTypeImage;
            break;
        case FMStorageTypeData:
            type_key = kFMStorageTypeData;
            break;
        case FMStorageTypeFile:
            type_key = kFMStorageTypeFile;
            break;
        case FMStorageTypeTmp:
            type_key = kFMStorageTypeTmp;
            break;
        case FMStorageTypeNeverRelease:
            type_key = kFMStorageTypeNeverRelease;
            break;
        default:
            break;
    }
    
    cache_datas = [self.memoryStorageDatas objectForKey:type_key];
    return [cache_datas objectForKey:key];
}
-(void)clearMemoryDatasByType:(FMStorageType)type
{
    NSMutableDictionary *cache_datas = nil;
    switch (type) {
        case FMStorageTypeImage:
            cache_datas = [self.memoryStorageDatas objectForKey:kFMStorageTypeImage];
            break;
        case FMStorageTypeData:
            cache_datas = [self.memoryStorageDatas objectForKey:kFMStorageTypeData];
            break;
        case FMStorageTypeFile:
            cache_datas = [self.memoryStorageDatas objectForKey:kFMStorageTypeFile];
            break;
        case FMStorageTypeTmp:
            cache_datas = [self.memoryStorageDatas objectForKey:kFMStorageTypeTmp];
            break;
        case FMStorageTypeNeverRelease:
            cache_datas = [self.memoryStorageDatas objectForKey:kFMStorageTypeNeverRelease];
            break;
        default:
            break;
    }
    
    [self clearMemoryDatas:cache_datas];
}

-(void)clearMemoryDatas:(NSMutableDictionary*)datas
{
    @synchronized(datas)
    {
        [datas removeAllObjects];
    }
}

-(void)clearAllMemoryDatas
{
    NSMutableDictionary *cache_datas = [self.memoryStorageDatas objectForKey:kFMStorageTypeImage];
    [self clearMemoryDatas:cache_datas];
    cache_datas = [self.memoryStorageDatas objectForKey:kFMStorageTypeData];
    [self clearMemoryDatas:cache_datas];
    cache_datas = [self.memoryStorageDatas objectForKey:kFMStorageTypeFile];
    [self clearMemoryDatas:cache_datas];
    cache_datas = [self.memoryStorageDatas objectForKey:kFMStorageTypeTmp];
    [self clearMemoryDatas:cache_datas];
}
#pragma mark - 磁盘数据存取方法
-(BOOL)storeImage:(UIImage*)image withFileName:(NSString*)fileName
{
    //暂时不可用
    NSString *path = [NSString stringWithFormat:@"%@/%@", [self getCachedImagePath], fileName];
    NSData *data = UIImageJPEGRepresentation(image, 0.9);
    return [data writeToFile:path atomically:YES];
}

-(BOOL)storeArray:(NSArray*)array withFileName:(NSString*)fileName
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", [self getCachedDataPath], fileName];
    return [array writeToFile:path atomically:YES];
}

-(BOOL)storeDictionary:(NSDictionary*)dictionary withFileName:(NSString*)fileName
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", [self getCachedDataPath], fileName];
    return [dictionary writeToFile:path atomically:YES];
}

-(BOOL)storeData:(NSData*)data withFileName:(NSString*)fileName
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", [self getCachedDataPath], fileName];
    return [data writeToFile:path atomically:YES];
}

-(BOOL)storeValue:(id)value forKey:(NSString*)key
{
    BOOL ret = NO;
    if (!value)
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    }
    
    ret = [[NSUserDefaults standardUserDefaults] synchronize];
    return ret;
}

//读取方法
-(UIImage*)fetchImageForFileName:(NSString*)fileName
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", [self getCachedImagePath], fileName];
    
    UIImage *image = nil;
    @try {
        image = [UIImage imageWithContentsOfFile:path];
    }
    @catch (NSException *exception) {
        ;
    }
    @finally {
        ;
    }
    
    return image;
}

-(NSArray*)fetchArrayForFileName:(NSString*)fileName
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", [self getCachedDataPath], fileName];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    return array;
}

-(NSDictionary*)fetchDictionaryForFileName:(NSString*)fileName
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", [self getCachedDataPath], fileName];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    return dictionary;
}

-(NSData*)fetchDataForFileName:(NSString*)fileName
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", [self getCachedDataPath], fileName];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return data;
}

-(id)fetchValueForKey:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

#pragma mark - 各缓存目录

-(NSString*)getCachedImagePath
{
	if ([FMStorageManager getOrCreateFolder:PATH_IMAGE_FOLDER])
	{
		return PATH_IMAGE_FOLDER;
	}
	return nil;
}

-(NSString*)getCachedFilePath
{
	if ([FMStorageManager getOrCreateFolder:PATH_FILE_FOLDER])
	{
		return PATH_TMP_FOLDER;
	}
	return nil;
}

-(NSString*)getCachedDataPath
{
    if ([FMStorageManager getOrCreateFolder:PATH_DATA_FOLDER])
	{
		return PATH_DATA_FOLDER;
	}
	return nil;
}

-(NSString*)getCachedTmpPath
{
    if ([FMStorageManager getOrCreateFolder:PATH_TMP_FOLDER])
	{
		return PATH_FILE_FOLDER;
	}
	return nil;
}

#pragma mark - 其他方法

-(BOOL)isFileEmpty:(NSString*)filePath
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL ret = [fileManager fileExistsAtPath:filePath];
	if (ret)
	{
		NSData *data = [NSData dataWithContentsOfFile:filePath];
		if ([data length] == 0) {
			ret = YES;
		}
		else {
			ret = NO;
		}
	}
	else {
		ret = YES;
	}
	return ret;
}

-(BOOL)removeArrayForFileName:(NSString*)fileName
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", [self getCachedDataPath], fileName];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    return YES;
}

-(BOOL)removeDictionaryForFileName:(NSString*)fileName
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", [self getCachedDataPath], fileName];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    return YES;
}

-(BOOL)removeDataForFileName:(NSString*)fileName
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", [self getCachedDataPath], fileName];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    return YES;
}

-(BOOL)removeValueForKey:(NSString*)key
{
    return NO;
}

-(BOOL)removeFile:(NSString*)fileName atFolder:(FMStorageType)folderType
{
    NSString *folder = nil;
    switch (folderType) {
        case FMStorageTypeImage:
            folder = [self getCachedImagePath];
            break;
        case FMStorageTypeFile:
            folder = [self getCachedFilePath];
            break;
        case FMStorageTypeTmp:
            folder = [self getCachedTmpPath];
            break;
        case FMStorageTypeData:
            folder = [self getCachedDataPath];
            break;
        default:
            break;
    }
    
    if (!folder) {
        return NO;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", folder, fileName];
    return [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

#pragma mark - 清除方法

-(BOOL)clearCachedImages
{
    NSString *path = [self getCachedImagePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:path error:nil];
}

-(BOOL)clearCachedDatas
{
    NSString *path = [self getCachedDataPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:path error:nil];
}

-(BOOL)clearCachedFiles
{
	NSString *path = [self getCachedFilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:path error:nil];
}

-(BOOL)clearCachedTmpFiles
{
    NSString *path = [self getCachedTmpPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:path error:nil];
}

#pragma mark - 获取缓存目录大小

-(NSString*)dataCacheSize
{
    NSString *path = [self getCachedDataPath];
    NSNumber *file_size = [FMStorageManager sizeForFolder:path];
    
    NSString *ret = [FMUMath formattedTextForFileSize:file_size];
    return ret;
}

-(NSString*)fileCacheSize
{
    NSString *path = [self getCachedFilePath];
    NSNumber *file_size = [FMStorageManager sizeForFolder:path];
    
    NSString *ret = [FMUMath formattedTextForFileSize:file_size];
    return ret;
}

-(NSString*)imageCacheSize
{
    NSString *path = [self getCachedImagePath];
    NSNumber *file_size = [FMStorageManager sizeForFolder:path];
    
    NSString *ret = [FMUMath formattedTextForFileSize:file_size];
    return ret;
}

-(NSString*)tmpCacheSize
{
    NSString *path = [self getCachedTmpPath];
    NSNumber *file_size = [FMStorageManager sizeForFolder:path];
    
    NSString *ret = [FMUMath formattedTextForFileSize:file_size];
    return ret;
}

#pragma mark - 静态方法

+(BOOL)getOrCreateFolder:(NSString*)path
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL isDir;
	BOOL ret = YES;
	if ([fileManager fileExistsAtPath:path isDirectory:&isDir]==NO)
	{
		
		ret = [fileManager createDirectoryAtPath:path
					 withIntermediateDirectories:YES
									  attributes:nil
										   error:nil];
	}
	return ret;
}

+(BOOL)getOrCreateFile:(NSString*)path
{
	BOOL isDir;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:path isDirectory:&isDir]==YES)
	{
		return YES;
	}
	
	BOOL ret = [[NSFileManager defaultManager] createFileAtPath:path contents:[NSData data] attributes:nil];
	return ret;
}

/*
 如须自定义，请覆盖此方法，
 例如根据用户id来区分目录
 */
+(NSString*)baseStoragePath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
}

+(NSNumber*)sizeForFolder:(NSString*)folderPath
{
    unsigned long long n = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *array = [fileManager subpathsOfDirectoryAtPath:folderPath error:nil];
    NSMutableString *ms = [NSMutableString stringWithCapacity:20];
    
    for (int i=0; i<[array count]; i++)
    {
        [ms setString:folderPath];
        NSString *fpath = [array objectAtIndex:i];
        [ms appendFormat:@"/%@", fpath];
        
        NSDictionary *dict = [fileManager attributesOfItemAtPath:ms error:nil];
        NSNumber *tmp = [dict objectForKey:@"NSFileSize"];
        n += [tmp longLongValue];
    }
    
    return [NSNumber numberWithLongLong:n];
}


@end

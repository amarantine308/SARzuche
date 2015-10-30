//
//  CarTimeTableView.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-23.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "CarTimeTableView.h"
#import "CustomDrawView.h"
#import "ConstString.h"

@implementation RectView
@synthesize m_days;
@synthesize m_rect;
@synthesize m_clr;

@end

@implementation StringView
@synthesize m_strRect;
//@synthesize m_strDrawPos;
@synthesize m_strDraw;

@end

#define HEIGHT_FOR_STRING       20.0f
#define HEIGHT_FOR_SCALE        20.0f

#define START_SCALE_X           10.0f
#define WIDTH_SCALE             300.0f

#define START_STRING_X          10.0f
#define WIDTH_STRING            300.0f

#define SIZE_DAY_SCOPE          (24 * 60 * 60)
#define WIDTH_DAY_IN_SCREEN     WIDTH_SCALE

#define SCALE_W                 10.0f
#define SCALE_H                 HEIGHT_FOR_STRING


#define COLOR_RENTED            [UIColor colorWithRed:248./255. green:129.0/255.  blue:56./255. alpha:1.0f]

@implementation CarTimeTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        [self initSize];
        [self initCarTable];
        [self initCarInfoData];
        [self drawRectArray];
        [self drawScale];
    }
    return self;
}

-(void)initCarInfoData
{
    m_strDrawArr1 = [[NSMutableArray alloc] init];
    m_strDrawArr2 = [[NSMutableArray alloc] init];
    m_strDrawArr3 = [[NSMutableArray alloc] init];
    m_strDrawArr4 = [[NSMutableArray alloc] init];
    m_strDrawArr5 = [[NSMutableArray alloc] init];
    m_strDrawArr6 = [[NSMutableArray alloc] init];
    
    m_strDrawScale = [[NSMutableArray alloc] init];
    
    if (nil == m_rectArray) {
        m_rectArray = [[NSMutableArray alloc ] init];
    }
    else
    {
        [m_rectArray removeAllObjects];
    }
#if 0
    for (int i = 0; i < 5; i++)
    {
        RectView *tmpRect1 = [[RectView alloc] init];
        RectView *tmpRect2 = [[RectView alloc] init];
        if (i == 1 || i == 2) {
            tmpRect1.m_rect = CGRectMake(m_frstScale.origin.x + 20.0 * i, m_frstScale.origin.y, 60.0 + 10*i, m_frstScale.size.height);
            tmpRect1.m_days = 0;
            tmpRect2.m_rect = CGRectMake(tmpRect1.m_rect.origin.x + tmpRect1.m_rect.size.width, m_frstScale.origin.y, 12.0, m_frstScale.size.height);
            tmpRect2.m_days = 0;
        }
        else if(i == 3 || i == 4)
        {
            tmpRect1.m_rect = CGRectMake(m_secdScale.origin.x + 20.0* i, m_secdScale.origin.y, 60.0 + 10*i, m_secdScale.size.height);
            tmpRect1.m_days = 1;
            tmpRect2.m_rect = CGRectMake(tmpRect1.m_rect.origin.x + tmpRect1.m_rect.size.width, m_secdScale.origin.y, 12.0, m_secdScale.size.height);
            tmpRect2.m_days = 1;
        }
        else
        {
            tmpRect1.m_rect = CGRectMake(m_thrdScale.origin.x + 20.0* i, m_thrdScale.origin.y, 60.0 + 10*i, m_thrdScale.size.height);
            tmpRect1.m_days = 2;
            tmpRect2.m_rect = CGRectMake(tmpRect1.m_rect.origin.x + tmpRect1.m_rect.size.width, m_thrdScale.origin.y, 12.0, m_thrdScale.size.height);
            tmpRect2.m_days = 2;
        }
        
        tmpRect1.m_clr = rectRed;
        tmpRect2.m_clr = rectYellow;
        [m_rectArray addObject:tmpRect1];
        [m_rectArray addObject:tmpRect2];
    }
#endif
}

-(void)initSize
{
    m_frstScale = CGRectMake(START_SCALE_X, HEIGHT_FOR_STRING, WIDTH_SCALE, HEIGHT_FOR_SCALE);
    m_secdScale = CGRectMake(START_SCALE_X, HEIGHT_FOR_SCALE + HEIGHT_FOR_STRING * 3, WIDTH_SCALE, HEIGHT_FOR_SCALE);
    m_thrdScale = CGRectMake(START_SCALE_X, HEIGHT_FOR_SCALE * 2 + HEIGHT_FOR_STRING * 5, WIDTH_SCALE, HEIGHT_FOR_SCALE);
    m_viewHeight += HEIGHT_FOR_SCALE * 3;
    
    m_frstStrTop = CGRectMake(START_STRING_X, 0, WIDTH_STRING, HEIGHT_FOR_STRING);
    m_frstStrBottom = CGRectMake(START_STRING_X, HEIGHT_FOR_STRING + HEIGHT_FOR_SCALE, WIDTH_STRING, HEIGHT_FOR_STRING);
    
    m_secStrTop = CGRectMake(START_STRING_X, HEIGHT_FOR_STRING * 2 + HEIGHT_FOR_SCALE, WIDTH_STRING, HEIGHT_FOR_STRING);
    m_secStrBottm = CGRectMake(START_STRING_X, HEIGHT_FOR_STRING * 3 + HEIGHT_FOR_SCALE * 2, WIDTH_STRING, HEIGHT_FOR_STRING);
    
    m_thrdStrTop = CGRectMake(START_STRING_X, HEIGHT_FOR_STRING * 4 + HEIGHT_FOR_SCALE * 2, WIDTH_STRING, HEIGHT_FOR_STRING);
    m_thrdStrBottom = CGRectMake(START_STRING_X, HEIGHT_FOR_SCALE * 3 + HEIGHT_FOR_STRING * 5, WIDTH_STRING, HEIGHT_FOR_STRING);
    m_viewHeight += HEIGHT_FOR_STRING * 6;
}

-(void)initCarTable
{
    CGRect tmpFrame = self.frame;
    tmpFrame.size.height = m_viewHeight;
    self.frame = tmpFrame;
    
    for (NSInteger i = 0; i < 3; i++)
    {
        [self initGreenScale:i];
    }
#if 0
    CustomDrawView *cirView = [[CustomDrawView alloc] initWithFrame:FRAME_CIR_RECT withStyle:customCirRectangle];
    [self.view addSubview:cirView];
    NSInteger width = FRAME_CIR_RECT.size.width/24;
    NSInteger height = FRAME_CIR_RECT.size.height - 1;
    NSInteger startX = FRAME_CIR_RECT.origin.x;
    NSInteger startY = FRAME_CIR_RECT.origin.y + 1;
    for (NSInteger i = 1; i < 24; i++)
    {
        CGRect tmpRect = CGRectMake(startX + width * i, startY, 1, height);
        CustomDrawView *lineView = [[CustomDrawView alloc] initWithFrame:tmpRect withStyle:customLine];
        [lineView drawVerLine:1 withColor:[UIColor whiteColor]];
        [self.view addSubview:lineView];
    }
    
#endif
}

-(void)drawScale
{
    for (NSInteger i = 0; i < 24; i++)
    {
        StringView *tScale = [[StringView alloc] init];
        tScale.m_strDraw = [NSString stringWithFormat:@"%d", i];
        CGFloat startPos = [self getPostionInScopeWithHour:i];
        tScale.m_strRect = CGRectMake(startPos, 0, SCALE_W, SCALE_H);
        [self addStringDrawToScale:tScale];
    }
    
    
    for (NSInteger i = 0; i< [m_strDrawScale count]; i++)
    {
        StringView* tmpView = [m_strDrawScale objectAtIndex:i];
        NSString *tmpStr = tmpView.m_strDraw;
        CGRect  tmpRect = tmpView.m_strRect;
        tmpRect.origin.y = m_frstStrBottom.origin.y;
        tmpRect.origin.x += m_frstStrBottom.origin.x - 5;
        
        CustomDrawView *tmpVew = [[CustomDrawView alloc] initWithFrame:tmpRect withStyle:customText];
        [tmpVew setFontSize:8];
        [tmpVew setText:tmpStr];
        [self addSubview:tmpVew];
    }
    
    for (NSInteger i = 0; i< [m_strDrawScale count]; i++)
    {
        StringView* tmpView = [m_strDrawScale objectAtIndex:i];
        NSString *tmpStr = tmpView.m_strDraw;
        CGRect  tmpRect = tmpView.m_strRect;
        tmpRect.origin.y = m_secStrBottm.origin.y;
        tmpRect.origin.x += m_secStrBottm.origin.x;
        
        CustomDrawView *tmpVew = [[CustomDrawView alloc] initWithFrame:tmpRect withStyle:customText];
        [tmpVew setFontSize:8];
        [tmpVew setText:tmpStr];
        [self addSubview:tmpVew];
    }
    
    for (NSInteger i = 0; i< [m_strDrawScale count]; i++)
    {
        StringView* tmpView = [m_strDrawScale objectAtIndex:i];
        NSString *tmpStr = tmpView.m_strDraw;
        CGRect  tmpRect = tmpView.m_strRect;
        tmpRect.origin.y = m_thrdStrBottom.origin.y;
        tmpRect.origin.x += m_thrdStrBottom.origin.x;
        
        CustomDrawView *tmpVew = [[CustomDrawView alloc] initWithFrame:tmpRect withStyle:customText];
        [tmpVew setFontSize:8];
        [tmpVew setText:tmpStr];
        [self addSubview:tmpVew];
    }
    
    CGRect rectToday = m_frstStrTop;
    CustomDrawView *today = [[CustomDrawView alloc] initWithFrame:rectToday withStyle:customText];
    [today setText:STR_TODAY];
    [self addSubview:today];
    
    CGRect rectTommorrow = m_secStrTop;
    CustomDrawView *tommorrow = [[CustomDrawView alloc] initWithFrame:rectTommorrow withStyle:customText];
    [tommorrow setText:STR_TOMMORROW];
    [self addSubview:tommorrow];
    
    CGRect rectAfter = m_thrdStrTop;
    CustomDrawView *after = [[CustomDrawView alloc] initWithFrame:rectAfter withStyle:customText];
    [after setText:STR_AFTER_TOMMORROW];
    [self addSubview:after];
}



-(void)drawStrArray
{
    for (NSInteger i = 0; i< [m_strDrawArr1 count]; i++)
    {
        StringView* tmpView = [m_strDrawArr1 objectAtIndex:i];
        NSString *tmpStr = tmpView.m_strDraw;
        CGRect  tmpRect = tmpView.m_strRect;
        
        CustomDrawView *tmpVew = [[CustomDrawView alloc] initWithFrame:tmpRect withStyle:customText];
        [tmpVew setText:tmpStr];
        [self addSubview:tmpVew];
    }
    
    
    for (NSInteger i = 0; i< [m_strDrawArr2 count]; i++)
    {
        StringView* tmpView = [m_strDrawArr2 objectAtIndex:i];
        NSString *tmpStr = tmpView.m_strDraw;
        CGRect  tmpRect = tmpView.m_strRect;
        
        CustomDrawView *tmpVew = [[CustomDrawView alloc] initWithFrame:tmpRect withStyle:customText];
        [tmpVew setText:tmpStr];
        [self addSubview:tmpVew];
    }
    
    for (NSInteger i = 0; i< [m_strDrawArr3 count]; i++)
    {
        StringView* tmpView = [m_strDrawArr3 objectAtIndex:i];
        NSString *tmpStr = tmpView.m_strDraw;
        CGRect  tmpRect = tmpView.m_strRect;
        
        CustomDrawView *tmpVew = [[CustomDrawView alloc] initWithFrame:tmpRect withStyle:customText];
        [tmpVew setText:tmpStr];
        [self addSubview:tmpVew];
    }
    
    for (NSInteger i = 0; i< [m_strDrawArr4 count]; i++)
    {
        StringView* tmpView = [m_strDrawArr4 objectAtIndex:i];
        NSString *tmpStr = tmpView.m_strDraw;
        CGRect  tmpRect = tmpView.m_strRect;
        
        CustomDrawView *tmpVew = [[CustomDrawView alloc] initWithFrame:tmpRect withStyle:customText];
        [tmpVew setText:tmpStr];
        [self addSubview:tmpVew];
    }
    
    for (NSInteger i = 0; i< [m_strDrawArr5 count]; i++)
    {
        StringView* tmpView = [m_strDrawArr5 objectAtIndex:i];
        NSString *tmpStr = tmpView.m_strDraw;
        CGRect  tmpRect = tmpView.m_strRect;
        
        CustomDrawView *tmpVew = [[CustomDrawView alloc] initWithFrame:tmpRect withStyle:customText];
        [tmpVew setText:tmpStr];
        [self addSubview:tmpVew];
    }
    
    for (NSInteger i = 0; i< [m_strDrawArr6 count]; i++)
    {
        StringView* tmpView = [m_strDrawArr6 objectAtIndex:i];
        NSString *tmpStr = tmpView.m_strDraw;
        CGRect  tmpRect = tmpView.m_strRect;
        
        CustomDrawView *tmpVew = [[CustomDrawView alloc] initWithFrame:tmpRect withStyle:customText];
        [tmpVew setText:tmpStr];
        [self addSubview:tmpVew];
    }
    
}

-(void)drawRectArray
{
    NSInteger count = [m_rectArray count];
    for (NSInteger i = 0; i < count; i++)
    {
        RectView *tmpView = [m_rectArray objectAtIndex:i];
        if (tmpView.m_clr == rectYellow) {
            CustomDrawView *yellowView = [[CustomDrawView alloc] initWithFrame:tmpView.m_rect withStyle:customFillRect];
            [yellowView setBackgroundColor:COLOR_RENTED];
            [self addSubview:yellowView];
        }
        else
        {
            CustomDrawView *redView = [[CustomDrawView alloc] initWithFrame:tmpView.m_rect withStyle:customFillRect];
            [redView setBackgroundColor:COLOR_RENTED];
            [self addSubview:redView];
        }
    }
}


-(void)initGreenScale:(NSInteger)index
{
    switch (index) {
        case 0:
            [self drawGreenScale:m_frstScale];
            break;
        case 1:
            [self drawGreenScale:m_secdScale];
            break;
        case 2:
            [self drawGreenScale:m_thrdScale];
            break;
        default:
            break;
    }
}

-(void)drawGreenScale:(CGRect)rect
{
    CustomDrawView *cirView = [[CustomDrawView alloc] initWithFrame:rect withStyle:customCirRectangle];
    [self addSubview:cirView];
    
    CGFloat width = rect.size.width/24.0;
    CGFloat height = rect.size.height - 6.0;
    CGFloat startX = rect.origin.x;
    CGFloat startY = rect.origin.y + 3.0;
    for (NSInteger i = 1; i < 24; i++)
    {
        CGRect tmpRect = CGRectMake(startX + width * i, startY, 1, height);
        CustomDrawView *lineView = [[CustomDrawView alloc] initWithFrame:tmpRect withStyle:customLine];
        [lineView drawVerLine:1 withColor:[UIColor whiteColor]];
        [self addSubview:lineView];
    }

}

-(void)extractCheckForDraw:(NSArray *)timeArr withDay:(NSInteger)day
{
    NSInteger sPos = 0;
    NSInteger ePos = 0;
    for (NSInteger i = 0; i < [timeArr count]; i++) {
        NSString *strTime = [timeArr objectAtIndex:i];
        NSArray *timeArray = [strTime componentsSeparatedByString:@"-"];
        if (2 == [timeArray count])
        {
            NSString *startTime = [timeArray objectAtIndex:0];
            NSString *endTime = [timeArray objectAtIndex:1];
            NSLog(@"%@-%@", startTime, endTime);
            sPos = [self getPostionInScope:startTime];
            ePos = [self getPostionInScope:endTime];
            
        }
        
        RectView *tmpRectView = [[RectView alloc] init];
        tmpRectView.m_days = day;
        tmpRectView.m_clr = rectYellow;
        if (sPos > ePos) {
            continue;
        }
        
        CGRect tmpRect;
        switch (day) {
            case 0:
                tmpRect = m_frstScale;
                break;
            case 1:
                tmpRect = m_secdScale;
                break;
            case 2:
                tmpRect = m_thrdScale;
                break;
            default:
                break;
        }
        CGFloat x = tmpRect.origin.x + sPos;
        CGFloat w = ePos - sPos;
        CGFloat y = tmpRect.origin.y;
        CGFloat h = tmpRect.size.height;
        tmpRectView.m_rect = CGRectMake(x, y, w, h);
        [m_rectArray addObject:tmpRectView];
    }
}

-(void)drawChecking
{
#if 1
    [self extractCheckForDraw:m_checking1 withDay:0];
    [self extractCheckForDraw:m_checking2 withDay:1];
    [self extractCheckForDraw:m_checking3 withDay:2];
#endif
    [self drawRectArray];
}

-(CGFloat)getPostionInScope:(NSString *)strHHMMSS
{
    NSArray *hms = [strHHMMSS componentsSeparatedByString:@":"];
    if (3 == [hms count]) {
        NSInteger sH = [[hms objectAtIndex:0] integerValue];
        NSInteger sM = [[hms objectAtIndex:1] integerValue];
        NSInteger sS = [[hms objectAtIndex:2] integerValue];
        CGFloat sSeconds = sH * 60 * 60 + sM * 60 + sS;
        CGFloat fProportion = (sSeconds / SIZE_DAY_SCOPE);
        CGFloat xPosition = fProportion * WIDTH_DAY_IN_SCREEN;
        return xPosition;
    }

    return 0.0;
}


-(CGFloat)getPostionInScopeWithHour:(NSInteger)hour
{
    CGFloat sSeconds = hour * 60 * 60;
    CGFloat fProportion = (sSeconds / SIZE_DAY_SCOPE);
    CGFloat xPosition = fProportion * WIDTH_DAY_IN_SCREEN;
    
    return xPosition;
}



-(void)addStringDrawToScale:(StringView *)strView
{
    CGRect tmpRect = strView.m_strRect;
    strView.m_strRect = CGRectMake(tmpRect.origin.x, 0, tmpRect.size.width, tmpRect.size.height);
    [m_strDrawScale addObject:strView];
}

-(void)addStringDrawToArray:(StringView *)strView withDay:(NSInteger)day start:(BOOL)bStartStr
{
    CGRect tmpRect = strView.m_strRect;
    
    switch (day) {
        case 0:
            if (bStartStr)
            {
                strView.m_strRect = CGRectMake(tmpRect.origin.x, m_frstStrTop.origin.y, tmpRect.size.width, tmpRect.size.height);
                [m_strDrawArr1 addObject:strView];
            }
            else
            {
                strView.m_strRect = CGRectMake(tmpRect.origin.x, m_frstStrBottom.origin.y, tmpRect.size.width, tmpRect.size.height);
                [m_strDrawArr2 addObject:strView];
            }
            break;
        case 1:
            if (bStartStr)
            {
                strView.m_strRect = CGRectMake(tmpRect.origin.x, m_secStrTop.origin.y, tmpRect.size.width, tmpRect.size.height);
                [m_strDrawArr3 addObject:strView];
            }
            else
            {
                strView.m_strRect = CGRectMake(tmpRect.origin.x, m_secStrBottm.origin.y, tmpRect.size.width, tmpRect.size.height);
                [m_strDrawArr4 addObject:strView];
            }
            break;
        case 2:
            if (bStartStr)
            {
                strView.m_strRect = CGRectMake(tmpRect.origin.x, m_thrdStrTop.origin.y, tmpRect.size.width, tmpRect.size.height);
                [m_strDrawArr5 addObject:strView];
            }
            else
            {
                strView.m_strRect = CGRectMake(tmpRect.origin.x, m_thrdStrBottom.origin.y, tmpRect.size.width, tmpRect.size.height);
                [m_strDrawArr6 addObject:strView];
            }
            break;
        default:
            break;
    }
    
}

-(void)extractUsedForDraw:(NSArray *)timeArr withDay:(NSInteger)day
{
    NSInteger sPos = 0;
    NSInteger ePos = 0;
    for (NSInteger i = 0; i < [timeArr count]; i++) {
    NSString *strTime = [timeArr objectAtIndex:i];
    NSArray *timeArray = [strTime componentsSeparatedByString:@"-"];
    if (2 == [timeArray count])
    {
        NSString *startTime = [timeArray objectAtIndex:0];
        NSString *endTime = [timeArray objectAtIndex:1];
        NSLog(@"%@-%@", startTime, endTime);
        sPos = [self getPostionInScope:startTime];
        ePos = [self getPostionInScope:endTime];
        
        StringView *sStringView = [[StringView alloc] init];
        sStringView.m_strRect = CGRectMake(sPos + m_frstStrTop.origin.x, m_frstStrTop.origin.y, m_frstStrTop.size.width, m_frstStrTop.size.height);
        NSArray *tmpArr = [startTime componentsSeparatedByString:@":"];
        sStringView.m_strDraw = [NSString stringWithFormat:@"%@:%@", [tmpArr objectAtIndex:0], [tmpArr objectAtIndex:1]];
        [self addStringDrawToArray:sStringView withDay:day start:YES];

        StringView *eStringView = [[StringView alloc] init];
        eStringView.m_strRect = CGRectMake(ePos + m_frstStrTop.origin.x, m_frstStrTop.origin.y, m_frstStrTop.size.width, m_frstStrTop.size.height);
        tmpArr = [endTime componentsSeparatedByString:@":"];
        eStringView.m_strDraw = [NSString stringWithFormat:@"%@:%@", [tmpArr objectAtIndex:0], [tmpArr objectAtIndex:1]];
        [self addStringDrawToArray:eStringView withDay:day start:NO];
    }
    
    RectView *tmpRectView = [[RectView alloc] init];
    tmpRectView.m_days = day;
    tmpRectView.m_clr = rectRed;
    if (sPos > ePos) {
        continue;
    }
        
        CGRect tmpRect;
        switch (day) {
            case 0:
                tmpRect = m_frstScale;
                break;
            case 1:
                tmpRect = m_secdScale;
                break;
            case 2:
                tmpRect = m_thrdScale;
                break;
            default:
                break;
        }
    CGFloat x = tmpRect.origin.x + sPos;
    CGFloat w = ePos - sPos;
    CGFloat y = tmpRect.origin.y;
    CGFloat h = tmpRect.size.height;
    tmpRectView.m_rect = CGRectMake(x, y, w, h);
    [m_rectArray addObject:tmpRectView];
}

}

-(void)drawUsing
{
    [self extractUsedForDraw:m_using1 withDay:0];
    [self extractUsedForDraw:m_using2 withDay:1];
    [self extractUsedForDraw:m_using3 withDay:2];
    
    [self drawRectArray];
  
//    [self drawScale];
//    [self drawStrArray];
}

-(void)updateChecking:(NSArray *)chk1 check2:(NSArray *)chk2 check3:(NSArray *)chk3
{
    m_checking1 = [[NSArray alloc] initWithArray:chk1];
    m_checking2 = [[NSArray alloc] initWithArray:chk2];
    m_checking3 = [[NSArray alloc] initWithArray:chk3];
    
    [self drawChecking];
}

-(void)updateUsing:(NSArray *)using1 use2:(NSArray *)using2 check3:(NSArray *)using3
{
    m_using1 = [[NSArray alloc] initWithArray:using1];
    m_using2 = [[NSArray alloc] initWithArray:using2];
    m_using3 = [[NSArray alloc] initWithArray:using3];
    
    [self drawUsing];
}


@end

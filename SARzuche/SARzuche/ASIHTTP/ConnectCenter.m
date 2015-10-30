//
//  ConnectCenter.m
//  PropagatePlatform
//
//  Created by sun jincai on 13-3-4.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "ConnectCenter.h"
#import "PublicFunction.h"

@implementation ConnectCenter

//实现单例
+(ConnectCenter*)GetInstance
{
    static ConnectCenter* instance;
    @synchronized(self)
	{
		if (instance == nil)
		{
			instance = [[self alloc] init];
		}
	}
	return instance;
}

//重写初始化
- (id) init
{
	if (self = [super init])
	{
		netWorkQue = [[ASINetworkQueue alloc] init];
		netWorkQue.shouldCancelAllRequestsOnFailure = NO;
		[netWorkQue reset];
		[netWorkQue go];
	}
	return self;
}

//发送请求
- (void) sendRequestWithUrlOrData:(id)data 
						 delegate:(id <ConnectorDelegate>)del 
                            msgId:(int)msgId
                           action:(NSString *)action
					  requestType:(NSInteger) type
{
	NSURL *url;
	if (type == postReqeust)
	{
		//post请求
		url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[PublicFunction ShareInstance].serverUrlPrefix, action]];
        NSLog(@"post--> %@",url);
        
		ASIFormDataRequest *formRequest = [ASIFormDataRequest requestWithURL:url];
        formRequest.shouldPresentCredentialsBeforeChallenge = YES;

		formRequest.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
								[NSString stringWithFormat:@"%d",msgId],@"msg",
								del,@"delegate",
								[NSString stringWithFormat:@"%ld",(long)type],@"type",nil];
		formRequest.delegate = self;
		
		//set formRequest body
        if([data isKindOfClass:[NSDictionary class]] || [data isKindOfClass:[NSMutableDictionary class]])
        {
            NSDictionary *dic = (NSDictionary *)data;
            NSEnumerator *enumerator = [dic keyEnumerator];
            id key;
            id value;
            while ((key = [enumerator nextObject]))
            {
                value = [dic valueForKey:(NSString *)key];
                if ([value isKindOfClass:[NSString class]])
                {
                    //直接设置key和value
                    //[formRequest setPostValue:value forKey:(NSString *)key];
                    
                    //将键值转成字节，通过流的方式发送..
                    NSString *str = (NSString*)value;
                    NSMutableData *dataTemp = [NSMutableData dataWithData:[str dataUsingEncoding:NSUTF8StringEncoding]];
                    [formRequest setPostBody:dataTemp];
                }
                else if([value isKindOfClass:[UIImage class]])
                {
                    [formRequest addData:UIImageJPEGRepresentation((UIImage *)value, 1.0)
                            withFileName:@"1.jpg"
                          andContentType:@"image/jpeg"
                                  forKey:(NSString *)key];
                }
                else if([value isKindOfClass:[NSArray class]])
                {
                    NSArray *arr = (NSArray*)value;
                    for(int i = 0; i < [arr count]; i++)
                    {
                        id obj = [arr objectAtIndex:i];
                        if([obj isKindOfClass:[NSDictionary class]])
                        {
                            NSDictionary *objDic = (NSDictionary*)obj;
                            NSEnumerator *enuTemp = [objDic keyEnumerator];
                            id keyTemp;
                            id valueTemp;
                            while((keyTemp = [enuTemp nextObject]))
                            {
                                valueTemp = [objDic valueForKey:(NSString *)keyTemp];
                                if([valueTemp isKindOfClass:[UIImage class]])
                                {
                                    NSString *temp = [NSString stringWithFormat:@"%d.jpg",i];
                                    [formRequest addData:UIImageJPEGRepresentation((UIImage *)valueTemp, 1.0)
                                            withFileName:temp
                                          andContentType:@"image/jpeg"
                                                  forKey:(NSString *)keyTemp];
                                }
                            }
                        }
                    }
                }
            }
        }
        
		[netWorkQue addOperation:formRequest];
	}
	else 
	{
		if (type == imageRequest)
		{
			url = [NSURL URLWithString:(NSString *)data];
		}
		else 
		{
            NSString *resultUrl;
            if (data != nil)
            {
                resultUrl=[NSString stringWithFormat:@"%@%@?%@",[PublicFunction ShareInstance].serverUrlPrefix, action,(NSString *)data];
            }
            else
            {
                resultUrl=[NSString stringWithFormat:@"%@%@",[PublicFunction ShareInstance].serverUrlPrefix,action];
            }
            
            resultUrl=[resultUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            url = [NSURL URLWithString:resultUrl];
		}
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
		NSLog(@"connector Center url:%@",url);
		request.shouldPresentCredentialsBeforeChallenge = YES;

        //[request addBasicAuthenticationHeaderWithUsername:[NSString stringWithFormat:@"%@",[Helper GetInstance].currUserLoginAccount] andPassword:[NSString stringWithFormat:@"%@",[Helper GetInstance].currUserLoginPassword]];

		[request addRequestHeader:@"Charset" value:@"UTF-8"];
        
		request.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
							[NSString stringWithFormat:@"%d",msgId],@"msg",
							del,@"delegate",
							[NSString stringWithFormat:@"%d",type],@"type",nil];
		request.delegate = self;
		[netWorkQue addOperation:request];
	}
}


#pragma mark -
#pragma mark ASIHTTPRequestDelegate
- (void) requestFailed:(ASIHTTPRequest *)request
{
	NSString *info;
	NSInteger code = [[request error] code];
	switch (code) 
	{
		case ASIRequestTimedOutErrorType:
			//联网超时
			info = [NSString stringWithFormat:@"连接超时,请重试"];
			break;
		case ASIConnectionFailureErrorType:
			//info = [NSString stringWithFormat:@"请检查网络连接是否可用"];
            info = [NSString stringWithFormat:@"网络或服务器问题，请重试"];
			break;
		case -1004:
			info = [NSString stringWithFormat:@"无法连接到服务器"];
			break;
		default:
			//info = [NSString stringWithFormat:@"%d:%@",[error code],[error localizedDescription]];
			info = @"网络异常,请检查网络";
			break;
	}
	
	id <ConnectorDelegate> delegate = [request.userInfo valueForKey:@"delegate"];
	if (delegate != nil)
	{
		[delegate parseNetWorkError:info
							   code:code
							  msgId:[[request.userInfo valueForKey:@"msg"] intValue]
						requestType:[[request.userInfo valueForKey:@"type"] intValue]
		 ];
	}
}

- (void) requestFinished:(ASIHTTPRequest *)request
{
	id <ConnectorDelegate> delegate = [request.userInfo valueForKey:@"delegate"];
	if (delegate != nil)
	{
		[delegate parseData:[request responseData] 
					  msgId:[[request.userInfo valueForKey:@"msg"] intValue]
				requestType:[[request.userInfo valueForKey:@"type"] intValue]
				 requestUrl:[request.url description]
		 ];
	}
}



- (void) cancelRequestByDelegate:(id<ConnectorDelegate>) del
{
	for (ASIHTTPRequest *request in [netWorkQue operations])
	{
		if ([request.userInfo valueForKey:@"delegate"] == del)
		{
			[request clearDelegatesAndCancel];
		}
	}	
}


@end

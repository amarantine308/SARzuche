//
//  ConnectCenter.h
//  PropagatePlatform
//
//  Created by sun jincai on 13-3-4.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

#define imageRequest 1
#define getRequest 2
#define postReqeust 3

/*
 * 连接结果委托
 */
@protocol ConnectorDelegate

- (void) parseData: (NSData *) data msgId: (NSInteger) msgId requestType: (NSInteger) requestType requestUrl:(NSString *) requestUrl;

- (void) parseNetWorkError: (NSString *) info code:(NSInteger)code msgId: (NSInteger) msgId requestType: (NSInteger) requestType;

@end


/*
 * HTTP连接管理类
 */
@interface ConnectCenter : NSObject<ASIHTTPRequestDelegate>
{
    ASINetworkQueue *netWorkQue;
}

+(ConnectCenter*)GetInstance;

- (void) cancelRequestByDelegate:(id<ConnectorDelegate>) del;

- (void) sendRequestWithUrlOrData:(id)data 
						 delegate:(id <ConnectorDelegate>)del 
                            msgId:(int)msgId action:(NSString *)action 
					  requestType:(NSInteger) type;

@end

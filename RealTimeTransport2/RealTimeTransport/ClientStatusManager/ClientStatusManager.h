//
//  ClientStatusManager.h
//  RealTimeTransport
//
//  Created by 常 贤明 on 13-4-15.
//  Copyright (c) 2013年 常 贤明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Globaldef_i.h"

@class ClientSocket;
#define PALUMS_TIMEINTERVAL_DEFAULT 30
#define PALUMS_MAXTRY_DEFAULT 3

@interface ClientStatusManager : NSObject
{
    BOOL                m_bIsPalmusTestRunning;        // 标识当前心跳测试循环是否在进行
    DWORD               m_nTimesOfFailed;              // 当前测试失败次数
    NSTimer*            m_palmusSendTimer;             // 发送心跳包计时器
    NSTimeInterval      m_palumsTimeInterval;          // 每次发送心跳包的时间间距
    DWORD               m_uMaxTry;                     // 认为失败的最大偿试次数
}

@property (assign) ClientSocket* clientScok;
@property (assign) BOOL isClientActive;

+ (ClientStatusManager*) sharedClientStatusManager;
+ (id) allocWithZone:(NSZone *)zone;

- (void) setPalumsTimeInterval:(NSTimeInterval)palumsTimeInterval andMaxTry: (DWORD)uMaxTry;
- (BOOL) isPalmusTestRunning;
- (void) startPalmusTesting;
- (void) stopPalmusTesting;
- (BOOL) didReceiveHeartResp;
- (BOOL) didReceiveHeartReq;
- (BOOL) didReceiveMsg;

@end

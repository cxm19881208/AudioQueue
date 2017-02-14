//
//  ClientStatusManager.m
//  RealTimeTransport
//
//  Created by 常 贤明 on 13-4-15.
//  Copyright (c) 2013年 常 贤明. All rights reserved.
//

#import "ClientStatusManager.h"
#import "ClientSocket.h"

static ClientStatusManager* g_sharedClientStatusManager = nil;

@implementation ClientStatusManager
@synthesize clientScok;

- (id) init
{
    if (self = [super init])
    {
        m_bIsPalmusTestRunning = FALSE;
        m_palmusSendTimer = nil;
        m_nTimesOfFailed = 0;
        m_palumsTimeInterval = (NSTimeInterval) PALUMS_TIMEINTERVAL_DEFAULT;
        m_uMaxTry = PALUMS_MAXTRY_DEFAULT;
        clientScok = nil;
        self.isClientActive = TRUE;
    }
    
    return self;
}

- (void) setDefault
{
    m_bIsPalmusTestRunning = FALSE;
    m_palmusSendTimer = nil;
    m_nTimesOfFailed = 0;
    m_palumsTimeInterval = (NSTimeInterval) PALUMS_TIMEINTERVAL_DEFAULT;
    m_uMaxTry = PALUMS_MAXTRY_DEFAULT;
}

+ (ClientStatusManager*) sharedClientStatusManager
{
    @synchronized (self)
    {
        if (!g_sharedClientStatusManager)
        {
            g_sharedClientStatusManager = [[ClientStatusManager alloc] init];
        }
    }
    
    return g_sharedClientStatusManager;
}

+ (id) allocWithZone:(NSZone *)zone
{
    @synchronized (self)
    {
        if (!g_sharedClientStatusManager)
        {
            g_sharedClientStatusManager = [super allocWithZone:zone];
            [g_sharedClientStatusManager setDefault];
        }
    }
    return g_sharedClientStatusManager;
}

- (void) setPalumsTimeInterval:(NSTimeInterval)palumsTimeInterval andMaxTry:(DWORD)uMaxTry
{
    m_palumsTimeInterval = palumsTimeInterval;
    m_uMaxTry = uMaxTry;
}

- (BOOL) isPalmusTestRunning
{
    return m_bIsPalmusTestRunning;
}

- (void) startPalmusTesting
{
    if (m_bIsPalmusTestRunning) return;
    
    if (m_palmusSendTimer)
    {
        [m_palmusSendTimer fire];
    }
    else
    {
        m_palmusSendTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doSendTimeout:) userInfo:nil repeats:YES];
        [m_palmusSendTimer fire];
    }
    
    m_bIsPalmusTestRunning = TRUE;
}

- (void) stopPalmusTesting
{
    [m_palmusSendTimer invalidate];
    m_bIsPalmusTestRunning = FALSE;
}

-(BOOL) didReceivedHeartResp
{
    m_nTimesOfFailed = 0;
    NSLog(@"接收到心跳测试回复");
    return TRUE;
}

- (BOOL) didReceiveHeartReq
{
    if(clientScok)  return [clientScok SendData: MSG_HEART_RESP sequenceID:0];
 
    NSLog(@"接收到心跳测试包");
    
    return FALSE;
}

- (BOOL) didReceiveMsg
{
    self.isClientActive = TRUE;
    return TRUE;
}

- (void)doSendTimeout:(NSTimer *)timer
{
    if (timer != m_palmusSendTimer) return;
    
    if ([self isClientActive])
    {
        self.isClientActive = FALSE;
        return;
    }

    // 超过指定最大测试失败次数，认为已经与服务端断开连接
    if (m_nTimesOfFailed >= m_uMaxTry)
    {
        [m_palmusSendTimer invalidate];
        
        if (clientScok)
        {
            [clientScok CloseSocket:YES];
        }
    }
    else
    {

        [clientScok SendData:MSG_HEART_REQ sequenceID:0];
        m_nTimesOfFailed ++;
        NSLog(@"发送心跳测试请求");
    }
}

@end

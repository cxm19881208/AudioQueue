//
//  NetDispatcher.m
//  RealTimeTransport
//
//  Created by 常 贤明 on 13-4-17.
//  Copyright (c) 2013年 常 贤明. All rights reserved.
//
#import "NetDispatcher.h"
#import "AVManager.h"
#import "ViewController.h"
#import "ClientStatusManager.h"

extern DWORD g_PeerUserID;
extern Call_Status call_status;

@implementation NetDispatcher
@synthesize viewController;
@synthesize m_avManager;


- (void)dealloc
{
    [super dealloc];
}

- (id)init
{
    if (self = [super init])
    {
        clientSocket = [[ClientSocket alloc] init];
        m_clientSocket = clientSocket;
        m_avManager = [[AVManager alloc] init];
        [m_avManager initAudioService:m_clientSocket];
        
        m_clientStatusMgr = [ClientStatusManager sharedClientStatusManager];
        //m_clientStatusMgr.clientScok = m_clientSocket;
        
        [clientSocket SetSocketSink:self];
        [clientSocket StartThread];
    }
    
    return self;
}

-(id<IClientSocket>) getCtrlSvrSocket
{
    return m_clientSocket;
}

#pragma mark - service function

// 发送response消息
- (void) sendResponseMsg: (DWORD)dwCommand sequenceID: (DWORD) dwSequenceID status: (int)nStatus failedReason:(const char*)szFailedReason
{
    BYTE* pRespBuffer;
    size_t len = 0;
    
    if (szFailedReason) len = strlen(szFailedReason);
    pRespBuffer = new BYTE [len + 4];
    nStatus = htonl(nStatus);
    memcpy(pRespBuffer, &nStatus, 4);
    if(szFailedReason) memcpy(pRespBuffer, szFailedReason, len);
    
    [m_clientSocket SendData:dwCommand sequenceID:dwSequenceID sendData:pRespBuffer dataSize:(len + 4)];
    
    delete[] pRespBuffer;
    pRespBuffer = NULL;    
}


#pragma mark - socket read data
- (BOOL)OnSocketRead:(CMDCOMMAND *)pCommand readData:(void *)pDataBuffer dataSize:(WORD)wDataSize
{
    if (m_clientStatusMgr)
    {
        [m_clientStatusMgr didReceiveMsg];
    }

    switch (pCommand->wCommandID)
    {
        case MSG_HEART_REQ:
            return [self didReceivedHeartReq:pCommand vpData:pDataBuffer dataSize:wDataSize];
        case CHAT_AUDIO_REQ:
            return [self didReceivedAudioReq:pCommand vpData:pDataBuffer dataSize:wDataSize];
        case CHAT_AUDIO_RESP:
            return [self didReceivedAudioResp:pCommand vpData:pDataBuffer dataSize:wDataSize];
        case CHAT_VIDEO_REQ:
            return [self didReceivedVideoReq:pCommand vpData:pDataBuffer dataSize:wDataSize];
        case CHAT_VIDEO_RESP:
            return [self didReceivedVideoResp:pCommand vpData:pDataBuffer dataSize:wDataSize];
        case UMSM_DOWNLOADFRIENDS_RESP:
            return [self didReceivedDownloadFriendsResp:pCommand vpData:pDataBuffer dataSize:wDataSize];
        default:
            break;
    }
    
    return YES;
}

- (void) OnSocketConnect:(NSInteger) errCode
{
}

- (void) OnSocketClose:(BOOL) bCloseByServer
{
    
}

#pragma mark - method for dispatching
- (BOOL)didReceivedHeartReq:(CMDCOMMAND *)pCommand vpData:(void *)pDataBuf dataSize:(WORD)wDataSize
{
    // 心跳回复
    return [m_clientStatusMgr didReceiveHeartReq];
}

- (BOOL)didReceivedHeartResp:(CMDCOMMAND *)pCommand vpData:(void *)pDataBuf dataSize:(WORD)wDataSize
{
    return [m_clientStatusMgr didReceiveHeartResp];
}

#pragma mark 登录response
- (BOOL)didReceivedLoginResp:(CMDCOMMAND *)pCommand vpData:(void *)pDataBuf dataSize:(WORD)wDataSize
{
    BYTE *pBuffer=(BYTE *)pDataBuf;
    
    DWORD checkCode=0;
    memcpy(&checkCode, pBuffer, 4);
    checkCode=ntohl(checkCode);
    pBuffer+=4;
    
    BYTE cBuffer[16];
    memcpy(cBuffer, pBuffer, 16);
    NSString *nameStr=[[NSString alloc] initWithBytes:cBuffer length:16 encoding:NSUTF8StringEncoding];
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
    [arr addObject:[NSNumber numberWithUnsignedInt:checkCode]];
    [arr addObject:nameStr];
    [nameStr release];
    
    [viewController performSelectorOnMainThread:@selector(loginInResponse:) withObject:arr waitUntilDone:NO];
    
    if (checkCode != 0)
    {
        // 心跳测试
        if (m_clientStatusMgr)
        {
            [m_clientStatusMgr startPalmusTesting];
        }

    }
    return YES;
}

#pragma mark 登出response
- (BOOL)didReceivedLogoutResp:(CMDCOMMAND *)pCommand vpData:(void *)pDataBuf dataSize:(WORD)wDataSize
{
    if (wDataSize < 4) return FALSE;
    
    BYTE* pBuffer = (BYTE*) pDataBuf;
    
    int wStatus;
    memcpy(&wStatus, pBuffer, 4);
    wStatus = ntohl(wStatus);
    
    [viewController performSelectorOnMainThread:@selector(didReceiveLogoutResp:) withObject:[NSNumber numberWithUnsignedInt:wStatus] waitUntilDone:NO];
    
    return YES;
}

- (BOOL)didReceivedUserRegisterResp:(CMDCOMMAND *)pCommand vpData:(void *)pDataBuf dataSize:(WORD)wDataSize
{
    return NO;
}

- (BOOL)didReceivedTextResp:(CMDCOMMAND *)pCommand vpData:(void *)pDataBuf dataSize:(WORD)wDataSize
{
    if (wDataSize < 4) return FALSE;
    
    BYTE* pBuffer = (BYTE*) pDataBuf;
    
    int wStatus;
    memcpy(&wStatus, pBuffer, 4);
    wStatus = ntohl(wStatus);
    
    NSString* strFailedReason = nil;
    if (wDataSize > 4)
    {
        strFailedReason = [[[NSString alloc] initWithBytes:(pBuffer + 4) length:(wDataSize - 4) encoding:NSUTF8StringEncoding] autorelease];
    }

    [[self viewController] didReceiveTextMsgResp:wStatus withFailedReason:strFailedReason];
    return TRUE;
}

// 接收到音频数据请求
- (BOOL)didReceivedAudioReq:(CMDCOMMAND *)pCommand vpData:(void *)pDataBuf dataSize:(WORD)wDataSize
{
    if (!m_avManager)
    {
        // 返回失败rssponse
        [self sendResponseMsg:CHAT_AUDIO_RESP sequenceID:0 status:0 failedReason:"播放器未准备好"];
        return FALSE;
    }
    
    [m_avManager OnReceiveAudoData: pDataBuf withLength:wDataSize];

    // 返回成功response
    [self sendResponseMsg:CHAT_AUDIO_RESP sequenceID:0 status:1 failedReason:NULL];
    
    return TRUE;
}

- (BOOL)didReceivedAudioResp:(CMDCOMMAND *)pCommand vpData:(void *)pDataBuf dataSize:(WORD)wDataSize
{
    if (wDataSize < 4) return FALSE;
    
    BYTE* pBuffer = (BYTE*) pDataBuf;
    
    int wStatus;
    memcpy(&wStatus, pBuffer, 4);
    wStatus = ntohl(wStatus);
    
    NSString* strFailedReason = nil;
    if (wDataSize > 4)
    {
        strFailedReason = [[[NSString alloc] initWithBytes:(pBuffer + 4) length:(wDataSize - 4) encoding:NSUTF8StringEncoding] autorelease];
    }
    
    return [[self viewController] didReceiveAudioResp:wStatus withFailedReason:strFailedReason];
}

// 接收到视频数据请求
- (BOOL)didReceivedVideoReq:(CMDCOMMAND *)pCommand vpData:(void *)pDataBuf dataSize:(WORD)wDataSize
{
    return NO;
}

// 接收到视频数据回复
- (BOOL)didReceivedVideoResp:(CMDCOMMAND *)pCommand vpData:(void *)pDataBuf dataSize:(WORD)wDataSize
{
    return NO;
}


// 接收到下载好友列表请求
- (BOOL)didReceivedDownloadFriendsResp:(CMDCOMMAND *)pCommand vpData:(void *)pDataBuf dataSize:(WORD)wDataSize
{
    return NO;
}

@end

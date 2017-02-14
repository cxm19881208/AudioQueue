//
//  SocketProtocol.h
//  UU
//
//  Created by 常 贤明 on 13-12-4.
//  Copyright (c) 2013年 常 贤明. All rights reserved.
//

#ifndef UU_SocketProtocol_h
#define UU_SocketProtocol_h

#import "Typedef.h"

typedef enum {
    Close_byUser    = 0,    // 客户端手动关闭
    Close_byHeart,          // 心跳检测异常关闭
    Close_byServer,         // 服务器主动断开
    Close_byConnect         // 链接失败
}ServerCloseType;   // cxm 2015-03-13



@protocol ISinkDelegate;

@protocol ISocket <NSObject>

@optional
- (DWORD) getRemoteIP;
- (WORD) getRemotePort;
- (DWORD) getLocalIP;
- (WORD) getLocalPort;
- (int) getSocket;

- (void) setRemoteIP:(DWORD)dwIP andPort:(WORD)wPort;

- (void) setSinkDelegate:(id<ISinkDelegate>)sinkDelegate;

- (BOOL) connectSvr;
- (BOOL) connectToServer:(WORD)wPort svrIP:(DWORD)dwServerIP;

- (BOOL) sendBuffer:(BYTE *)pSendBuffer dataSize:(WORD) wDataSize;

- (void) closeSocket:(BOOL) bNotify;

@end

@protocol ISinkDelegate <NSObject>
@optional
- (void) onSocket:(id<ISocket>)sock didConnect:(NSInteger) errCode;
- (void) onSocket:(id<ISocket>)sock didConnectError:(NSString*)strErrMessage;
- (int)  onSocket:(id<ISocket>)sock didRead:(void *)pBuffer dataSize:(WORD)wSize;
- (void) onSocket:(id<ISocket>)sock didClose:(BOOL)bCloseByServer;
- (void) onSocket:(id<ISocket>)sock didReadError:(NSString*)strErrMessage;
- (BOOL)onSocketRead:(CMDCOMMAND *)pCommand readData:(void *)pDataBuffer dataSize:(WORD)wDataSize;
- (void) onSocketConnect:(NSInteger) errCode;
@end


#endif

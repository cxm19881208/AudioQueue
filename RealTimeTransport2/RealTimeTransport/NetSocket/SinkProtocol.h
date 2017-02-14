//
//  SinkProtocol.h
//  VideoMonitor
//
//  Created by hupo on 6/11/10.
//  Copyright 2010 deirlym. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "globaldef_i.h"

//////// SocketSink protocol ////////////////////////////////////
@protocol ISinkProtocol<NSObject>

@optional
- (void) OnSocketConnect:(NSInteger) errCode;
- (BOOL) OnSocketRead:(CMDCOMMAND *) pCommand readData:(void *) pDataBuffer dataSize:(WORD)wDataSize;
- (void) OnSocketClose:(BOOL) bCloseByServer;

@end

//// ClientSocket protocol ///////////////////////////////////
@protocol IClientSocket<NSObject>

@optional
- (BOOL) SetSocketSink:(id<ISinkProtocol>) sinkObj;
- (TSOCKETSTATE) GetConnectState;
- (BOOL) ConnectToServer:(NSString *) svrAddr svrPort:(WORD) wPort;
- (BOOL) ConnectToServer:(WORD) wPort svrIP:(DWORD) dwServerIP;
- (BOOL) SendData:(WORD) dwCommandID sequenceID:(WORD) dwSequenceID;
- (BOOL) SendData:(WORD)dwCommandID sequenceID:(WORD)dwSequenceID sendData:(BYTE *)pDataBuff dataSize:(WORD)wDataSize;
- (BOOL) SendData:(WORD)dwCommandID sequenceID:(WORD)dwSequenceID srcUserID:(DWORD)srcUserID desUserID:(DWORD)desUserID sendData:(BYTE *)pDataBuff dataSize:(WORD)wDataSize;
- (void) CloseSocket:(BOOL) bNotify;

@end




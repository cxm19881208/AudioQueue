//
//  ClientSocket.h
//  VideoMonitor
//
//  Created by hupo on 6/10/10.
//  Copyright 2010 deirlym. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThreadService.h"
#include "Globaldef_i.h"
#import "SinkProtocol.h"

///////////////////////////////////////////////////////////////////////////////////
@interface ClientSocket : CThreadService <IClientSocket>
{
@private
	id<ISinkProtocol>		objSink;					//sink interface object	
	
@private
	int						m_hSocket;					//Socket handle
	DWORD					m_dwServerIP;				//IP address
	WORD					m_wServerPort;				//Server listen port
	TSOCKETSTATE			m_SocketState;				
	
@private
	DWORD					m_dwState;					//Thread state
	BOOL					m_bCloseByServer;
    BOOL                    bNotifySink;
	
@private
	BYTE					m_cbRecvBuff[SOCKET_BUFFER];	//Recv buffer
	int						m_nRecvSize;					
}

- (BOOL) RepetitionRun;

//////////// Interface protocol function ////////////////////
- (BOOL) SetSocketSink:(id<ISinkProtocol>) sinkObj;
- (BOOL) ConnectSvr;
- (TSOCKETSTATE) GetConnectState;
- (BOOL) ConnectToServer:(NSString *) svrAddr svrPort:(WORD) wPort;
- (BOOL) ConnectToServer:(WORD) wPort svrIP:(DWORD) dwServerIP;
- (BOOL) SendData:(DWORD) dwCommandID sequenceID:(DWORD) dwSequenceID;
- (BOOL) SendData:(DWORD) dwCommandID sequenceID:(DWORD) dwSequenceID sendData:(BYTE *) pDataBuff dataSize:(WORD) wDataSize;
- (BOOL) SendData:(WORD)dwCommandID sequenceID:(WORD)dwSequenceID srcUserID:(DWORD)srcUserID desUserID:(DWORD)desUserID sendData:(BYTE *)pDataBuff dataSize:(WORD)wDataSize;
- (void) CloseSocket:(BOOL) bNotify;

///////////////// Socket read or write function ///////////////////////
- (void) OnSocketRead;


@end

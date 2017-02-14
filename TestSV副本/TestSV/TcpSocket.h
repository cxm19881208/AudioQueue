//
//  TcpSocket.h
//  UU
//
//  Created by 常 贤明 on 13-12-4.
//  Copyright (c) 2013年 常 贤明. All rights reserved.
//

#import "USocket.h"

@interface TcpSocket : USocket
{
    id<ISinkDelegate>       m_sinkDelegate;
    
	int						m_hSocket;					//Socket handle
    int                     m_clientScoket;
	DWORD					m_dwServerIP;				//IP address
	WORD					m_wServerPort;				//Server listen port
	TSOCKETSTATE			m_SocketState;
	
	DWORD					m_dwState;					//Thread state
	BOOL					m_bCloseByServer;
    BOOL                    bNotifySink;
	
	BYTE					m_cbRecvBuff[SOCKET_BUFFER_BUFSIZE];	//Recv buffer
	int						m_nRecvSize;
}
@end

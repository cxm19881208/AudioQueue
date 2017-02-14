//
//  TcpSocket.m
//  UU
//
//  Created by 常 贤明 on 13-12-4.
//  Copyright (c) 2013年 常 贤明. All rights reserved.
//

#import "TcpSocket.h"
#import "IMEntity.h"
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <netinet/tcp.h>
#include <net/if.h>
#include <ifaddrs.h>

#define _DEBUG  1

@implementation TcpSocket

- (id) init
{
	if(self=[super init])
	{
		m_hSocket=INVALID_SOCKET;
		m_dwServerIP=0;
		m_SocketState=ENotConnected;
		m_dwState = TS_WAIT;
		m_bCloseByServer=NO;
        m_nRecvSize = 0;
        m_sinkDelegate = nil;
	}
	return self;
}

- (BOOL) repetitionRun
{
	switch (m_dwState)
	{
		case TS_RECV:
			[self onSocketRead];
			break;
		case TS_WAIT:
			[NSThread sleepForTimeInterval:0.5];
			break;
		case TS_CONN:
            [self connectSvr];
			break;
		default:
			break;
	}
    
	return YES;
}

- (DWORD) getLocalIP
{
    struct sockaddr_in sockAddr;
    socklen_t length;
    if (m_hSocket!=INVALID_SOCKET) {
        getsockname(m_hSocket, (struct sockaddr *)&sockAddr, &length);
        return sockAddr.sin_addr.s_addr;
    }
    return 0;
}

- (WORD) getLocalPort
{
    struct sockaddr_in sockAddr;
    socklen_t length;
    if (m_hSocket!=INVALID_SOCKET) {
        getsockname(m_hSocket, (struct sockaddr *)&sockAddr, &length);
        return sockAddr.sin_port;
    }
    return 0;
}

- (DWORD) getRemoteIP
{
    return m_dwServerIP;
}

- (WORD) getRemotePort
{
    return htons(m_wServerPort);
}

- (int) getSocket
{
    return m_hSocket;
}

- (void) setSinkDelegate:(id<ISinkDelegate>)sinkDelegate
{
    m_sinkDelegate = sinkDelegate;
}

- (void) setRemoteIP:(DWORD)dwIP andPort:(WORD)wPort
{
    m_dwServerIP = dwIP;
    m_wServerPort = wPort;
}

- (void) connectNotify:(NSInteger) nErrCode
{
    if (m_sinkDelegate)
    {
        [m_sinkDelegate onSocket:self didConnect:nErrCode];
    }
}

//Connect to server
- (BOOL) connectSvr
{
    NSLog(@"开始连接。。。");
	if(m_hSocket != INVALID_SOCKET)
	{
		[self closeSocket:NO];
	}
	m_hSocket = socket(AF_INET,SOCK_STREAM, 0);
	if(m_hSocket == INVALID_SOCKET)
	{
		NSLog(@"Create socket faild,socket");
		return NO;
	}
    
	struct sockaddr_in sockaddrin;
	sockaddrin.sin_family = AF_INET;
	//sockaddrin.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
    sockaddrin.sin_addr.s_addr=m_dwServerIP;
	sockaddrin.sin_port = htons(m_wServerPort);
	bzero(&(sockaddrin.sin_zero), 8);
    
    if (bind(m_hSocket, (struct sockaddr *)&sockaddrin, sizeof(sockaddrin))==0)
    {
        
    }
    
    int err;
//    int kOne = 1;
//    err = setsockopt(m_hSocket, IPPROTO_TCP, TCP_NODELAY, &kOne, sizeof(kOne));
    
    int resue = 1;
    err = setsockopt(m_hSocket, SOL_SOCKET, SO_REUSEADDR, &resue, sizeof(resue));
    
    // Prevent SIGPIPE signals ,阻止sigpipe信号
    /*有时候用户按下home键，socket不会断开，但是其实连接已经关闭了，
     前端并不知道这个连接已经断开了，继续通过断开的socket发送消息，这时候send函数会触发SIGPIPE异常导致程序崩溃。
     所以这里设置，阻止这个异常抛出。
     正常情况下send函数返回-1表示发送失败，但是在IOS上SIGPIPE在send返回之前就终止了进程，所以我们需要忽略SIGPIPE，让send正常返回-1，然后重新连接服务器。
     */
//    int nosigpipe = 1;
//    setsockopt(m_hSocket, SOL_SOCKET, SO_NOSIGPIPE, &nosigpipe, sizeof(nosigpipe));
//    
//    linger m_sLinger;
//    m_sLinger.l_onoff = 1; // (在closesocket()调用,但是还有数据没发送完毕的时候容许逗留)
//    m_sLinger.l_linger = 0; // (容许逗留的时间为0秒)
//    setsockopt(m_hSocket, SOL_SOCKET, SO_LINGER,  (const char*)&m_sLinger, sizeof(linger));
    
    
    if (err < 0)
    {
        err = errno;
        printf("setsockopt failed,[TCP_NODELAY][%d]",err);
    }
    
	//int nRet=connect(m_hSocket,(struct sockaddr *)&sockaddrin,sizeof(struct sockaddr));
    // Listen
    int nRet = listen(m_hSocket, 1024);
	if(nRet==SOCKET_ERROR)
	{
		[self closeSocket:NO];
#ifdef _DEBUG
		NSLog(@"Connect faild,notify...");
#endif
		[self connectNotify:(NSInteger)errno];
		return NO;
	}
    WORD addrlen = sizeof(struct sockaddr_in);
    socklen_t *len = (socklen_t *)&addrlen;
    m_clientScoket=accept(m_hSocket,(struct sockaddr*)&sockaddrin,len);
    //m_clientScoket = accept(m_hSocket, (struct sockaddr *)&sockaddrin,sizeof(struct sockaddr));
    if(m_clientScoket<=0)
    {
        fprintf(stderr,"Accept Error:%s\n",strerror(errno));
    }
    
	m_dwState = TS_RECV;
	m_SocketState = EConnected;
#ifdef _DEBUG
	NSLog(@"Connect successed,start waiting read data...");
#endif
    
    bNotifySink = YES;
	[self connectNotify:0];
	return YES;
}

- (BOOL) connectToServer:(WORD)wPort svrIP:(DWORD)dwServerIP
{
	m_dwServerIP=dwServerIP;
	m_wServerPort=wPort;
	
	m_SocketState=EConnecting;
    m_dwState=TS_CONN;
    
    // cxm 2017-01-20
    if (!self.bRuning) {
        [self startThread];
    }
    
	return YES;
}

- (BOOL) sendBuffer:(BYTE *) pSendBuffer dataSize:(WORD) nDataSize
{
	int nSendSize=0;
	while(nSendSize<nDataSize)
	{
		int nRet=(int)send(m_clientScoket,pSendBuffer+nSendSize,nDataSize - nSendSize,0);
		if(nRet==SOCKET_ERROR)
			return NO;
		nSendSize+=nRet;
	}
	return YES;
}

- (void) closeSocket:(BOOL)bNotify
{
    bNotifySink=bNotify;
    
	if(m_hSocket!=INVALID_SOCKET)
	{
		close(m_hSocket);
		m_hSocket=INVALID_SOCKET;
	}
    else
    {
        return;
    }
	m_nRecvSize = 0;
	m_SocketState = ENotConnected;
    
    m_bCloseByServer=NO;
    m_dwState = TS_WAIT;
    
	// notify sink
	if(bNotifySink)
    {
        if (m_sinkDelegate)
        {
            [m_sinkDelegate onSocket:self didClose:m_bCloseByServer];
        }
    }
	
}

- (void) onSocketRead
{
	try
	{
		int nErrCode =recv(m_clientScoket,m_cbRecvBuff+m_nRecvSize,sizeof(m_cbRecvBuff)-m_nRecvSize,0);
		if(nErrCode<=0)
		{
            NSLog(@"KA~KA~KA`KA~ ~ ~");
			m_bCloseByServer=YES;
			[self closeSocket:bNotifySink];
#ifdef _DEBUG
            NSLog(@"*******Net shutdown---[%d]-----",nErrCode);
#endif
			return;
		}
		
		m_nRecvSize +=nErrCode;
		WORD wPackageSize=0;
		
		CMDHEAD * pHead=(CMDHEAD *)m_cbRecvBuff;
		while(m_nRecvSize >=sizeof(CMDHEAD))
		{
			wPackageSize = (WORD)ntohs(pHead->wTotalLength);
			if(wPackageSize > (SOCKET_PACKAGE_BUFSIZE + sizeof(CMDHEAD)))
            {
#ifdef _DEBUG
                NSLog(@"*******数据包太大---[%d]-----",wPackageSize);
#endif
				throw "数据包太大";
            }
			if(wPackageSize<sizeof(CMDHEAD))
            {
#ifdef _DEBUG
                NSLog(@"*******数据包太小----[%d]----",wPackageSize);
#endif
				throw "数据包太小";
            }
			if(m_nRecvSize < wPackageSize)
            {
				return;
            }
			
			CMDCOMMAND command;
			command.wCommandID=ntohs(pHead->wCommandID);
			command.wSequenceID=ntohs(pHead->wSequenceID);
			
			WORD wDataSize=wPackageSize-sizeof(CMDHEAD);
			m_nRecvSize-=wPackageSize;
			BOOL bSuccess=[m_sinkDelegate onSocketRead:&command readData:m_cbRecvBuff+sizeof(CMDHEAD) dataSize:wDataSize];
			if(bSuccess==NO){throw "Read data process faild";}
            
            if(m_nRecvSize>0)
				memcpy(m_cbRecvBuff, m_cbRecvBuff+wPackageSize, m_nRecvSize);
		}
	}
	catch (...)
	{
		[self closeSocket:bNotifySink];
#ifdef _DEBUG
        NSLog(@"*******Socket read exceptin---***-----");
#endif
	}
}

@end

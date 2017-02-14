//
//  ClientSocket.mm
//  VideoMonitor
//
//  Created by hupo on 6/10/10.
//  Copyright 2010 deirlym. All rights reserved.
//

#include <sys/types.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <netinet/tcp.h>

#import "ClientSocket.h"

///////////////////////////////////////////////////////////////////////////////
#define TS_WAIT		0
#define TS_RECV		1
#define TS_CONN		2

@implementation ClientSocket

- (id) init
{
	if(self=[super init])
	{
		m_hSocket=INVALID_SOCKET;
		m_dwServerIP=0;
		m_SocketState=ENotConnected;
		m_dwState = TS_WAIT;
		m_bCloseByServer=NO;
	}
	return self;
}

- (void) SetSinkObject:(id) sinkObj
{
	objSink = sinkObj;
}

- (BOOL) RepetitionRun
{	
	switch (m_dwState)
	{
		case TS_RECV:	
			[self OnSocketRead];
			break;
		case TS_WAIT:
			[NSThread sleepForTimeInterval:0.5];
			break;
		case TS_CONN:
            [self ConnectSvr];
			break;
		default:
			break;
	}	
		
	return YES;
}

//////////// Interface protocel function ////////////////////
- (BOOL) SetSocketSink:(id<ISinkProtocol>) sinkObj
{
	if(sinkObj==nil)
		return NO;
	objSink=sinkObj;
	
	return YES;
}
- (TSOCKETSTATE) GetConnectState
{
	return m_SocketState;
}

- (void) ConnectNotify:(NSInteger) nErrCode
{	
	[objSink OnSocketConnect:nErrCode];
}

//Connect to server
- (BOOL) ConnectSvr
{
	if(m_hSocket != INVALID_SOCKET)
	{
		[self CloseSocket:NO];
	}
	m_hSocket =socket(AF_INET,SOCK_STREAM,0);
	if(m_hSocket == INVALID_SOCKET)
	{
		NSLog(@"Create socket faild,socket");
		return NO;
	}
    
	sockaddr_in sockaddrin;
	sockaddrin.sin_family=AF_INET;
	sockaddrin.sin_addr.s_addr=m_dwServerIP;
	sockaddrin.sin_port=htons(m_wServerPort);
	bzero(&(sockaddrin.sin_zero),8);
    
        
	int nRet=connect(m_hSocket,(struct sockaddr *)&sockaddrin,sizeof(struct sockaddr));
	if(nRet==SOCKET_ERROR)
	{	
		[self CloseSocket:NO];	
#ifdef _DEBUG
		NSLog(@"Connect faild,notify...");
#endif
		[self ConnectNotify:(NSInteger)errno];
		return NO;
	}
    
    int err; 
    int kOne = 1;  
    err = setsockopt(m_hSocket, IPPROTO_TCP, TCP_NODELAY, &kOne, sizeof(kOne)); 
    if (err < 0)
    {     
        err = errno; 
        printf("setsockopt failed,[TCP_NODELAY][%d]",err);
    }
    
    /*有时候用户按下home键，socket不会断开，但是其实连接已经关闭了，
     前端并不知道这个连接已经断开了，继续通过断开的socket发送消息，这时候send函数会触发SIGPIPE异常导致程序崩溃。
     所以这里设置，阻止这个异常抛出。
     正常情况下send函数返回-1表示发送失败，但是在IOS上SIGPIPE在send返回之前就终止了进程，所以我们需要忽略SIGPIPE，让send正常返回-1，然后重新连接服务器。
     */
    int nosigpipe = 1;
    setsockopt(m_hSocket, SOL_SOCKET, SO_NOSIGPIPE, &nosigpipe, sizeof(nosigpipe));
    
	m_dwState = TS_RECV;
	m_SocketState=EConnected;
#ifdef _DEBUG
	NSLog(@"Connect successed,start waiting read data...");
#endif
    
    bNotifySink=YES;
	[self ConnectNotify:0];
    
	return YES;
}

- (BOOL) ConnectToServer:(NSString *) svrAddr svrPort:(WORD) wPort
{	
	DWORD dwIP =inet_addr([svrAddr UTF8String]);
	if(dwIP==INADDR_NONE)
	{
		struct hostent * phost= gethostbyname([svrAddr UTF8String]);
		if(!phost)
			return NO;
#ifdef _DEBUG
		NSLog(@"Get server ip address success");
#endif
		struct in_addr ** pList=(struct in_addr **)phost->h_addr_list;
		NSString * addrIP=[[NSString alloc] initWithUTF8String:inet_ntoa(*pList[0])];
		dwIP =(DWORD)inet_addr([addrIP UTF8String]);
        [addrIP release];
                           
	}

	m_dwServerIP=dwIP;
	m_wServerPort=wPort;
	m_SocketState=EConnecting;
    m_dwState=TS_CONN;
	return YES;
}

- (BOOL) ConnectToServer:(WORD) wPort svrIP:(DWORD) dwServerIP
{
	m_dwServerIP=dwServerIP;	
	m_wServerPort=wPort;
	
	m_SocketState=EConnecting;
    m_dwState=TS_CONN;
	return YES;
}

- (BOOL) SendBuffer:(BYTE *) pSendBuffer dataSize:(int) nDataSize
{
	int nSendSize=0;
	while(nSendSize<nDataSize)
	{
		int nRet=(int)send(m_hSocket,pSendBuffer+nSendSize,nDataSize - nSendSize,0);
		if(nRet==SOCKET_ERROR)
			return NO;
		nSendSize+=nRet;
	}
	return YES;
}

- (BOOL) SendData:(DWORD) dwCommandID sequenceID:(DWORD) dwSequenceID
{
	if(m_hSocket == INVALID_SOCKET)
		return NO;
	if(m_SocketState != EConnected)
		return NO;
	
	WORD wSendSize =0;
	CMDHEAD cmdHead;
    cmdHead.CmdInfo.wSyncHead=htons(0xaa55);
	cmdHead.wCommandID =htons((WORD)dwCommandID);
	cmdHead.wSequenceID=htons((WORD)dwSequenceID);
	wSendSize =sizeof(CMDHEAD);
	cmdHead.wTotalLength=htons(wSendSize);
	
	return [self SendBuffer:(BYTE *)&cmdHead dataSize:wSendSize];
}

- (BOOL) SendData:(DWORD) dwCommandID sequenceID:(DWORD) dwSequenceID sendData:(BYTE *) pDataBuff dataSize:(WORD) wDataSize
{
	if(m_hSocket == INVALID_SOCKET)
		return NO;
	if(m_SocketState != EConnected)
		return NO;
	
	if(wDataSize + sizeof(CMDHEAD)>SEND_BUFSIZE)
		return NO;
	
	BYTE cbDataBuffer[SOCKET_BUFFER];
	WORD wSendSize=0;
    CMDHEAD * pHead=(CMDHEAD *)cbDataBuffer;
	pHead->CmdInfo.wSyncHead = htons(0xaa55);
	pHead->wCommandID=htons((WORD)dwCommandID);
	pHead->wSequenceID=htons((WORD)dwSequenceID);
	
	if (wDataSize>0)
	{		
		memcpy(pHead+1,pDataBuff,wDataSize);
	}
	
	wSendSize=sizeof(CMDHEAD)+wDataSize;
	pHead->wTotalLength=htons(wSendSize);
	
	return [self SendBuffer:cbDataBuffer dataSize:wSendSize];
}

- (BOOL) SendData:(WORD)dwCommandID sequenceID:(WORD)dwSequenceID srcUserID:(DWORD)srcUserID desUserID:(DWORD)desUserID sendData:(BYTE *)pDataBuff dataSize:(WORD)wDataSize
{
    if(m_hSocket == INVALID_SOCKET)
		return NO;
    
	if(m_SocketState != EConnected)
		return NO;
	
	if(wDataSize + sizeof(CMDHEAD)+sizeof(srcUserID)+sizeof(desUserID)>SOCKET_BUFFER)
		return NO;
	
	BYTE cbDataBuffer[SOCKET_BUFFER];
	WORD wSendSize=wDataSize+sizeof(CMDHEAD)+sizeof(srcUserID)+sizeof(desUserID);
    CMDHEAD * pHead=(CMDHEAD *)cbDataBuffer;
	pHead->CmdInfo.wSyncHead = htons(0xaa55);
	pHead->wCommandID=htons((WORD)dwCommandID);
	pHead->wSequenceID=htons((WORD)dwSequenceID);
	pHead->wTotalLength=htons(wSendSize);
    
    srcUserID=htonl(srcUserID);
    desUserID=htonl(desUserID);
    memcpy(cbDataBuffer+sizeof(CMDHEAD),&srcUserID,sizeof(srcUserID));
    memcpy(cbDataBuffer+sizeof(CMDHEAD)+sizeof(srcUserID),&desUserID,sizeof(desUserID));
	
	if (wDataSize>0)
	{
		memcpy(cbDataBuffer+sizeof(CMDHEAD)+sizeof(srcUserID)+sizeof(desUserID),pDataBuff,wDataSize);
	}
	
	return [self SendBuffer:cbDataBuffer dataSize:wSendSize];
}

- (void) CloseSocket:(BOOL) bNotify
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
	m_SocketState=ENotConnected;

	//notify sink
	if(bNotifySink)
		[objSink OnSocketClose:m_bCloseByServer];
	
	m_bCloseByServer=NO;	
	m_dwState = TS_WAIT;
}

///////////////// Socket read or write function ///////////////////////
- (void) OnSocketRead
{
	try
	{
        // ssize_t	recv(int, void *, size_t, int) __DARWIN_ALIAS_C(recv);
        // 第一个参数：socket对象；第二个参数：接收到的数据放置处；第三个参数：告诉socket自己最多接收的数据
		int nErrCode =recv(m_hSocket,m_cbRecvBuff+m_nRecvSize,sizeof(m_cbRecvBuff)-m_nRecvSize,0);
		if(nErrCode<=0)
		{
			m_bCloseByServer=YES;
			[self CloseSocket:bNotifySink];
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
			wPackageSize=(WORD) ntohs(pHead->wTotalLength);
			if(wPackageSize>(SOCKET_PACKAGE+sizeof(CMDHEAD)))
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
            // 接收到的数据不足一个完整的包，return 继续接收
			if(m_nRecvSize<wPackageSize)
            {
				return;
            }
			
			CMDCOMMAND command;
			command.wCommandID=ntohs(pHead->wCommandID);
			command.wSequenceID=ntohs(pHead->wSequenceID);
			
			WORD wDataSize=wPackageSize-sizeof(CMDHEAD);
			m_nRecvSize -=wPackageSize;
			BOOL bSuccess=[objSink OnSocketRead:&command readData:m_cbRecvBuff+sizeof(CMDHEAD) dataSize:wDataSize];
			if(bSuccess==NO) throw "Read data process faild";
            
            // 防治这次接收的包，包含下次包的数据，即接收到了过多的数据。
            if(m_nRecvSize>0)
				memcpy(m_cbRecvBuff, m_cbRecvBuff+wPackageSize, m_nRecvSize);
		}
	}
	catch (...)
	{
		[self CloseSocket:bNotifySink];
#ifdef _DEBUG
        NSLog(@"*******Socket read exceptin---***-----");
#endif
	}
}

@end

//
//  AppDelegate.m
//  TestSV
//
//  Created by changxm on 14-4-2.
//  Copyright (c) 2014年 changxm. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
{
    NSString*   ipStr;
    int         port;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    tsocket = [[TcpSocket alloc] init];
    [tsocket setSinkDelegate:self];
    [tsocket startThread];
    
    //[NSThread sleepForTimeInterval:1.0];
    sleep(1.);
    //[tsocket connectToServer:5000 svrIP:[NetTool convertIPAddress:@"127.0.0.1"]];
    /*ip地址是本机局域网地址*/
    port = 5000;
    ipStr = @"192.168.9.100";
    [tsocket connectToServer:port svrIP:[NetTool convertIPAddress:ipStr]];
    self.ipLabel.placeholderString = [NSString stringWithFormat:@"监听ip：%@",ipStr];
    self.portLabel.placeholderString = [NSString stringWithFormat:@"监听端口：%d",port];
    self.statusLabel.placeholderString = [NSString stringWithFormat:@"等待客户端连接..."];
}

#define HEAD_OFFSET sizeof(CMDHEAD)
- (BOOL)onSocketRead:(CMDCOMMAND *)pCommand readData:(void *)pDataBuffer dataSize:(WORD)wDataSize
{
    // 读到什么数据再把这些数据完整的返回回去
    BYTE buffer[1024];
    CMDHEAD * pHead = (CMDHEAD *)buffer;
	pHead->CmdInfo.wSyncHead = htons(0xaa55);
    pHead->wCommandID = htons(pCommand->wCommandID);
	pHead->wSequenceID = htonl(0);
    
    BYTE* pBuf = buffer + HEAD_OFFSET;
    memcpy(pBuf, pDataBuffer, wDataSize);
    pBuf += wDataSize;
    WORD size = (WORD)(pBuf - buffer);
    
    pHead->wTotalLength = htons(size);
    BOOL bSuccess = [tsocket sendBuffer:buffer dataSize:size];
    
    return YES;
    
    BYTE* pBuffer = (BYTE*) pDataBuffer;
    UNDWORD sourceid;
    memcpy(&sourceid, pBuffer, sizeof(sourceid));
    pBuffer+=sizeof(sourceid);
    sourceid = [NetTool ntohl64:sourceid];
    NSLog(@"sourceid:%llu",sourceid);
    return YES;
}

- (void) onSocket:(id<ISocket>)sock didConnect:(NSInteger) errCode
{
    NSLog(@"链接成功code:%ld",(long)errCode);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (errCode==0) {
            self.statusLabel.placeholderString = @"监听成功,等待客户端数据...";
        }
        else {
            self.statusLabel.placeholderString = @"监听失败.";
        }
    });
}

- (void) onSocket:(id<ISocket>)sock didClose:(BOOL)bCloseByServer
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusLabel.placeholderString = @"服务器断开.请重启程序.";
    });
    
}

@end

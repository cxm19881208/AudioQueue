//
//  USocket.m
//  UU
//
//  Created by 常 贤明 on 13-12-14.
//  Copyright (c) 2013年 常 贤明. All rights reserved.
//

#import "USocket.h"

@implementation USocket

- (DWORD) getRemoteIP
{
    NSLog(@"%@", @"Error: no implement!");
    return 0;
}

- (WORD) getRemotePort
{
    NSLog(@"%@", @"Error: no implement!");
    return 0;
}

- (DWORD) getLocalIP
{
    NSLog(@"%@", @"Error: no implement!");
    return 0;
}

- (WORD) getLocalPort
{
    NSLog(@"%@", @"Error: no implement!");
    return 0;
}

- (int) getSocket
{
    NSLog(@"%@", @"Error: no implement!");
    return ~((DWORD)0);
}

- (void) setRemoteIP:(DWORD)dwIP andPort:(WORD)wPort
{
    NSLog(@"%@", @"Error: no implement!");
}

- (void) setSinkDelegate:(id<ISinkDelegate>)sinkDelegate
{
    NSLog(@"%@", @"Error: no implement!");
}

- (BOOL) connectSvr
{
    NSLog(@"%@", @"Error: no implement!");
    return NO;
}

- (BOOL) connectToServer:(WORD)wPort svrIP:(DWORD)dwServerIP
{
    NSLog(@"%@", @"Error: no implement!");
    return NO;
}

- (BOOL) sendBuffer:(BYTE *)pSendBuffer dataSize:(WORD) wDataSize
{
    NSLog(@"%@", @"Error: no implement!");
    return NO;
}

- (void) closeSocket:(BOOL) bNotify
{
    NSLog(@"%@", @"Error: no implement!");    
}

@end

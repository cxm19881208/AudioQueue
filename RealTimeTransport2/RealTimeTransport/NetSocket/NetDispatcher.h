//
//  NetDispatcher.h
//  RealTimeTransport
//
//  Created by 常 贤明 on 13-4-17.
//  Copyright (c) 2013年 常 贤明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClientSocket.h"
#import "Globaldef_i.h"
#import "SinkProtocol.h"

@class ClientSocket;
@class ViewController;
@class AVManager;
@class ClientStatusManager;

@interface NetDispatcher : NSObject<ISinkProtocol>
{
    ClientSocket            *clientSocket;
    id<IClientSocket>       m_clientSocket;
    ClientStatusManager*    m_clientStatusMgr;
}

@property (nonatomic, assign) ViewController              *viewController;
@property (nonatomic, assign) AVManager                   *m_avManager;

// 获取socket
-(id<IClientSocket>) getCtrlSvrSocket;

@end

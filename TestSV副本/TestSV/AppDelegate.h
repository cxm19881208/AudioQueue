//
//  AppDelegate.h
//  TestSV
//
//  Created by changxm on 14-4-2.
//  Copyright (c) 2014年 changxm. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TcpSocket.h"

@interface AppDelegate : NSObject <NSApplicationDelegate,ISinkDelegate>
{
    TcpSocket* tsocket;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextField*    ipLabel;
@property (assign) IBOutlet NSTextField*    portLabel;
@property (assign) IBOutlet NSTextField*    statusLabel;

@end

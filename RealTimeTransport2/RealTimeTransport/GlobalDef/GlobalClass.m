//
//  GlobalClass.m
//  RealTimeTransport
//
//  Created by 常 贤明 on 4/9/13.
//  Copyright (c) 2013 常 贤明. All rights reserved.
//

#import "GlobalClass.h"

@implementation CMD_Head
@synthesize wSync;
@synthesize wSequence;
@synthesize wLength;
@synthesize wCmd;

- (id) init
{
    self = [super init];
    
    if (self)
    {
        self.wSync = ERROR_VALUE;
        self.wSequence = ERROR_VALUE;
        self.wLength = ERROR_VALUE;
        self.wCmd = ERROR_VALUE;
    }
    
    return self;
}

- (void) dealloc
{
    [super dealloc];
}
@end

@implementation UserInfo
@synthesize strUserName;
@synthesize strPassWord;
@synthesize uUserid;
@synthesize strMail;

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.strUserName = nil;
        self.strPassWord = nil;
        self.uUserid = ERROR_VALUE;
        self.strMail = nil;
    }
    
    return self;
}

- (void) dealloc
{
    if ([self strUserName]) [strUserName release];
    if ([self strPassWord]) [strPassWord release];
    if ([self strMail]) [strMail release];
    
    [super dealloc];
}

@end

@implementation RequestMessage
@synthesize strUserInfo;
@synthesize strCheckCode;
@synthesize strMsg;
@synthesize audioData;
@synthesize videoData;

- (id) init
{
    self = [super init];
    
    if (self)
    {
        strUserInfo = nil;
        strCheckCode = nil;
        strMsg = nil;
        audioData = nil;
        videoData = nil;
    }
    
    return self;
}

- (void) dealloc
{
    if ([self strUserInfo]) [strUserInfo release];
    if ([self strCheckCode]) [strCheckCode release];
    if ([self strMsg]) [strMsg release];
    if ([self audioData]) [audioData release];
    if ([self videoData]) [videoData release];
    
    [super dealloc];
}
@end

@implementation ResponseMessage
@synthesize uStatus;
@synthesize uUserId;
@synthesize uCallType;
@synthesize strReason;

- (id) init
{
    self = [super init];
    
    if (self)
    {
        self.uStatus = ERROR_VALUE;
        self.uUserId = ERROR_VALUE;
        self.uCallType = ERROR_VALUE;
        self.strReason = nil;
    }
    
    return self;
}

- (void) dealloc
{
    if ([self strReason]) [strReason release];
    
    [super dealloc];
}
@end
//
//  GlobalClass.h
//  RealTimeTransport
//
//  Created by 常 贤明 on 4/9/13.
//  Copyright (c) 2013 常 贤明. All rights reserved.
//

#import <Foundation/Foundation.h>

// Add by Alevinno 2013-04-12 start

#include "Globaldef_i.h"

@interface CMD_Head : NSObject

@property (nonatomic, assign) DWORD wSync;		//同步头
@property (nonatomic, assign) DWORD wSequence;	//关联request和response
@property (nonatomic, assign) DWORD wLength;     //消息体长度
@property (nonatomic, assign) DWORD wCmd;		//消息命令

- (id) init;

@end

@interface UserInfo : NSObject

@property (nonatomic, retain) NSString* strUserName;
@property (nonatomic, retain) NSString* strPassWord;
@property (nonatomic, assign) DWORD    uUserid;
@property (nonatomic, retain) NSString* strMail;

- (id) init;
@end


@interface RequestMessage : NSObject

@property (nonatomic, retain) UserInfo* strUserInfo;
@property (nonatomic, retain) NSString* strCheckCode;
@property (nonatomic, retain) NSString* strMsg;
@property (nonatomic, retain) NSData*   audioData;
@property (nonatomic, retain) NSData*   videoData;

- (id) init;
@end

@interface ResponseMessage : NSObject

@property (nonatomic, assign) DWORD        uStatus;
@property (nonatomic, assign) DWORD        uUserId;
@property (nonatomic, assign) DWORD        uCallType;
@property (nonatomic, retain) NSString*   strReason;

- (id) init;
@end


@interface GlobalClass : NSObject

@end

//
//  Globaldef_i.h
//  RealTimeTransport
//
//  Created by 常 贤明 on 4/9/13.
//  Copyright (c) 2013 常 贤明. All rights reserved.
//

#ifndef RealTimeTransport_Globaldef_i_h
#define RealTimeTransport_Globaldef_i_h

#import <stdint.h>

typedef unsigned short WORD;
typedef unsigned int DWORD;
typedef unsigned char BYTE;
typedef unsigned long long UNDWORD;
typedef signed long long DWORD64;

#define SYNC_TAG                    0xaa55;          // 同步头标志

#define MSG_HEART_REQ               0x0000           // 心跳包请求
#define MSG_HEART_RESP              0x8000           // 心跳包回复
#define UMSM_LOGIN_REQ              0x0001           // 用户管理，用户登录请求
#define UMSM_LOGIN_RESP             0x8001           // 用户管理，用户登录回复
#define UMSM_LOGOUT_REQ             0x0002           // 用户管理，用户退出请求
#define UMSM_LOGOUT_RESP            0x8002           // 用户管理，用户退出回复
#define UMSM_REGISTER_REQ           0x0003           // 用户管理，用户注册请求
#define UMSM_REGISTER_RESP          0x8003           // 用户管理，用户注册回复
#define CHAT_CALLCTRL_REQ           0x0004           // 呼叫控制请求
#define CHAT_CALLCTRL_RESP          0x8004           // 呼叫控制回复
#define CHAT_TEXT_REQ               0x0005           // 发送消息请求
#define CHAT_TEXT_RESP              0x8005           // 发送消息回复
#define CHAT_AUDIO_REQ              0x0006           // 发送音频数据
#define CHAT_AUDIO_RESP             0x8006           // 发送音频数据回复
#define CHAT_VIDEO_REQ              0x0007           // 发送视频数据
#define CHAT_VIDEO_RESP             0x8007           // 发送视频数据回复
#define UMSM_DOWNLOADFRIENDS_REQ    0x0009           // 好友列表下载请求
#define UMSM_DOWNLOADFRIENDS_RESP   0x8009           // 好友列表下载回复 

#define ERROR_VALUE                 0xFFFF;


#define kNumBuffers 6
#define audio_size  512

typedef enum
{
    AU_STOP = 0,
    AU_PAUSE,
    AU_PLAYING
}AudioState;

//Socket state enum
typedef enum TSocketState
{
	ENotConnected,
	EConnecting,
	EConnected,
	ETimedOut,
}TSOCKETSTATE;

typedef enum
{
    Call_None,
    Call_Send,
    Call_Receive,
    Call_Reject,
    Call_Hangup
}Call_Status;

//Package Command head struct
typedef struct CMD_Head
{
	union
	{
		WORD                wSyncHead;
		BYTE                cbSync[2];
	}CmdInfo;
    
	WORD					wSequenceID;
    WORD                    wTotalLength;
    WORD					wCommandID;
	
}CMDHEAD;


//Command head struct
typedef struct CMD_Command
{
	WORD					wSequenceID;
    WORD                    wTotalLength;
    WORD					wCommandID;
	
}CMDCOMMAND;

#define SOCKET_PACKAGE				(1024*50)  							//a package size
#define SOCKET_BUFFER				(SOCKET_PACKAGE+sizeof(CMDHEAD))   //recv buffer size
#define SEND_BUFSIZE				2048								//send data buffer size

#define INVALID_SOCKET				(DWORD)(~0)
#define SOCKET_ERROR				-1
#endif

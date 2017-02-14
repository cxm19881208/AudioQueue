//
//  IMEntity.h
//  UU
//
//  Created by 常 贤明 on 13-11-2.
//  Copyright (c) 2013年 常 贤明. All rights reserved.
//

#ifndef UU_IMEntity_h
#define UU_IMEntity_h

#import "TypeDef.h"

#define TS_WAIT		0
#define TS_RECV		1
#define TS_CONN		2

//#define CONFIG_AUDIO_UDP    1

#define HEAD_SYNC               0xaa55
#define PARSE_FAILED            (-1)
#define PACKETSIZE_TOOLARGE     (-2)
#define PACKETSIZE_TOOSMALL     (-3)


//Socket state enum
typedef enum TSocketState
{
	ENotConnected,
	EConnecting,
	EConnected,
	ETimedOut,
}TSOCKETSTATE;

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

#define SOCKET_PACKAGE_BUFSIZE      (1024*50)                                   //a package size
#define SOCKET_BUFFER_BUFSIZE		(SOCKET_PACKAGE_BUFSIZE+sizeof(CMDHEAD))    //recv buffer size
#define SEND_BUFSIZE				2048                                        //send data buffer size

#define INVALID_SOCKET				(DWORD)(~0)
#define SOCKET_ERROR				-1

#endif

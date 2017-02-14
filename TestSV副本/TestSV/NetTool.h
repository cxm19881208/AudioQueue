//
//  NetTool.h
//  UU
//
//  Created by 常 贤明 on 13-11-2.
//  Copyright (c) 2013年 常 贤明. All rights reserved.
//

#import "TypeDef.h"

@interface NetTool : NSObject

// 将本地字节序转换为网络字节序
+ (UNDWORD) htonl64:(UNDWORD)lluValue;

// 将网络字节序转换为本地字节序
+ (UNDWORD) ntohl64:(UNDWORD)lluSrc;

// 时间
+ (UNDWORD) getNowTime;

// 是否同一网段
+ (BOOL) isInSameLAN:(DWORD)dwPrivateIP_A privateIP_B:(DWORD)dwprivateIP_B publicIP_A:(DWORD)dwPublicIP_A publicIP_B:(DWORD)dwPublicIP_B mask_A:(DWORD)dwMask_A mask_B:(DWORD)dwMask_B;

// 获取子网掩码
+ (DWORD) getSubnetMaskFromSocket:(int)sock;

// 将点分十进制ip转换为数值ip
+ (DWORD) convertIPAddress:(NSString*)strIPAddr;

// 装饰数值ip转换为点分十进制
+ (NSString*) convertIPToString:(DWORD)dwIP;

// 将ip，端口号转为socket地址
+ (struct sockaddr_in) sockAddressFromIP:(DWORD)dwIP withPort:(WORD)wPort;

@end

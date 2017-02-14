//
//  ServerAddrConfig.h
//  GlobalType
//
//  Created by 常 贤明 on 13-9-30.
//  Copyright (c) 2013年 常 贤明. All rights reserved.
//

// 是否使用公网的开关
#define USING_PUBLIC    1

#if USING_PUBLIC

//网关
//获取控制服务器网关
#define CTRL_GATEWAY_IP             @"124.74.246.9"
#define CTRL_GATEWAY_PORT           38500

////获取接入服务器网关
//#define LINK_GATEWAY_IP             @"124.74.246.9"
//#define LINK_GATEWAY_PORT           8500
#define LINK_GATEWAY_IP             @"180.166.114.148"
#define LINK_GATEWAY_PORT           45000

#define P2PSERVER_IPADDR            @"124.74.246.9"
#define P2PSERVER_PORT              8200

#define P2PHELPSERVER_IPADDR        @"124.74.246.9"
#define P2PHELPSERVER_PORT          8801

//#define HTTP_ADDRESS                @"http://124.74.246.9/"

#else

//网关
//获取控制服务器网关
#define CTRL_GATEWAY_IP             @"192.168.9.92"
#define CTRL_GATEWAY_PORT           52588

#define CTRL_ACCESSSERVER_IP        @"192.168.9.94"
#define CTRL_ACCESSSERVER_PORT      40101

//获取接入服务器网关
#define LINK_GATEWAY_IP             @"192.168.9.80"
#define LINK_GATEWAY_PORT           10010

#define P2PSERVER_IPADDR            @"172.22.203.103"
#define P2PSERVER_PORT              8802

#define P2PHELPSERVER_IPADDR        @"172.22.203.103"
#define P2PHELPSERVER_PORT          8801

//#define HTTP_ADDRESS                @"http://192.168.9.80:8888/"

#endif

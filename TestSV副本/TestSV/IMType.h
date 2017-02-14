//
//  IMType.h
//  UU
//
//  Created by 常 贤明 on 13-11-2.
//  Copyright (c) 2013年 常 贤明. All rights reserved.
//

#ifndef UU_IMType_h
#define UU_IMType_h

#define SYNC_TAG                        0xaa55;         // 同步头标志

#define MAIN_COMMAND_SYSTEM             0X0             // 系统主命令字
#define MAIN_COMMAND_BALANCESVR         0x0002          // 负载均衡服务主命令字
#define MAIN_COMMOND_ASLOGIN            0x0003          // 接入服务器登陆主命令字
#define MAIN_COMMOND_CALLCONTROL        0x0004          // 呼叫控制主命令字
#define MAIN_COMMOND_AVCONTROL          0x000e          // 音视频通话
#define MAIN_COMMAND_TEXTMESSGAE        0x0005          // 文字消息
#define MAIN_COMMAND_TEAMTEXTMESSAGE    0x0006          // 群文字消息
#define MAIN_COMMAND_TEAMMEMBERCHANGE   0x0007          // 群成员变更通知
#define MAIN_COMMAND_SYSTEMNOTIFY       0x0008          // 系统通知


#define GATEWAY_REQ                     0x0504          // 从网关取控制服务器ip和port
#define GATEWAY_RESP                    0x8504          // 从网关取控制服务器ip和port response

#define MSG_HEART_REQ                   0x0000          // 心跳包请求
#define MSG_HEART_RESP                  0x8000          // 心跳包回复
#define UMSM_LOGIN_REQ                  0x0101          // 用户管理，用户登录请求
#define UMSM_LOGIN_RESP                 0x8101          // 用户管理，用户登录回复
#define UMSM_LOGOUT_REQ                 0x0104          // 用户退出客户端请求
#define UMSM_LOGOUT_RESP                0x8104          // 用户退出客户端回复
//#define UMSM_NONLOCAL_LOGIN_REQ         0x0901          // 异地登录通知
#define UMSM_NONLOCAL_LOGIN_RESP        0x8901          // 异地登录response

#define UMSM_REGISTER_REQ               0x0105          // 用户管理，用户注册请求
#define UMSM_REGISTER_RESP              0x8105          // 用户管理，用户注册回复
#define UMSM_DOWNLOADFRIENDS_REQ        0x0103          // 好友列表下载请求
#define UMSM_DOWNLOADFRIENDS_RESP       0x8103          // 好友列表下载回复

#define UMSM_MODIFYPASSWORD_REQ         0x0108          // 修改用户密码请求
#define UMSM_MODIFYPASSWORD_RESP        0x8108          // 修改用户密码回复
#define UMSM_MODIFYFRIENDPOLICY_REQ     0x0107          // 修改好友策略请求
#define UMSM_MODIFYFRIENDPOLICY_RESQ    0x8107          // 修改好友策略回复

#define UMSM_MODIFYHEADPORTRAIT_REQ     0x0109          // 修改用户头像请求
#define UMSM_MODIFYHEADPORTRAIT_RESP    0x8109          // 修改用户头像回复

/////////////////udp建立连接///////////////////////////
#define UDP_BUILD_CONNECT_REQ           0x0003         // udp与服务器建立连接
#define UDP_BUILD_CONNECT_RESP          0x8003         // udp与服务器建立连接response

//////////////////接入服务器//////////////////////////
#define ACCESS_REGISTER_REQ             0x0101          // 注册接入服务器
#define ACCESS_REGISTER_RESP            0x8101          // 注册接入服务器response
#define ACCESS_CANCEL_REQ               0x0102          // 注销接入服务器
#define ACCESS_CANCEL_RESP              0x8102          // 注销接入服务器response
#define ACCESS_SEND_MESSAGE_REQ         0x0701          // 发送消息
#define ACCESS_SEND_MESSAGE_RESP        0x8701          // 收到消息
#define ACCESS_EXCHANGE_NOTIFICATION    0x0721          // 交换名片通知

//////////////////聊天服务器//////////////////////////
#define CHATROOM_REGISTER_REQ           0x0801          // 注册聊天服务器请求
#define CHATROOM_REGISTER_RESP          0x8801          // 注册聊天服务器回复
#define CHATROOM_GETAUDIOROOMLIST_REQ   0x0804          // 获取聊天室用户列表
#define CHATROOM_GETAUDIOROOMLIST_RESP  0x8804          // 获取聊天室用户列表的回复
#define CHATROOM_USERCHANGE_REQ         0x0803          // 聊天室用户变更-request
#define CHATROOM_USERCAHNGE_RESP        0x8803          // 聊天室用户变更-response
#define CHATROOM_LOGINOUT_REQ           0x0802          // 注销聊天室-request(会议模式)
#define CHATROOM_LOGINOUT_RESP          0x8802          // 注销聊天室-response
#define CHATROOM_CSCLOGOUT_REQ          0x0808          // 注销聊天室-request(电话模式)
#define CHATROOM_CSCLOGOUT_RESP         0x8808          // 注销聊天室-response

#define CHAT_VIDEO_SWITCH_REQ           0x0806          // 开关视频
#define CHAT_VIDEO_SWITCH_RESP          0x8806          // 开关视频-response
#define CHAT_VIDEO_STATUS_REQ           0x0805          // 获取聊天室用户视频开关状态
#define CHAT_VIDEO_STATUS_RESP          0x8805          // 获取聊天室用户视频开关状态-response
#define CHAT_VIDEO_ASK_REQ              0x0807          // 请求(取消)视频
#define CHAT_VIDEO_ASK_RESP             0x8807          // 请求(取消)视频-response
#define CHAT_ONETOONE_VIDEO_SWITCH_REQ  0x0817          // 单人请求(取消)视频
#define CHAT_ONETOONE_VIDEO_SWITCH_RESP 0x8817          // 单人请求(取消)视频-response

#define CHAT_VIDEO_HEAD_REQ             0x0811          // 发送视频头
#define CHAT_VIDEO_HEAD_RESP            0x8811          // 发送视频头回复
#define CHAT_ONETOONE_VIDEO_HEAD_REQ    0x0809          // 发送单对单视频头
#define CHAT_ONETOONE_VIDEO_HEAD_RESP   0x8809          // 发送单对单视频头回复

#define CHAT_ONETOONE_VIDEO_REQ         0x0815          // 单对单发送视频数据
#define CHAT_ONETOONE_VIDEO_RESP        0x8815          // 单对单发送视频回复
#define CHAT_VIDEO_REQ                  0x0812          // 发送视频数据
#define CHAT_VIDEO_RESP                 0x8812          // 发送视频数据回复

#define CHAT_AUDIO_REQ                  0x0813          // 发送音频数据
#define CHAT_AUDIO_RESP                 0x8813          // 发送音频数据回复
#define CHAT_ONETOONE_AUDIO_REQ         0x0816          // 单对单发送音频数据
#define CHAT_ONETOONE_AUDIO_RESP        0x8816          // 单对单发送音频回复

/*没有用到*/
#define CHAT_STOP_TALK                  0x0808          //单人模式结束通话
#define CHAT_STOP_TALK_RESP             0x8808          //单人模式结束通话-response

#define CTRL_CTRLTYPE_GETWAN_REQ        0x0201          // 获取公网地址
#define CTRL_CTRLTYPE_GETWAN_RESP       0x8201          // 获取公网地址response
#define CTRL_CTRLTYPE_HOLE_RESULT_REQ   0x090D          // 打洞结果通知
#define CTRL_CTRLTYPE_HOLE_RESULT_RESP  0x890D          // 打洞结果通知response

/*nat信息交换相关*/
#define CTRL_CTRLTYPE_NET_CHECK         0x090F          // 网络检测 nat信息交换
#define CTRL_CTRLTYPE_CHECK_ANSWER      0x0910          // nat信息交换答复

/*电话模式-呼叫控制*/
#define CTRL_CTRLTYPE_CSC_ASK           0x0901          // 发起呼叫-电话模式
#define CTRL_CTRLTYPE_CSC_ASK_RESP      0x8901          // 发起呼叫-response
//#define CTRL_CTRLTYPE_CSC_PUSHCALL      0x0902          // 推送呼叫-电话模式
//#define CTRL_CTRLTYPE_CSC_PUSHCALL_RESP 0x8902          // 推送呼叫-response
#define CTRL_CTRLTYPE_CSC_ANSWER        0x0903          // 应答呼叫-电话模式
#define CTRL_CTRLTYPE_CSC_ANSWER_RESP   0x8903          // 应答呼叫-response
#define CTRL_CTRLTYPE_CSC_HANGUP        0x0904          // 挂断呼叫-电话模式
#define CTRL_CTRLTYPE_CSC_HANGUP_RESP   0x8904          // 挂断呼叫-response

/*P2P模式-呼叫控制*/
#define CTRL_CTRLTYPE_P2P_ASK           0x0905          // 发起呼叫-P2P模式
#define CTRL_CTRLTYPE_P2P_ASK_RESP      0x8905          // 发起呼叫-response
//#define CTRL_CTRLTYPE_P2P_PUSHCALL      0x0906          // 推送呼叫-P2P模式
//#define CTRL_CTRLTYPE_P2P_PUSHCALL_RESP 0x8906          // 推送呼叫-response
#define CTRL_CTRLTYPE_P2P_ANSWER        0x0907          // 应答呼叫-P2P模式
#define CTRL_CTRLTYPE_P2P_ANSWER_RESP   0x8907          // 应答呼叫-response
#define CTRL_CTRLTYPE_P2P_HANGUP        0x0908          // 挂断呼叫-P2P模式
#define CTRL_CTRLTYPE_P2P_HANGUP_RESP   0x8908          // 挂断呼叫-response

/*会议模式-呼叫控制*/
#define CTRL_CTRLTYPE_MET_ASK           0x0909          // 发起呼叫-会议模式
#define CTRL_CTRLTYPE_MET_ASK_RESP      0x8909          // 发起呼叫-response
#define CTRL_CTRLTYPE_MET_INVITE        0x090A          // 控制类型-邀请呼叫
#define CTRL_CTRLTYPE_MET_INVITE_RESP   0x890A          // 邀请呼叫-response
#define CTRL_CTRLTYPE_MET_ANSWER        0x090B          // 应答呼叫-会议模式
#define CTRL_CTRLTYPE_MET_ANSWER_RESP   0x890B          // 应答呼叫-response
#define CTRL_CTRLTYPE_MET_HANGUP        0x090C          // 挂断呼叫-会议模式
#define CTRL_CTRLTYPE_MET_HANGUP_RESP   0x890C          // 挂断呼叫-response

/*没有用到*/
#define CTRL_CTRLTYPE_ASK               0x0203          // 控制类型-发起呼叫
#define CTRL_CTRLTYPE_ASK_RESP          0x8203          // 发起呼叫-response
#define CTRL_CTRLTYPE_PUSHCALL          0x0204          // 控制类型-推送呼叫
#define CTRL_CTRLTYPE_PUSHCALL_RESP     0x8204          // 推送呼叫-response
#define CTRL_CTRLTYPE_HANGUP            0x0205          // 控制类型-挂断呼叫
#define CTRL_CTRLTYPE_HANGUP_RESP       0x8205          // 挂断呼叫-response
#define CTRL_CTRLTYPE_ANSWER            0x0207          // 控制类型-应答呼叫
#define CTRL_CTRLTYPE_ANSWER_RESP       0x8207          // 应答呼叫-response

#define CTRL_CTRLTYPE_INVITE            0x0911          //呼叫邀请
#define CTRL_CTRLTYPE_INVITE_RESP       0x8911          //呼叫邀请-response
#define CTRL_CTRLTYPE_NOTIDEST          0X090e          //通知对方注册聊天室
#define CTRL_CTRLTYPE_NOTIDEST_RESP     0X890e          //通知对方注册聊天室-response

#define CTRL_CALLTYPE_TEXTMSG           0               // 呼叫类型-文字聊天
#define CTRL_CALLTYPE_AUDIO             1               // 呼叫类型-语音聊天
#define CTRL_CALLTYPE_VIDEO             2               // 呼叫类型-视频通话
#define CTRL_CALLTYPE_CONFERENCE_AUDIO  11              // 呼叫类型-语音聊天 会议
#define CTRL_CALLTYPE_CONFERENCE_VIDEO  12              // 呼叫类型-视频聊天 会议

#define CTRL_CALLTYPE_STATUS_REJECT     0               // 呼叫状态-拒绝
#define CTRL_CALLTYPE_STATUS_ACCEPT     1               // 呼叫状态-接受

// 呼叫控制相关
#define SOMEONE_ASK_VIDEO       1
#define SOMEONE_CANCEL_VIDEO    0

#define OPEN_VIDEO      1
#define CLOSE_VIDEO     0

#define ACTIVE_CALL     1
#define PASSIVE_CALL    2

#define CHATROOM_CSC    1
#define CHATROOM_P2P    2
#define CHATROOM_MET    3

//////////////////////////////////////////////////////////////////////////
//视频参数
#define UNS_FRAME_WIDTH     192
#define UNS_FRAME_HEIGHT    144
#define UNS_REMOTE_WIDTH    320
#define UNS_REMOTE_HEIGHT   240
#define FRAME_SIZE          (UNS_FRAME_WIDTH * UNS_FRAME_HEIGHT)
#define REMOTE_FRAME_SIZE   (UNS_REMOTE_WIDTH * UNS_REMOTE_HEIGHT)
//////////////////////////////////////////////////////////////////////////

#define RESPONSE_STATUS_SUCCESS         0               // response状态-成功
#define RESPONSE_STATUS_FAIL            (-1)

#define RESPONSE_CHECKCODE_FAIL         0               // 失败的checkcode

// P2P协议命令字
#define P2P_TESTNATTYPE_TOSVR_REQ       0x0204              // 向P2P服务器或P2P辅助服务器发送NAT类型测试请求
#define P2P_TESTNATTYPE_FROMSVR_REQ     0x0203              // P2P服务器或P2P辅助服务器向客户端发送NAT类型测试请求
#define P2P_UDPHOLE_REQ                 0x0F01              // 客户端端与客户端之间发送打洞消息
#define P2P_UDPHOLE_RESP                0x8F01              // 收到打洞消息后回复
#define P2P_UDPHOLENOTIFY_REQ           0x090D              // 通知服务器已向对方发打洞消息
#define P2P_UDPHOLENOTIFY_RESP          0x890D              // 服务器收到向对方打洞通知消息回复
#define P2P_UDPHOLESUCCNOTITY_REQ       0x090E              // 通知对方打洞成功，或以开始通信
#define P2P_UDPHOLESUCCNOTIFY_RESQ      0x890E              // 收到打洞成功通知后回复

#define P2P_WAN 0       //外网p2p
#define P2P_LAN 1       //内网p2p

// 呼叫控制类型
#define CALLTYPE_CSC    1
#define CALLTYPE_P2P    2
#define CALLTYPE_MET    3

#define INFINITE        0xffffffff

#define REGISTER_RETURN_SUCCESS 0
#define REGISTER_RETURN_IP_FALSE 1
#define REGISTER_RETURN_USERNAME_FALSE 2
#define REGISTER_RETURN_PASSWORD_FALSE 3
#define REGISTER_RETURN_PHONE_NUMBER_FALSE 4
#define REGISTER_RETURN_PHONENUM_WRONG 5
#define REGISTER_RETURN_UNKOWN_FALSE 7
#define REGISTER_RETURN_NOT_INTEGER 8
#define REGISTER_RETURN_NOT_SEND 9

// P2P类型
#define P2P_TYPE_FULLCONE               0
#define P2P_TYPE_SYMMETRIC              1
#define P2P_TYPE_RESTRICT_IP            2
#define P2P_TYPE_RESTRICT_PORT          3

//用户视频开关状态
#define VIDEO_STATUS_OPEN   1
#define VIDEO_STATUS_CLOSE  0
#define AUDIO_STATUS_RECEIVE    2
#define AUDIO_STATUS_NOTRECE    3

//音频录制方
#define LOCAL_RECORD_SIDE_ME    0
#define LOCAL_RECORD_SIDE_OTHER 1


//////////////////////////服务器返回错误码/////////////////////////////
//控制服务器错误码
#define CTRL_ERROR_LOGIN_FAILED         0x80050001	// 登录失败：用户名或密码错误
#define CTRL_ERROR_LOGIN_NOT_REGISTERED	0x80050002	// 登录失败：用户未注册
#define CTRL_ERROR_HOST_NOT_FOUND_USER  0x80050003	// 本地没有用户缓存数据，转发
#define CTRL_ERROR_CALL_USER_NOT_LOGIN  0x80050004	// 用户没有登录
#define CTRL_ERROR_CALL_USER_NOT_ONLINE 0x80050005	// 用户不在线
#define CTRL_ERROR_USER_NAME_WARN       0x80050006	// 用户名错误
#define CTRL_ERROR_CALL_USER_WARN       0x80050007	// 呼叫方错误
#define CTRL_ERROR_CALL_USER_OUT		0x80050008 	// 呼叫不再服务区
#define CTRL_ERROR_CTRL_INFO_ERROR      0x80050010	// 控制信息错误

//用户管理服务器错误码
#define ERR_NETSTATUS_PARAM_ERROR		0x80010001	//链接状态：链接参数不正确
#define ERR_NETSTATUS_SERVER_BUSY		0x80010002	//链接状态：服务器忙
#define ERR_LOGIN_FAILED				0x80010003	//登录失败：用户名密码错误
#define ERR_LOGIN_NOT_REGISTERED		0x80010004	//登录失败：用户未注册
#define ERR_REGISTER_USER_EXIST			0x80010005	//注册失败：用户已存在
#define ERR_MODIFY_USER_NOT_EXISTS		0x80010006	//修改用户不存在
#define ERR_MODIFY_PWD_FAILD			0x80010007	//原密码不对
#define ERR_DOWNLOAD_USER_NOT_EXISTS	0x80010008	//下载的用户不存在
#define ERR_ADD_FRIEND_NOT_EXISTS		0x80010009	//添加好友用户不存在
#define ERR_ADD_FRIEND_EXISTED			0x8001000A  //重复添加好友
#define ERR_DELETE_FRIEND_NO_EXISTS		0x8001000B	//删除好友不存在
#define ERR_MODIFY_FRIEND_NO_EXISTS		0x8001000C	//修改好友不存在


//////////////////////////群相关/////////////////////////////(不写RESP的都不是回包)
#define TEAM_MEMBERCHANGE                    0x0712          // 群成员变更消息
#define TEAM_SYSTEMNOTIFY                    0x0713          // 群操作消息

#endif

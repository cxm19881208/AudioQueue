//
//  ViewController.m
//  RealTimeTransport
//
//  Created by 常 贤明 on 4/16/13.
//  Copyright (c) 2013 常 贤明. All rights reserved.
//

#import "ViewController.h"
#import "NetDispatcher.h"
#import "AVManager.h"
#import "AudioRecorder.h"

DWORD checkCode=0;
DWORD loginUserID = 1209;
DWORD g_PeerUserID=0;

Call_Status call_status=Call_None;

typedef struct TestData{
    unsigned char* pBuff;
    unsigned int size;
}TestData;


struct Test2
{
    char c;
    long long i64;
}Test2;
struct Test3
{
    long long c;
    long long i64;
}Test3;

@interface ViewController ()<AudioSinkDelegate>
{
    TestData*   tData;
}
@end

@implementation ViewController


- (void)dealloc
{
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    m_netDispatcher = [[NetDispatcher alloc] init];
    m_netDispatcher.viewController=self;
    // 配置服务器地址，端口。和服务器端监听保持一致
    [[m_netDispatcher getCtrlSvrSocket] ConnectToServer:@"192.168.9.100"  svrPort:5000];
    sleep(2.);
    [m_netDispatcher.m_avManager audioRecorder]->setDelegate(self);
    // 开始录音
    [m_netDispatcher.m_avManager audioRecorder]->startRecord();
    
    int a = 10;
    float b = 20;
    double c=30;
    void *pBuf;
    
    NSLog(@"%lu--%lu--%lu--%lu--%lu--%lu--%lu",sizeof(a),sizeof(b),sizeof(c),sizeof(CGPoint),sizeof(pBuf),sizeof(Test2),sizeof(Test3));
    
    int xx=0;
    while (true) {
        xx++;
        if (xx==10) {
            return;
        }
        NSLog(@"xx:%d",xx);
    }
    
//    tData = new TestData();
//    [self initTeData];
//    for (int i =0 ; i < 100; i ++) {
//        sleep(1);
//        NSString* str = [NSString stringWithUTF8String:(const char*)tData->pBuff];
//        NSLog(@"str:%@",str);
//    }
    
}

- (void)initTeData{
    NSString* str = @"good morning";
    NSData* pData = [str dataUsingEncoding:NSUTF8StringEncoding];
    BYTE* data=new BYTE[256];
    unsigned char buf[256];
    memcpy(data, [pData bytes], [pData length]);
    tData->pBuff=(unsigned char* )data;
    tData->size=[pData length];
    NSString* tStr = [NSString stringWithUTF8String:(const char*)tData->pBuff];
    NSLog(@"str:%@",tStr);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (BOOL) didReceiveLogoutResp:(NSNumber *)wStatus
{
    if ([wStatus unsignedIntValue]==1)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登出" message:@"登出成功!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登出" message:@"登出失败!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
    return TRUE;
}


- (BOOL) didReceiveTextMsgResp:(int)wStatus withFailedReason:(NSString *)strFailedReason
{
    if (wStatus != 1)
    {
        NSLog(@"status: %d, %@", wStatus, strFailedReason);
    }
    else
    {
        NSLog(@"消息发送成功");
    }
    return TRUE;
}

- (BOOL) didReceiveAudioResp:(int)wStatus withFailedReason:(NSString *)strFailedReason
{
    if (wStatus != 1)
    {
        NSLog(@"status: %d, %@", wStatus, strFailedReason);
    }
    else
    {
        NSLog(@"音频成功发送到服务器");
    }
    return TRUE;

}

- (BOOL) didStartAudioOrVideoCalling:(BYTE)wCtrlType
{
    if (wCtrlType == 1)
        NSLog(@"开始语音通话");
    else
        NSLog(@"开始视频通话");
    
    return TRUE;
}

- (BOOL) didReceiveRejectAudioCallReq
{
    NSLog(@"对方拒绝语音通话");
    return TRUE;
}

- (void)sendAudioDataWithBytes:(char*)bytes length:(int)len
{
    [[m_netDispatcher getCtrlSvrSocket] SendData:CHAT_AUDIO_REQ sequenceID:0 srcUserID:loginUserID desUserID:g_PeerUserID sendData:(unsigned char *)bytes dataSize:len];
}

@end

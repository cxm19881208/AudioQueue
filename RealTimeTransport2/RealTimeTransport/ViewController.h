//
//  ViewController.h
//  RealTimeTransport
//
//  Created by 常 贤明 on 4/16/13.
//  Copyright (c) 2013 常 贤明. All rights reserved.
//

@class NetDispatcher;

#import <UIKit/UIKit.h>
#import "Globaldef_i.h"

@interface ViewController : UIViewController<UITextFieldDelegate>
{
    NetDispatcher* m_netDispatcher;
}


- (BOOL) didReceiveLogoutResp:(NSNumber *) wStatus;
- (BOOL) didReceiveREPHangUpReq: (DWORD) wSourceId;
- (BOOL) didReceiveCtrlResp: (int) wStatus withFailedReason:(NSString*) strFailedReason;
- (BOOL) didReceiveTextMsgResp: (int) wStatus withFailedReason: (NSString*) strFailedReason;
- (BOOL) didReceiveAudioResp: (int) wStatus withFailedReason: (NSString*) strFailedReason;
- (BOOL) didStartAudioOrVideoCalling: (BYTE) wCtrlType;
- (BOOL) didReceiveRejectAudioCallReq;
@end

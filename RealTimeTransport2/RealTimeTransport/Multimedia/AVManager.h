//
//  AVManager.h
//  RealTimeTransport
//
//  Created by 王 家振 on 13-4-16.
//  Copyright (c) 2013年 常 贤明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SinkProtocol.h"
#import "Globaldef_i.h"
#import "AudioPlayers.h"
#import "AudioRecorder.h"

@interface AVManager : NSObject
{
    //AudioPlayer         *audioPlayer;
    AudioPlayers         *audioPlayer;
    AudioRecorder       *audioRecorder;
    AudioCache*     audioCache;
}

@property (readonly) AudioPlayers         *audioPlayer;
@property (readonly) AudioRecorder       *audioRecorder;

- (void) OnReceiveAudoData:(void *)pAudioBuffer withLength: (WORD)len;
- (void) initAudioService:(id<IClientSocket>)sock;

void interruptionListener(void *inClientData,UInt32	inInterruptionState);
void propListener(void *inClientData,AudioSessionPropertyID	inID,UInt32 inDataSize,const void *inData);
@end

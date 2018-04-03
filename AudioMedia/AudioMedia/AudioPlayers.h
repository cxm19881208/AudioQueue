//
//  AudioPlayers.h
//  RealTimeTransport
//
//  Created by Hero on 17/1/13.
//  Copyright © 2017年 常 贤明. All rights reserved.
//

#ifndef AudioPlayers_h
#define AudioPlayers_h

#include <AudioToolbox/AudioToolbox.h>

#include "CAStreamBasicDescription.h"
#include "CAXException.h"
#include <pthread.h>
#import "Globaldef_i.h"
#include "AudioCache.hpp"

class AudioPlayers {
public:
    AudioPlayers();
    ~AudioPlayers();
    
public:
    OSStatus                    StartQueue();
    OSStatus                    StopQueue();
    OSStatus                    PauseQueue();
    void                        DisposeQueue();
    
private:
    AudioQueueRef               mQueue;
    AudioQueueBufferRef         mBuffers[kNumBuffers];
    CAStreamBasicDescription    mDataFormat;
    
private:

    AudioState                  audioState;
    
private:
    bool                        mIsInit;
    
public:
    //缓存类
    void SetAudioCacheHandle(AudioCache* cache);
    //重置播放器
    void resetAudioQueue(CAStreamBasicDescription *format);
    void SetNewQueue();
    //播放回调
    static void AudioBufferCallback2(void *					inUserData,
                                    AudioQueueRef           inAQ,
                                    AudioQueueBufferRef		inCompleteAQBuffer);
    void readAudioBufferIntoQueueRef(void *					inUserData,
                                    AudioQueueRef             inAQ,
                                    AudioQueueBufferRef		inCompleteAQBuffer);
};



#endif /* AudioPlayers_h */

//
//  AudioRecorder.h
//  RealTimeTransport
//
//  Created by 常 贤明 on 13-4-16.
//  Copyright (c) 2013年 常 贤明. All rights reserved.
//

#ifndef __RealTimeTransport__AudioRecorder__
#define __RealTimeTransport__AudioRecorder__


#include <AudioToolbox/AudioToolbox.h>
#include <Foundation/Foundation.h>
#include <CoreAudio/CoreAudioTypes.h>
#import "Globaldef_i.h"


#define kNumberRecordBuffers	  3
#define kBufferDurationSeconds    .05
#define kFreeBufferSize           1000

// 上行音频数据协议
@protocol AudioSinkDelegate <NSObject>
// 发送音频数据
- (void)sendAudioDataWithBytes:(char*)bytes length:(int)len;

@end

typedef enum
{
    RecordStatus_None,
    RecordStatus_Record,
    RecordStatus_Pause,
    RecordStatus_Stop
}RecordStatus;

class AudioRecorder
{
    
public:
    AudioQueueRef				   audioQueue;
    AudioQueueBufferRef			   audioBuffers[kNumberRecordBuffers];
    AudioStreamBasicDescription	   audioRecordFormat;
    RecordStatus			       recordStatus;
    NSMutableArray                 *dataArray;
    NSMutableArray                 *freeArray;
    NSLock                         *dataLock;
    NSThread                       *recordThread;
    NSThread                       *sendThread;
    id<AudioSinkDelegate>                             delegate;
    
public:
    AudioRecorder();
    AudioRecorder(AudioStreamBasicDescription *format);
    ~AudioRecorder();
    
    AudioStreamBasicDescription	recordFormat(){return audioRecordFormat;};
    
    void setDelegate(id del){delegate=del;}
    void setAudioRecordFormat(AudioStreamBasicDescription *format){audioRecordFormat=*format;}
    void setupAudioFormat(UInt32 inFormatID);
    int computeRecordBufferSize(const AudioStreamBasicDescription *format, float seconds);
    Boolean startRecord();
    Boolean pauseRecord();
    Boolean resumeRecord();
    Boolean stopRecord();
    
    Boolean adjustRecordWithFormat(AudioStreamBasicDescription *format);
    RecordStatus audioRecordStatus()  { return recordStatus; }
    
    
    
    
};


#endif 

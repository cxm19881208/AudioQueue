//
//  AudioPlayerss.m
//  RealTimeTransport
//
//  Created by Hero on 17/1/13.
//  Copyright © 2017年 常 贤明. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "AudioPlayers.h"

AudioCache* IAudioCache;

void AudioPlayers::AudioBufferCallback2(void *					inUserData,
                                      AudioQueueRef             inAQ,
                                      AudioQueueBufferRef		inCompleteAQBuffer)
{
    AudioPlayers *THIS=(AudioPlayers *)inUserData;
    THIS->readAudioBufferIntoQueueRef(inUserData, inAQ, inCompleteAQBuffer);
    
}

// 往缓冲添加数据
void AudioPlayers::readAudioBufferIntoQueueRef(void *					inUserData,
                                               AudioQueueRef             inAQ,
                                               AudioQueueBufferRef		inCompleteAQBuffer) {
    @synchronized (inUserData) {
        BYTE buf[audio_size];
        unsigned int dataSize=0;
        IAudioCache->GetAudioData(buf, dataSize);
        //NSLog(@"play size:%u",dataSize);
        
        AudioQueueBufferRef fillBuf = inCompleteAQBuffer;
        unsigned char *pDestData=(unsigned char *)fillBuf->mAudioData;
        if (dataSize>0) {
            unsigned char *pData = (unsigned char *)buf;
            // enqueue buffer
            UInt32 nTotalSize=0;
            UInt32 numPacket=0;
            SInt32 sOffset=0;
            UInt32 allDataSize=0;   // 纯数据长度
            
            for (int i = 0; i < dataSize && nTotalSize < dataSize; i++)
            {
                // 音频数据长度
                unsigned short pSize=0;
                memcpy(&pSize, pData, 2);
                pData+=2;
                nTotalSize+=2;
                // 音频数据
                memcpy(pDestData, pData, pSize);
                pData+=pSize;
                pDestData+=pSize;
                
                fillBuf->mPacketDescriptions[i].mStartOffset=sOffset;
                fillBuf->mPacketDescriptions[i].mDataByteSize=pSize;
                fillBuf->mPacketDescriptions[i].mVariableFramesInPacket=0;
                
                nTotalSize+=pSize;
                sOffset+=pSize;
                allDataSize+=pSize;
                
                numPacket++;
            }
            
            fillBuf->mAudioDataByteSize=allDataSize;
            fillBuf->mPacketDescriptionCount=numPacket;
            OSStatus err = AudioQueueEnqueueBuffer(mQueue, fillBuf, 0, NULL);
            if (err)
            {
                NSLog(@"填充失败");
            }
        }
        else
        {
            NSLog(@"填充假数据,packetNum:%d--dataSize:%d",fillBuf->mPacketDescriptionCount,fillBuf->mAudioDataByteSize);
            /*
             // 直接填充旧数据
            OSStatus err = AudioQueueEnqueueBuffer(mQueue, fillBuf, 0, NULL);
            if (err)
            {
                NSLog(@"没有数据了，填充旧数据，填充失败");
            }
            */
            
            // 填空数据
            UInt32 allDataSize=fillBuf->mAudioDataByteSize;
            BYTE buf[512];
            memset(buf, 0, 512);
            if (pDestData!=NULL) {
                memcpy(pDestData, buf, allDataSize);
                OSStatus err = AudioQueueEnqueueBuffer(mQueue, fillBuf, 0, NULL);
                if (err)
                {
                    NSLog(@"没有数据了，填充空数据，填充失败");
                }
            }
        }
        
    }
    
}

//缓存类
void AudioPlayers:: SetAudioCacheHandle(AudioCache* cache)
{
    IAudioCache = cache;
}

void AudioPlayers::resetAudioQueue(CAStreamBasicDescription *format)
{
    if (mQueue)
    {
        return;
    }
    NSLog(@"mQueue=NULL");
    if (format)
    {
        mDataFormat = *format;
    }
    else
    {
        mDataFormat.mFormatID=kAudioFormatMPEG4AAC_LD;
        mDataFormat.mSampleRate=16000;
        mDataFormat.mChannelsPerFrame=1;
        mDataFormat.mFramesPerPacket=512;
    }
    
    SetNewQueue();
}

void AudioPlayers::SetNewQueue()
{
    OSStatus status=AudioQueueNewOutput(&mDataFormat, AudioPlayers::AudioBufferCallback2, this,
                                        CFRunLoopGetCurrent(), kCFRunLoopCommonModes, 0, &mQueue);
    if(status)
    {
        printf("AudioQueueNew failed");
        return;
    }
    
    for (int i = 0; i < kNumBuffers; i++)
    {
        XThrowIfError(AudioQueueAllocateBufferWithPacketDescriptions(mQueue, 2048, 1, &mBuffers[i]), "AudioQueueAllocateBuffer failed");
        
    }
    
    // set the volume of the queue
    XThrowIfError (AudioQueueSetParameter(mQueue, kAudioQueueParam_Volume, 1.0), "set queue volume");
    NSLog(@"播放器初始化成功");
    mIsInit = YES;
}

OSStatus AudioPlayers:: StartQueue()
{
    for (int i=0; i < kNumBuffers; i ++) {
        AudioBufferCallback2(this, mQueue, mBuffers[i]);
    }
    OSStatus status = AudioQueueStart(mQueue, NULL);
    if (!status)
    {
        audioState=AU_PLAYING;
        printf("启动播放器成功\n");
    }
    else
    {
        printf("启动播放器失败\n");
    }

    return status;
}

OSStatus  AudioPlayers:: StopQueue()
{
    OSStatus status = AudioQueueStop(mQueue, false);
    if (!status)
    {
        audioState=AU_STOP;
    }
    return status;
}

OSStatus  AudioPlayers:: PauseQueue()
{
    OSStatus status = AudioQueuePause(mQueue);
    if (!status)
    {
        audioState=AU_PAUSE;
    }
    return status;
}

void  AudioPlayers:: DisposeQueue()
{
    if (mQueue)
    {
        for (int i = 0; i < kNumBuffers; i++)
        {
            if(mBuffers[i]!=NULL)
            {
                AudioQueueFreeBuffer(mQueue,mBuffers[i]);
                mBuffers[i]=NULL;
            }
        }
        AudioQueueDispose(mQueue, true);
        mQueue = NULL;
    }
}

AudioPlayers::AudioPlayers()
{
    DisposeQueue();
    audioState = AU_STOP;
    
}

AudioPlayers::~AudioPlayers()
{
    DisposeQueue();

}

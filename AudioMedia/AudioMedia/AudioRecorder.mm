//
//  AudioRecorder.cpp
//  RealTimeTransport
//
//  Created by 常 贤明 on 13-4-16.
//  Copyright (c) 2013年 常 贤明. All rights reserved.
//

#include "AudioRecorder.h"

static FILE *outputFile;

#define DEFAULT_FORMAT_ID                       kAudioFormatMPEG4AAC_LD

#define CheckIfError(error, message)			\
do {											\
BOOL __err = error;							    \
if (__err) {									\
fprintf(stdout,message);						\
}												\
} while (0)


AudioRecorder::AudioRecorder()
{
    memset(&audioRecordFormat, 0, sizeof(audioRecordFormat));
    audioQueue=NULL;
    recordStatus=RecordStatus_None;
    //    this->createBuffers();    
}

AudioRecorder::AudioRecorder(AudioStreamBasicDescription *format)
{
    audioRecordFormat=*format;
    memset(&audioRecordFormat, 0, sizeof(audioRecordFormat));
    audioQueue=NULL;
    recordStatus=RecordStatus_None;
    //    this->createBuffers();
}

static int StreamFormatIsEmpty(AudioStreamBasicDescription *format)
{
    return  format->mSampleRate ==0. && format->mFormatID == 0 && format->mBytesPerPacket == 0 && format->mFramesPerPacket == 0 && format->mBytesPerFrame == 0 && format->mChannelsPerFrame == 0 && format->mBitsPerChannel == 0 && format->mFormatFlags == 0;
}

void AudioRecorder::setupAudioFormat(UInt32 inFormatID)
{
	memset(&audioRecordFormat, 0, sizeof(audioRecordFormat));
    
	UInt32 size = sizeof(audioRecordFormat.mSampleRate);
    CheckIfError(AudioSessionSetProperty(kAudioSessionProperty_PreferredHardwareSampleRate,size,&audioRecordFormat.mSampleRate), "couldn't set hardware sample rate\n");
    
    
	if (inFormatID == kAudioFormatLinearPCM)
	{
		// if we want pcm, default to signed 16-bit little-endian
		audioRecordFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
		audioRecordFormat.mBitsPerChannel = 16;
		audioRecordFormat.mBytesPerPacket = audioRecordFormat.mBytesPerFrame = (audioRecordFormat.mBitsPerChannel / 8) * audioRecordFormat.mChannelsPerFrame;
		audioRecordFormat.mFramesPerPacket = 1;
	}
    else if(inFormatID==kAudioFormatMPEG4AAC_LD)
    {
        audioRecordFormat.mSampleRate=16000;
        audioRecordFormat.mChannelsPerFrame=1;
        audioRecordFormat.mFramesPerPacket=512;
    }
    audioRecordFormat.mFormatID = inFormatID;
}

int AudioRecorder::computeRecordBufferSize(const AudioStreamBasicDescription *format, float seconds)
{
	int packets, frames, bytes = 0;
    
    frames = (int)ceil(seconds * format->mSampleRate);
    
    if (format->mBytesPerFrame > 0)
        bytes = frames * format->mBytesPerFrame;
    else {
        UInt32 maxPacketSize;
        if (format->mBytesPerPacket > 0)
            maxPacketSize = format->mBytesPerPacket;	// constant packet size
        else {
            UInt32 propertySize = sizeof(maxPacketSize);
            CheckIfError(AudioQueueGetProperty(audioQueue, kAudioQueueProperty_MaximumOutputPacketSize, &maxPacketSize,
                                               &propertySize), "couldn't get queue's maximum output packet size\n");
        }
        if (format->mFramesPerPacket > 0)
            packets = frames / format->mFramesPerPacket;
        else
            packets = frames;	// worst-case scenario: 1 frame in a packet
        if (packets == 0)		// sanity check
            packets = 1;
        bytes = packets * maxPacketSize;
    }
    
	return bytes;
}

BYTE g_cbAacAudioBuffer[1024*3];

static void OutputBufferHandler( void *	                            inUserData,
                                AudioQueueRef						inAQ,
                                AudioQueueBufferRef					inBuffer,
                                const AudioTimeStamp *				inStartTime,
                                UInt32								inNumPackets,
                                const AudioStreamPacketDescription*	inPacketDesc)
{
    AudioRecorder *audioRecorder = (AudioRecorder *)inUserData;
    
    //NSLog(@"OutputBufferHandler %lu",inNumPackets);
    //    unsigned short temp;
    //    for (int i=0; i<inNumPackets; i++) {
    //        temp=(unsigned short)inPacketDesc[i].mDataByteSize;
    //        fwrite(&temp, 2, 1, outputFile);
    //
    //        fwrite((char *)inBuffer->mAudioData+inPacketDesc[i].mStartOffset, inPacketDesc[i].mDataByteSize, 1, outputFile);
    //    }
    
    //    if (inNumPackets<=0) {
    //        return;
    //    }
    
    // 
    UInt16 nDataSize=0;
    BYTE *pDestData=g_cbAacAudioBuffer;
    for(UInt32 i=0;i<inNumPackets;i++)
    {
        if((sizeof(g_cbAacAudioBuffer)-nDataSize)<(inPacketDesc[i].mDataByteSize+2))
            break;
        BYTE *pAudioData=(BYTE *)inBuffer->mAudioData;
        pAudioData+=inPacketDesc[i].mStartOffset;
        UInt16 nAacSize=(UInt16)inPacketDesc[i].mDataByteSize;
        memcpy(pDestData,&nAacSize,2);
        pDestData+=2;
        nDataSize+=2;
        memcpy(pDestData,pAudioData,nAacSize);
        pDestData+=nAacSize;
        nDataSize+=nAacSize;
    }
    
//    BOOL ret=[audioRecorder->delegate SendData:0x000A sequenceID:0 sendData:g_cbAacAudioBuffer dataSize:nDataSize];
//    NSLog(@"ret:%d datasize:%d",ret,nDataSize);
[audioRecorder->delegate sendAudioDataWithBytes:(char*)g_cbAacAudioBuffer length:nDataSize];
    //int ret=(int)[audioRecorder->delegate sendAudioDataWithBytes:g_cbAacAudioBuffer length:nDataSize];
    //NSLog(@"ret:%d datasize:%d",ret,nDataSize);
    
    if (audioRecorder->audioRecordStatus()==RecordStatus_Record)
        CheckIfError(AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL), "AudioQueueEnqueueBuffer failed\n");
}


static CFRunLoopRef recordRunLoop=NULL;

Boolean AudioRecorder::startRecord()
{
    int i, bufferSize;
    
    outputFile = fopen("/tmp/outputFile.caf", "wb");
    
    recordStatus=RecordStatus_None;
    recordRunLoop=NULL;
    
    // specify the recording format
    if (StreamFormatIsEmpty(&audioRecordFormat))
        this->setupAudioFormat(DEFAULT_FORMAT_ID);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^()
                   {
                       while (recordStatus!=RecordStatus_Stop) {
                           CFRunLoopRun();
                           recordRunLoop=CFRunLoopGetCurrent();
                       }
                   });
    
    while (recordRunLoop==NULL) ;
    
    // create the queue
    CheckIfError(AudioQueueNewInput( &audioRecordFormat,
                                    OutputBufferHandler,
                                    this /* userData */,
                                    recordRunLoop /* run loop */, NULL /* run loop mode */,
                                    0 /* flags */, &audioQueue), "AudioQueueNewInput failed\n");
    
    // allocate and enqueue buffers
    bufferSize = this->computeRecordBufferSize(&audioRecordFormat, kBufferDurationSeconds);
    
    
    for (i = 0; i < kNumberRecordBuffers; ++i) {
        CheckIfError(AudioQueueAllocateBuffer(audioQueue, bufferSize, &audioBuffers[i]),
                     "AudioQueueAllocateBuffer failed\n");
        CheckIfError(AudioQueueEnqueueBuffer(audioQueue, audioBuffers[i], 0, NULL),
                     "AudioQueueEnqueueBuffer failed\n");
    }
    
    // start the queue
    //    lastBeginTime=time(NULL);
    recordStatus=RecordStatus_Record;
    CheckIfError(AudioQueueStart(audioQueue, NULL), "AudioQueueStart failed\n");
    
    return YES;
}

Boolean AudioRecorder::pauseRecord()
{
    recordStatus=RecordStatus_Pause;
    return AudioQueuePause(audioQueue);
}

Boolean AudioRecorder::resumeRecord()
{
    recordStatus=RecordStatus_Record;
    if (audioQueue) {
        return AudioQueueStart(audioQueue,NULL);
    }
    else
    {
        return this->startRecord();
    }
}

Boolean AudioRecorder::stopRecord()
{
    recordStatus=RecordStatus_Stop;
    
    CheckIfError(AudioQueueStop(audioQueue, YES), "AudioQueueStop failed\n");
    AudioQueueDispose(audioQueue, YES);
    audioQueue=NULL;
    
    if (recordRunLoop)
        CFRunLoopStop(recordRunLoop);
    recordRunLoop=NULL;
    
    fflush(outputFile);
    fclose(outputFile);
    
    return YES;
}

Boolean AudioRecorder::adjustRecordWithFormat(AudioStreamBasicDescription *format)
{
    if (recordStatus!=RecordStatus_Record) {
        audioRecordFormat=*format;
    }
    else
    {
        this->stopRecord();
        audioRecordFormat=*format;
        this->startRecord();
    }
    return YES;
}


AudioRecorder::~AudioRecorder()
{
    //    [dataArray release];
    //    [freeArray release];
    //    [dataLock release];
    //    [super dealloc];
}

//void AudioRecorder::createBuffers()
//{
//    dataLock = [[NSLock alloc] init];
//    dataArray = [[NSMutableArray alloc] init];
//    freeArray = [[NSMutableArray alloc] init];
//    for (int i = 0; i < kFreeBufferSize; i ++)
//    {
////        VoiceData *voiceData=[[VoiceData alloc] init];
////        [freeArray addObject:voiceData];
////        [voiceData release];
//    }
//}




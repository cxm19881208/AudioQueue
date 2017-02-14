//
//  AVManager.m
//  RealTimeTransport
//
//  Created by 王 家振 on 13-4-16.
//  Copyright (c) 2013年 常 贤明. All rights reserved.
//

#import "AVManager.h"

@implementation AVManager

@synthesize audioPlayer;
@synthesize audioRecorder;

- (id)init
{
    if (self = [super init])
    {
        
    }
    
    return self;
}

int recNum=0;
BOOL haveStart=NO;
//接收音频数据
- (void) OnReceiveAudoData:(void *)pAudioBuffer withLength:(WORD)len
{
    /*cxm 接收到大于6条数据，启动播放器*/
    //audioPlayer->addVoiceData(pAudioBuffer, len);
    audioCache->ReceiveAudioData(pAudioBuffer, len);
    recNum ++;
    if (recNum>6 && !haveStart) {
        haveStart = YES;
        
        audioPlayer->StartQueue();
    }
}

//初始化
- (void) initAudioService:(id<IClientSocket>)sock
{
    audioCache = new AudioCache();
    audioPlayer = new AudioPlayers();
    audioPlayer->SetAudioCacheHandle(audioCache);
    audioRecorder = new AudioRecorder();
    audioPlayer->resetAudioQueue(NULL);
    //audioRecorder->delegate = sock;
    
    OSStatus error = AudioSessionInitialize(NULL, NULL, interruptionListener, self);
	if (error) printf("ERROR INITIALIZING AUDIO SESSION! %lu\n", error);
	else
	{
		UInt32 category = kAudioSessionCategory_PlayAndRecord;
		error = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
		if (error) printf("couldn't set audio category!");
        
        category=kAudioSessionOverrideAudioRoute_Speaker;
        error = AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(category), &category);
        
		error = AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, propListener, self);
		if (error) printf("ERROR ADDING AUDIO SESSION PROP LISTENER! %lu\n", error);
        
        UInt32 size=0;
		UInt32 inputAvailable = 0;
        size = sizeof(inputAvailable);
		
		// we do not want to allow recording if input is not available
		error = AudioSessionGetProperty(kAudioSessionProperty_AudioInputAvailable, &size, &inputAvailable);
		if (error) printf("ERROR GETTING INPUT AVAILABILITY! %lu\n", error);
		
		// we also need to listen to see if input availability changes
		error = AudioSessionAddPropertyListener(kAudioSessionProperty_AudioInputAvailable, propListener, self);
		if (error) printf("ERROR ADDING AUDIO SESSION PROP LISTENER! %lu\n", error);
        
		error = AudioSessionSetActive(true);
		if (error) printf("AudioSessionSetActive (true) failed");
	}
}

#pragma mark AudioSession listeners
void interruptionListener(	void *	inClientData,
                          UInt32	inInterruptionState)
{
	//AVManager *THIS = (AVManager*)inClientData;
	if (inInterruptionState == kAudioSessionBeginInterruption)
	{
		
	}
	else if (inInterruptionState == kAudioSessionEndInterruption)
	{
		
	}
}

void propListener(	void *                  inClientData,
                  AudioSessionPropertyID	inID,
                  UInt32                  inDataSize,
                  const void *            inData)
{
	AVManager *THIS = (AVManager*)inClientData;
	if (inID == kAudioSessionProperty_AudioRouteChange)
	{
		CFDictionaryRef routeDictionary = (CFDictionaryRef)inData;
		//CFShow(routeDictionary);
		CFNumberRef reason = (CFNumberRef)CFDictionaryGetValue(routeDictionary, CFSTR(kAudioSession_AudioRouteChangeKey_Reason));
		SInt32 reasonVal;
		CFNumberGetValue(reason, kCFNumberSInt32Type, &reasonVal);
		if (reasonVal != kAudioSessionRouteChangeReason_CategoryChange)
		{            
			if (reasonVal == kAudioSessionRouteChangeReason_OldDeviceUnavailable)
			{
				[THIS resetOutputTarget];
			}
		}
	}
	else if (inID == kAudioSessionProperty_AudioInputAvailable)
	{

	}
}

//耳机事件  声音复位
- (BOOL)hasHeadset
{
#if TARGET_IPHONE_SIMULATOR
    return NO;
#else
    CFStringRef route;
    UInt32 propertySize = sizeof(CFStringRef);
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &route);
    if((route == NULL) || (CFStringGetLength(route) == 0))
    {
        // Silent Mode
        //NSLog(@"AudioRoute: SILENT, do nothing!");
    }
    else
    {
        NSString* routeStr = (NSString*)route;
        
        NSRange headphoneRange = [routeStr rangeOfString : @"Headphone"];
        NSRange headsetRange = [routeStr rangeOfString : @"Headset"];
        if (headphoneRange.location != NSNotFound)
        {
            return YES;
        }
        else if(headsetRange.location != NSNotFound)
        {
            return YES;
        }
    }
    return NO;
#endif
}

- (void)resetOutputTarget
{
    BOOL hasHeadset = [self hasHeadset];
    NSLog (@"Will Set output target is_headset = %@ .", hasHeadset ? @"YES" : @"NO");
    UInt32 audioRouteOverride = hasHeadset ?
kAudioSessionOverrideAudioRoute_None:kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
}

- (void)dealloc
{
    delete audioRecorder;
    delete audioPlayer;
    [super dealloc];
}

@end

//
//  AudioCache.hpp
//  RealTimeTransport
//
//  Created by Hero on 17/1/12.
//  Copyright © 2017年 常 贤明. All rights reserved.
//

#ifndef AudioCache_hpp
#define AudioCache_hpp
#include <pthread.h>
#include <list>
#include <stdio.h>
#import "Globaldef_i.h"

typedef struct AudioData {
    unsigned int  size;
    BYTE *pBuf;
}AudioData;

using namespace std;
typedef list<AudioData*> AudioList;
typedef list<AudioData*>::iterator AudioListIt;

class AudioCache {
public:
    AudioCache();
    ~AudioCache();
private:
    AudioList*  mList;
    AudioList*  tmpList;
    pthread_mutex_t             bufferMutex;
    
public:
    void ReceiveAudioData(void*pVoiceData,unsigned int dataSize);
    void GetAudioData(void*pData,unsigned int &dataSize);
    unsigned int GetDataSize();
    
};


#endif /* AudioCache_hpp */

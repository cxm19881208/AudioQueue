//
//  AudioCache.cpp
//  RealTimeTransport
//
//  Created by Hero on 17/1/12.
//  Copyright © 2017年 常 贤明. All rights reserved.
//

#include "AudioCache.hpp"

#define max_size    16

// 测试用
int receiveCount = 0;

void AudioCache:: ReceiveAudioData(void*pVoiceData,unsigned int dataSize){
    
    /*
    receiveCount ++;
    if ((receiveCount > 500 && receiveCount < 700) || (receiveCount > 900 && receiveCount < 1000)) {
        //printf("return\n");
        return;
    }
    if (receiveCount>=1000) {
        receiveCount=0;
    }
     */
    pthread_mutex_lock(&bufferMutex);
    if (mList->size()>=max_size) {
        pthread_mutex_unlock(&bufferMutex);
        return;
    }
    
    if (dataSize-8>audio_size) {
        // 音频包过大
        printf("音频包过大：%d\n",dataSize-8);
        pthread_mutex_unlock(&bufferMutex);
        return;
    }
    //printf("接收到音频包：%d---count:%lu---tmpCount:%lu\n",dataSize-8,mList->size(),tmpList->size());
    if (tmpList->size()>0) {
        // 8字节头
        BYTE *pAllData = (BYTE *)pVoiceData;
        BYTE *pData=pAllData+8;
        DWORD size = dataSize-8;
        
        AudioData* data = (AudioData* )(tmpList->front());
        memcpy(data->pBuf, pData, size);
        data->size=size;
        tmpList->pop_front();
        mList->push_back(data);
    }
    
    pthread_mutex_unlock(&bufferMutex);
}

void AudioCache:: GetAudioData(void*pData,unsigned int &dataSize){
    pthread_mutex_lock(&bufferMutex);
    
    if (mList->size()>0) {
        AudioData*  data = mList->front();
        memcpy(pData, data->pBuf, data->size);
        dataSize=data->size;
        
        mList->pop_front();
        tmpList->push_back(data);
    }
    
    pthread_mutex_unlock(&bufferMutex);
    
}

unsigned int AudioCache:: GetDataSize()
{
    pthread_mutex_lock(&bufferMutex);
    DWORD size = (DWORD)mList->size();
    pthread_mutex_unlock(&bufferMutex);
    return size;
}

AudioCache::AudioCache() {
    // 初始化
    tmpList = new AudioList();
    mList = new AudioList();
    pthread_mutex_init(&bufferMutex, NULL);
    for (int i=0; i<max_size; i++) {
        AudioData* data = new AudioData();
        BYTE *buf = new BYTE[audio_size];
        data->pBuf=buf;
        tmpList->push_back(data);
    }
}


AudioCache::~AudioCache() {
    // 销毁
    pthread_mutex_lock(&bufferMutex);
    
    AudioListIt aIt;
    for (aIt=tmpList->begin(); aIt!=tmpList->end(); aIt++) {
        AudioData* data = *aIt;
        delete data->pBuf;
        delete data;
    }
    tmpList->clear();
    delete tmpList;tmpList = NULL;
    for (aIt=mList->begin(); aIt!=mList->end(); aIt++) {
        AudioData* data = *aIt;
        delete data->pBuf;
        delete data;
    }
    mList->clear();
    delete mList;mList=NULL;
    pthread_mutex_unlock(&bufferMutex);
    
    pthread_mutex_destroy(&bufferMutex);
    
}


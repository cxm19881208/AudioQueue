//
//  ThreadService.h
//  VideoMonitor
//
//  Created by hupo on 6/10/10.
//  Copyright 2010 deirlym. All rights reserved.
//

#import <Foundation/Foundation.h>

//////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////

@interface CThreadService : NSObject
{	
@private
	BOOL				bRuning;						//Thread State
	NSThread			*threadObj;						//Thread Object
	
@public
	NSString			*threadName;					//Thread Name;
}

@property (nonatomic, retain) NSThread * threadObj;
@property (nonatomic, retain) NSString * threadName;
@property (readonly) BOOL bRuning;

- (BOOL) StartThread;
- (BOOL) StopThread;

- (BOOL) OnThreadStartEvent;
- (BOOL) OnThreadStopEvent;
- (BOOL) RepetitionRun;

@end


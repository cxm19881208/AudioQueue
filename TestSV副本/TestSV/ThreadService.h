//
//  ThreadService.h
//  VideoMonitor
//
//  Created by changxm on 6/10/12.
//  Copyright 2012 changxm. All rights reserved.
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

- (BOOL) startThread;
- (BOOL) stopThread;

- (BOOL) onThreadStartEvent;
- (BOOL) onThreadStopEvent;
- (BOOL) repetitionRun;

@end


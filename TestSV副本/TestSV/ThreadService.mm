//
//  ThreadService.mm
//  VideoMonitor
//
//  Created by changxm on 6/10/12.
//  Copyright 2012 changxm. All rights reserved.
//

#import "ThreadService.h"

static int      g_nThreadCount=0;

@implementation CThreadService

@synthesize threadObj;
@synthesize threadName;
@synthesize bRuning;

- (id) init
{	
	self=[super init];
	return self;
}

- (BOOL) startThread
{
    if(threadObj!=NULL)
    {
        if(![threadObj isCancelled])
            [threadObj cancel];
        
        [threadObj release];
    }
    threadObj = [[NSThread alloc] initWithTarget: self selector:@selector(threadFunc) object:nil];
    g_nThreadCount++;
    threadName=[[NSString alloc] initWithFormat:@"Thread_%d",g_nThreadCount];
    
	bRuning = YES;
	[threadObj start];
	return YES;
}

- (BOOL) stopThread
{
    if(threadObj==NULL)
        return NO;
    
    if(![threadObj isCancelled])
    {
        [threadObj cancel];
    }
	bRuning = NO;
	return YES;
}

- (void) threadFunc
{
	NSAutoreleasePool *pool =[[NSAutoreleasePool alloc] init];
	
	BOOL bSuccess=[self onThreadStartEvent];
	if(bSuccess==NO)
	{
		[pool release];
		return;
	}
	
	while(bRuning==YES)
	{
		bRuning =[self repetitionRun];
	}
	
	[self onThreadStopEvent];
	[pool release];
}

- (BOOL) onThreadStartEvent
{
	return YES;
}

- (BOOL) onThreadStopEvent
{
	return YES;
}

- (BOOL) repetitionRun
{
	return NO;
}

- (void)dealloc
{
	[threadObj release];
	[threadName release];
    [super dealloc];
}

@end


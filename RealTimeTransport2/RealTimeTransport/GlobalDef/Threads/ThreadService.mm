//
//  ThreadService.mm
//  VideoMonitor
//
//  Created by hupo on 6/10/10.
//  Copyright 2010 deirlym. All rights reserved.
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

- (BOOL) StartThread
{
    if(threadObj!=NULL)
    {
        if(![threadObj isCancelled])
            [threadObj cancel];
        
        [threadObj release];
    }
    threadObj = [[NSThread alloc] initWithTarget: self selector:@selector(ThreadFunc) object:nil];
    g_nThreadCount++;
    threadName=[[NSString alloc] initWithFormat:@"Thread_%d",g_nThreadCount];
    
	bRuning = YES;
	[threadObj start];
	return YES;
}

- (BOOL) StopThread
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

- (void) ThreadFunc
{
	NSAutoreleasePool *pool =[[NSAutoreleasePool alloc] init];
	
	BOOL bSuccess=[self OnThreadStartEvent];
	if(bSuccess==NO)
	{
		[pool release];
		return;
	}
	
	while(bRuning==YES)
	{
		bRuning =[self RepetitionRun];		
	}
	
	[self OnThreadStopEvent];
	[pool release];
}

- (BOOL) OnThreadStartEvent
{
	return YES;
}

- (BOOL) OnThreadStopEvent
{
	return YES;
}

- (BOOL) RepetitionRun
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


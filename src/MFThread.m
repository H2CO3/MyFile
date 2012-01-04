//
// MFThread.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFThread.h"

@implementation MFThread

@synthesize delegate = delegate;
@synthesize cmd = cmd;
@synthesize exitCode = exitCode;

- (void) main {

	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        [delegate retain];
        exitCode = system ([self.cmd UTF8String]);
	[self.delegate threadEnded: self];
        [delegate release];
	[pool release];
	
}

@end


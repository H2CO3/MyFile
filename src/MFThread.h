//
// MFThread.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <stdlib.h>
#import <unistd.h>
#import <Foundation/Foundation.h>

@protocol MFThreadDelegate;

@interface MFThread: NSThread {
	id <MFThreadDelegate> delegate;
	NSString *cmd;
	int exitCode;
}

@property (assign) id <MFThreadDelegate> delegate;
@property (retain) NSString *cmd;
@property (readonly) int exitCode;

@end

@protocol MFThreadDelegate <NSObject>

- (void) threadEnded: (MFThread *) thread;

@end


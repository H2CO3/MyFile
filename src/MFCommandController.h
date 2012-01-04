//
// MFCommandController.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <stdlib.h>
#import <unistd.h>
#import <stdio.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MFModalController.h"

@interface MFCommandController: MFModalController {
	UITextView *output;
	NSTimer *timer;
	NSString *cmd;
	FILE *f;
	BOOL isRunning;
}

- (id) initWithCommand: (NSString *) command;
- (void) start;
- (void) update;
- (void) end;

@end

//
// MFCompressController.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MFModalController.h"
#import "MFCommandController.h"

@interface MFCompressController: MFModalController <UITextFieldDelegate, UIAlertViewDelegate> {
	NSMutableArray *files;
	NSArray *compressCommands;
	UITextField *fileName;
	UISegmentedControl *type;
	UIButton *doCompress;
	UIViewController *mainController;
}

@property (assign) UIViewController *mainController;

- (id) initWithFiles: (NSArray *) someFiles;
- (void) compress;
- (void) selectionChanged: (UISegmentedControl *) segCtrl;

@end


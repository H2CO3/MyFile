//
// MFNewFileController.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MFModalController.h"
#import "MFAPIDefines.h"

@class MFMainController;

@interface MFNewFileController: MFModalController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
	UITableView *tableView;
	UISwitch *isDir;
	UITextField *fileName;
	UITextField *permissions;
	UITextField *user;
	UITextField *group;
	NSString *path;
	MFMainController *mainController;
}

@property (assign) MFMainController *mainController;
@property (retain) NSString *path;

- (void) done;

@end


//
// MFDropboxNewDirController.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MFModalController.h"
#import "MFFileManager.h"
#import "MFLoadingView.h"
#import "MFAPIDefines.h"

@interface MFDropboxNewDirController: MFModalController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MFFileManagerDelegate> {
        UITableView *tableView;
	UITextField *fileName;
	NSString *path;
        MFFileManager *mgr;  
        MFLoadingView *loadingView;
        id mainController;
}

@property (assign) id mainController;

- (id) initWithPath: (NSString *) path;
- (void) done;

@end

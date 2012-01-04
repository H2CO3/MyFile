//
// MFDropboxController.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PullRefreshModalViewController.h"
#import "MFDropboxNewDirController.h"
#import "MFLoadingView.h"
#import "MFFileManager.h"
#import "Dropbox.h"

@class MFMainController;

@interface MFDropboxController: PullRefreshModalViewController <UIActionSheetDelegate, DBLoginControllerDelegate, MFFileManagerDelegate> {
	NSMutableArray *files;
	MFLoadingView *loadingView;
        UIActionSheet *actions;
	NSString *currentDirectory;
	DBLoginController *loginController;
	MFMainController *mainController;
}

@property (assign) MFMainController *mainController;

- (void) loadRoot;
- (void) loadMetadata: (NSString *) path;
- (void) downloadFile: (NSString *) path;
- (void) deleteFile: (NSString *) path;
- (void) createDirectory: (NSString *) path;

@end


//
// MFSFTPController.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MFModalController.h"
#import "MFSFTPHostController.h"
#import "MFFile.h"
#import "MFFileType.h"
#import "MFLoadingView.h"
#import "MFThread.h"

@class MFSFTPUploadController;

@interface MFSFTPController: MFModalController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, MFSFTPHostControllerDelegate, MFThreadDelegate> {
	UITableView *tableView;
	UIActionSheet *operation;
	UIToolbar *toolbar;
	NSMutableArray *files;
	NSDictionary *server;
	NSString *currentDirectory;
	MFSFTPHostController *hostController;
	MFSFTPUploadController *uploadController;
	MFLoadingView *loadingView;
	int fileIndex;
}

- (void) showLogin;
- (void) showUpload;
- (void) loadParent;
- (void) loadDirectory: (NSString *) dir;
- (void) downloadFile: (NSString *) file;
- (void) uploadFile: (NSString *) file toPath: (NSString *) path;

@end


//
// MFMainController.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"
#import "MFFile.h"
#import "MFFileType.h"
#import "MFFileManager.h"
#import "MFPasteManager.h"
#import "MFLocalizedString.h"
#import "MFUnknownFileController.h"

@class MFBookmarksController, MFDetailsController, MFDropboxController, MFFileSharingController, MFFileViewerController, MFNewFileController, MFPasteController, MFSFTPController, MFSettingsController;
@protocol MFFileViewerControllerDelegate;

@interface MFMainController: PullRefreshTableViewController <UIActionSheetDelegate, UIAlertViewDelegate, UISearchBarDelegate, MFFileViewerControllerDelegate> {
	NSString *currentDirectory;
	NSMutableArray *files;
	NSMutableArray *searchResult;
	UIActionSheet *sheet;
	UIActionSheet *operations;
        UIActionSheet *sharing;
        UIActionSheet *trash;
	UISearchBar *searchBar;
	UIToolbar *toolbar;
	UILabel *footerLabel;
	MFFileManager *fileManager;
	MFBookmarksController *bookmarksController;
	MFDetailsController *detailsController;
	MFDropboxController *dropboxController;
	MFFileSharingController *fileSharingController;
	MFFileViewerController *fileViewerController;
	MFNewFileController *newFileController;
	MFPasteController *pasteController;
        MFSFTPController *sftpController;
	MFSettingsController *settingsController;
	UITabBarController *myPodController;
	int fileIndex;
}

@property (assign) MFFileManager *fileManager;

- (NSString *) currentDirectory;
- (void) leftButtonPressed;
- (void) rightButtonPressed;
- (void) loadDirectory: (NSString *) directory;
- (void) showFile: (MFFile *) f;
- (void) reloadDirectory;
- (void) createFile;
- (void) showAction;
- (void) showDropbox;
- (void) goHome;

@end


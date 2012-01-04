//
// MFDetailsController.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <stdlib.h>
#import <gpod/itdb.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <QuickLook/QuickLook.h>
#import <MFMusicLibrary/MFMusicLibrary.h>
#import "NSString+MD5.h"
#import "MFCompressController.h"
#import "MFModalController.h"
#import "MFFile.h"
#import "MFFileManager.h"
#import "MFSocialManager.h"
#import "MFLoadingView.h"
#import "MFThread.h"
#import "MFFileViewerController.h"
#import "MFPluginManager.h"
#import "MFAPIDefines.h"

@class MFMainController;

@interface MFDetailsController: MFModalController <UITableViewDelegate, UITableViewDataSource, MFFileManagerDelegate, UITextFieldDelegate, MFThreadDelegate, MFMailComposeViewControllerDelegate, QLPreviewControllerDataSource, UIAlertViewDelegate> {
	NSMutableArray *sections;
	NSMutableArray *section0;
	NSMutableArray *section1;
	NSMutableArray *section2;
	NSMutableArray *section3;
	UITableView *tableView;
	UITextField *newName;
	UITextField *newChmod;
	UITextField *newUID;
	UITextField *newGID;
	UILabel *sizeLabel;
	UILabel *mimeLabel;
	UILabel *md5Label;
	UILabel *fileLabel;
        UILabel *atimeLabel;
        UILabel *mtimeLabel;
	UITableViewCell *tempCell;
	MFFile *file;
	MFThread *fileCmd;
	MFLoadingView *loadingView;
	MFFileViewerController *fileViewerController;
	MFMailComposeViewController *mailController;
	MFMainController *mainController;
	int fileQueueCount;
        BOOL shareOnFacebook;
        BOOL shareOnTwitter;
}

@property (retain) MFFile *file;
@property (assign) MFMainController *mainController;

- (id) initWithFile: (MFFile *) aFile;
- (void) runFile;
- (void) upload: (NSString *) path;
- (void) done;

@end


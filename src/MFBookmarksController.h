//
// MFBookmarksController.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MFModalController.h"
#import "MFFileViewerController.h"
#import "MFFile.h"
#import "MFFileType.h"

@class MFMainController;

@interface MFBookmarksController: MFModalController <UITableViewDelegate, UITableViewDataSource> {
	UITableView *tableView;
	NSMutableArray *bookmarks;
	MFMainController *mainController;
}

@property (assign) MFMainController *mainController;

- (void) addBookmark;
- (void) addFile: (NSString *) path;

@end


//
// MFArchiveViewer.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <stdlib.h>
#import <unistd.h>
#import <zip.h>
#import <archive.h>
#import <archive_entry.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MFFile.h"
#import "MFLoadingView.h"
#import "MFCommandController.h"

@class MFFileViewerController;

@interface MFArchiveViewer: UIView <UITableViewDelegate, UITableViewDataSource> {
	UITableView *tableView;
	NSMutableArray *files;
	NSString *command;
	MFFile *archive;
	MFLoadingView *loadingView;
	struct zip *zipfile;
	struct archive *a;
	struct archive_entry *entry;
        MFFileViewerController *mainController;
}

@property (assign) MFFileViewerController *mainController;

- (void) extractFile: (NSString *) path;
- (void) extractAll;
- (id) initWithFile: (MFFile *) file frame: (CGRect) theFrame;

@end


//
// MFPasteController.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MFCompressController.h"
#import "MFModalController.h"
#import "MFPasteManager.h"
#import "MFFile.h"

@class MFMainController;

@interface MFPasteController: MFModalController <UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource> {
	UITableView *tableView;
	UIActionSheet *sheet;
	NSMutableArray *pasteQueue;
        MFMainController *mainController;
}

@property (assign) MFMainController *mainController;

- (void) addFile: (MFFile *) aFile;
- (void) showActions;

@end


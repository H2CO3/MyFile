//
// MFPlistViewer.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MFFile.h"
#import "MFLocalizedString.h"

@class MFFileViewerController;

enum MFPlistNodeType {
	MFPlistNodeTypeDictionary,
	MFPlistNodeTypeArray,
	MFPlistNodeTypeSimple
};

typedef enum MFPlistNodeType MFPlistNodeType;

@interface MFPlistViewer: UIView <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate> {
	MFFile *plist;
	id root;
	UITableView *tableView;
	UIActionSheet *sheet;
	NSMutableArray *keys;
	NSMutableArray *values;
	NSMutableArray *types;
	NSMutableArray *path;
	MFPlistNodeType currentNodeType;
	MFFileViewerController *mainController;
}

@property (assign) MFFileViewerController *mainController;

- (id) initWithFile: (MFFile *) file frame: (CGRect) theFrame;
- (void) showAction;
- (void) loadRoot;
- (void) loadNode: (id) node;
- (void) loadDictionary: (NSDictionary *) dict;
- (void) loadArray: (NSArray *) array;

@end


//
// MFUnknownFileController.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MFModalController.h"
#import "MFFileViewerController.h"
#import "MFFile.h"
#import "MFPluginManager.h"
#import "MFPlugin.h"

@interface MFUnknownFileController: MFModalController <UITableViewDelegate, UITableViewDataSource> {
	MFFile *file;
	UITableView *tableView;
}

- (id) initWithFile:(MFFile *)aFile;

@end

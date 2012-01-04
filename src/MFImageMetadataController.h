//
// MFImageMetadataController.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MFModalController.h"
#import "MFPictureMetadata.h"
#import "MFLocalizedString.h"

@protocol MFImageMetadataEntryControllerDelegate;

@interface MFImageMetadataController: MFModalController <UITableViewDelegate, UITableViewDataSource, MFImageMetadataEntryControllerDelegate> {
	MFPictureMetadata *metadata;
	UITableView *tableView;
}

- (id) initWithFileName: (NSString *) fname;
- (ExifTag) tagForIndexPath: (NSIndexPath *) indexPath;
- (void) done;

@end

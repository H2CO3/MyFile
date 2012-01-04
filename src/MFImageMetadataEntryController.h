//
// MFImageMetadataEntryController.h
// MyFile
//
// Created by Árpád Goretity, 2011
//

#import <libexif/exif-tag.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MFModalController.h"

@protocol MFImageMetadataEntryControllerDelegate;

@interface MFImageMetadataEntryController: MFModalController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
        UITableView *tableView;
        UITextField *val;
        ExifTag tag;
        NSString *value;
        id <MFImageMetadataEntryControllerDelegate> delegate;
}

@property (assign) id <MFImageMetadataEntryControllerDelegate> delegate;

- (id) initWithTag: (ExifTag) aTag value: (NSString *) aValue;
- (void) done;

@end

@protocol MFImageMetadataEntryControllerDelegate <NSObject>

- (void) entryController: (MFImageMetadataEntryController *) entryController didDismissWithTag: (ExifTag) outTag value: (NSString *) outValue;

@end

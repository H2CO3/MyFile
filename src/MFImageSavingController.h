//
// MFImageSavingController.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MFModalController.h"

@interface MFImageSavingController: MFModalController <UITextFieldDelegate> {
	NSString *directory;
	UIImage *image;
	UISegmentedControl *type;
        UILabel *albumLabel;
	UITextField *fileName;
        UIButton *saveButton;
}

- (id) initWithImage: (UIImage *) img directory: (NSString *) dir defaultFileName: (NSString *) fname;
- (void) done;

@end


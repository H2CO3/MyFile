//
// MFHexEditor.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MFFile.h"

@interface MFHexEditor: UIView <UITextViewDelegate> {
	MFFile *file;
	NSString *hexData;
	UITextView *textView;
	UITextView *bytes;
	UITextView *ascii;
}

@property (retain) MFFile *file;
@property (retain) NSString *hexData;

- (MFHexEditor *) initWithFile: (MFFile *) aFile;
- (void) save;

@end


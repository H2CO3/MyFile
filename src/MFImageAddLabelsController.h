//
// MFImageAddLabelsController.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MFModalController.h"

@protocol MFImageAddLabelsControllerDelegate;

@interface MFImageAddLabelsController: MFModalController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
	NSString *text;
        NSMutableArray *allFonts;
	CGPoint point;
	UIFont *font;
	UIColor *color;
        UISlider *redSlider;
        UISlider *greenSlider;
        UISlider *blueSlider;
        UISlider *alphaSlider;
        UILabel *redLabel;
        UILabel *greenLabel;
        UILabel *blueLabel;
        UILabel *alphaLabel;
        UIView *colorView;
        UITextField *fontSize;
        UIPickerView *fontName;
        UITextField *pointField;
        UITextField *textEntry;
	id <MFImageAddLabelsControllerDelegate> delegate;
}

@property (readonly) NSString *text;
@property (readonly) CGPoint point;
@property (readonly) UIFont *font;
@property (readonly) UIColor *color;
@property (assign) id <MFImageAddLabelsControllerDelegate> delegate;

- (void) done;

@end

@protocol MFImageAddLabelsControllerDelegate
- (void) addLabelsControllerDone: (MFImageAddLabelsController *) ctrl;
@end


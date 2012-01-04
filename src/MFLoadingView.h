//
// MFLoadingView.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MFLocalizedString.h"

typedef enum {
	MFLoadingViewTypeProgress = 0,
	MFLoadingViewTypeTemporary = 1
} MFLoadingViewType;

@interface MFLoadingView: UIView {
        UIImageView *background;
        UIProgressView *progressBar;
        UIActivityIndicatorView *spinwheel;
        UILabel *text;
}

- (id) initWithType: (MFLoadingViewType) type;
- (void) show;
- (void) hide;
- (void) setProgress: (float) progress;
- (void) setTitle: (NSString *) title;

@end

//
// MFModalController.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
// #import "MFLocalizedString.h"

@interface MFModalController: UIViewController {
        UIViewController *vctrl;
}

- (void) presentFrom: (UIViewController *) mctrl;
- (void) close;

@end


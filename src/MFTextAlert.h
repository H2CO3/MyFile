//
// MFTextAlert.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MFTextAlert: UIAlertView <UITextFieldDelegate> {
        UITextField *textField;
}

@property (readonly) UITextField *textField;

- (id) initWithTitle: (NSString *) title;

@end

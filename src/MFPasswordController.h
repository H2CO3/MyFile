//
// MFPasswordController.h
// MyFile
//
// Created by ÁrpádGoretity, 2011.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MFLocalizedString.h"

@protocol MFPasswordControllerDelegate;

@interface MFPasswordController: UIViewController <UITableViewDataSource, UITextFieldDelegate, UIAlertViewDelegate> {
	unsigned int numOfTries;
	id <MFPasswordControllerDelegate> delegate;
	UITableView *tableView;
	UITextField *textField;
	NSString *password;
}

@property (assign) id <MFPasswordControllerDelegate> delegate;

- (void) done;

@end

@protocol MFPasswordControllerDelegate <NSObject>
- (void) passwordControllerAcceptedPassword;
@end


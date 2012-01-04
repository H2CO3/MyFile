//
//  DBLoginController.h
//  DropboxSDK
//
//  Created by Brian Smith on 5/20/10.
//  Copyright 2010 Dropbox, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UI_USER_INTERFACE_IDIOM() ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)] ? [[UIDevice currentDevice] userInterfaceIdiom] : 0)

@interface UINavigationController (iOS_3_2)
@property (assign) int modalPresentationStyle;
@end

@class DBLoadingView;
@class DBRestClient;
@protocol DBLoginControllerDelegate;

@interface DBLoginController : UIViewController {
    BOOL hasAppeared; // Used to track whether the view totally onscreen
    id<DBLoginControllerDelegate> delegate;
    
    UITableView* tableView;
    UILabel* descriptionLabel;
    UITableViewCell* emailCell;
    UITextField* emailField;
    UITableViewCell* passwordCell;
    UITextField* passwordField;
    UIView* footerView;

    DBLoadingView* loadingView;
    UIActivityIndicatorView* activityIndicator;
    
    DBRestClient* restClient;
}

- (void)presentFromController:(UIViewController*)controller;

@property (nonatomic, assign) id<DBLoginControllerDelegate> delegate;

@end


// This controller tells the delegate whether the user sucessfully logged in or not
// The login controller will dismiss itself
@protocol DBLoginControllerDelegate

- (void)loginControllerDidLogin:(DBLoginController*)controller;
- (void)loginControllerDidCancel:(DBLoginController*)controller;

@end

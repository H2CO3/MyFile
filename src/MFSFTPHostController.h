//
// MFSFTPHostController.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MFModalController.h"

@protocol MFSFTPHostControllerDelegate;

@interface MFSFTPHostController: MFModalController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
	UITableView *tableView;
	UITextField *hostName;
	UITextField *login;
	UITextField *password;
	id <MFSFTPHostControllerDelegate> delegate;
}

@property (assign) id <MFSFTPHostControllerDelegate> delegate;

@end


@protocol MFSFTPHostControllerDelegate <NSObject>

- (void) hostController: (MFSFTPHostController *) controller didReceiveHostInfo: (NSDictionary *) hostInfo;

@end


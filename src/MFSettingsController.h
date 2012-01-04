//
// MFSettingsController.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Dropbox.h"
#import "MFAboutController.h"
#import "MFHelpController.h"
#import "MFModalController.h"
#import "MFSocialManager.h"

@interface MFSettingsController: MFModalController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, DBLoginControllerDelegate> {
	UITableView *tableView;
	UISwitch *passwordEnabled;
	UITextField *passwordString;
	UITextField *fontSize;
	UITextField *uploadPath;
	UITextField *homeDir;
        UITextField *dropboxdLocal;
        UITextField *dropboxdRemote;
	UISwitch *useTrash;
	UISwitch *uploadSpecific;
	UISwitch *alwaysHome;
        UISwitch *dropboxDaemon;
        UISwitch *convertSpaces;
	MFAboutController *aboutController;
        MFHelpController *helpController;
}

- (void) done;

@end


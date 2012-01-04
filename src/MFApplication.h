//
// MFApplication.h
// MyFile
//
// Created by Àrpád Goretity, 2011.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MFFile.h"
#import "MFSocialManager.h"
#import "MFDonateController.h"
#import "MFFileViewerController.h"
#import "MFMainController.h"
#import "MFPasswordController.h"
#import "MFLocalizedString.h"

@interface MFApplication: NSObject <UIApplicationDelegate, UIAlertViewDelegate, MFPasswordControllerDelegate> {
	UIWindow *mainWindow;
	MFMainController *mc;
	MFPasswordController *pc;
	UINavigationController *passwordController;
	UINavigationController *mainController;
	MFFileViewerController *fileViewerController;
}

@end


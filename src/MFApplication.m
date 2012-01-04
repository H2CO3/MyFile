//
// MFApplication.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFApplication.h"

@implementation MFApplication

// UIApplicationDelegate

- (BOOL) application: (UIApplication *) application didFinishLaunchingWithOptions: (NSDictionary *) options {

	mainWindow = [[UIWindow alloc] initWithFrame: CGRectMake(0, 0, 320, 480)];
	[mainWindow makeKeyAndVisible];

	mc = [[MFMainController alloc] init];
	mainController = [[UINavigationController alloc] initWithRootViewController: mc];
	mainController.navigationBar.barStyle = UIBarStyleBlack;
	
	if ([[NSUserDefaults standardUserDefaults] boolForKey: @"MFPasswordEnabled"]) {

		pc = [[MFPasswordController alloc] init];
		pc.delegate = self;
	passwordController = [[UINavigationController alloc] initWithRootViewController: pc];
		[mainWindow addSubview: passwordController.view];
		[mainWindow addSubview: passwordController.view];

	} else {
	
		[mainWindow addSubview: mainController.view];
		
	}
	
	if (![[NSUserDefaults standardUserDefaults] boolForKey: @"MFDonateShown15"]) {

		UIAlertView *donate = [[UIAlertView alloc] init];
		donate.title = MFLocalizedString(@"Please donate");
		donate.delegate = self;
		donate.message = MFLocalizedString(@"Lots of hard work went into the development of MyFile. I kindly ask you to donate in order to let me buy a new iPhone. I need this to be able to test MyFile and my other apps against recent iOS versions as my old device is no longer supported by Apple. Thank you very much!");
		[donate addButtonWithTitle: MFLocalizedString(@"Donate")];
		[donate addButtonWithTitle: MFLocalizedString(@"Later")];
		[donate show];
		[donate release];
		[[NSUserDefaults standardUserDefaults] setBool: YES forKey: @"MFDonateShown15"];
		[[NSUserDefaults standardUserDefaults] synchronize];

	}
	
	return YES;
	
}

- (BOOL) application: (UIApplication *) application handleOpenURL: (NSURL *) url {

	BOOL retVal;

	if (![[url scheme] hasPrefix: @"fb"]) {

		MFFile *file = [[MFFile alloc] init];
		[[NSFileManager defaultManager] moveItemAtPath: [url path] toPath: [@"/var/mobile/Documents" stringByAppendingPathComponent: [[url path] lastPathComponent]] error: NULL];
		file.path = @"/var/mobile/Documents";
		file.name = [[url path] lastPathComponent];
		file.type = [MFFileType fileTypeForName: file.name];
		fileViewerController = [[MFFileViewerController alloc] initWithFile: file];
		[file release];
		[fileViewerController presentFrom: [[NSUserDefaults standardUserDefaults] boolForKey: @"MFPasswordEnabled"] ? passwordController : mainController];
		
		retVal = YES;
		
	} else {
	
		retVal = [[[MFSocialManager sharedManager] facebook] handleOpenURL: url];
		
	}
	
	return retVal;

}

/*
- (void) applicationDidEnterBackground: (UIApplication *) sender {

	exit (0);
	
}
*/

// self

- (void) imageSaved: (UIImage *) img error: (NSError *) error name: (NSString *) name {
	UIAlertView *av = [[UIAlertView alloc] init];
	av.title = MFLocalizedString(@"Image saved");
	av.message = [NSString stringWithFormat: MFLocalizedString(@"The image '%@' was successfully added to the camera roll."), name];
	[av addButtonWithTitle: MFLocalizedString(@"Dismiss")];
	[av show];
	[av release];
}

- (void) videoSaved: (NSString *) path error: (NSError *) error name: (NSString *) name {
	UIAlertView *av = [[UIAlertView alloc] init];
	av.title = MFLocalizedString(@"Video saved");
	av.message = [NSString stringWithFormat: MFLocalizedString(@"The video '%@' was successfully added to the camera roll."), name];
	[av addButtonWithTitle: MFLocalizedString(@"Dismiss")];
	[av show];
	[av release];
}

// MFPasswordControllerDelegate

- (void) passwordControllerAcceptedPassword {

	[passwordController presentModalViewController: mainController animated: YES];
	
}

// UIAlertViewDelegate

- (void) alertView: (UIAlertView *) alertView didDismissWithButtonIndex: (int) index {

	if (index == 0) {

		MFDonateController *donateController = [[MFDonateController alloc] init];
		[donateController presentFrom: mainController];
		[donateController release];
		
	}
	
	[[[[UIAlertView alloc] initWithTitle: MFLocalizedString(@"Generate hash") message: MFLocalizedString(@"Don't forget to generate a HashInfo file to use iPod library support. See Seetings -> Help for details.") delegate: nil cancelButtonTitle: MFLocalizedString(@"Dismiss") otherButtonTitles: nil] autorelease] show];

}

// super

- (void) dealloc {

	[mainController release];
	mainController = nil;
	[mainWindow release];
	mainWindow = nil;
	[fileViewerController release];
	fileViewerController = nil;

	[super dealloc];

}

@end


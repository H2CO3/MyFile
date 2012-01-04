//
// MFModalController.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFModalController.h"

@implementation MFModalController

// super

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orientation {

	return (orientation == UIInterfaceOrientationPortrait) || (orientation == UIInterfaceOrientationLandscapeRight);

}

- (id) init {

	self = [super init];
	
	UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle: MFLocalizedString(@"Close") style: UIBarButtonItemStylePlain target: self action: @selector(close)];
	self.navigationItem.leftBarButtonItem = leftButtonItem;
	[leftButtonItem release];
	
	return self;

}

// self

- (void) presentFrom: (UIViewController *) mctrl {

	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: self];
	navController.navigationBar.barStyle = UIBarStyleBlack;
	vctrl = [mctrl retain];
	[vctrl presentModalViewController: navController animated: YES];
	[navController release];

}

- (void) close {

	[vctrl dismissModalViewControllerAnimated: YES];
	[vctrl release];

}

@end

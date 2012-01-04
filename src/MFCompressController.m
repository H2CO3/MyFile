//
// MFCompressController.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFCompressController.h"

@implementation MFCompressController

@synthesize mainController = mainController;

// self

- (id) initWithFiles: (NSArray *) someFiles {

	self = [super init];

	self.view.backgroundColor = [UIColor groupTableViewBackgroundColor]; // [UIColor whiteColor];
	self.title = MFLocalizedString(@"Compress files");
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(compress)] autorelease];

	files = [[NSMutableArray alloc] init];
	[files addObjectsFromArray: someFiles];

	compressCommands = [[NSArray alloc] initWithObjects: @"cd %@; zip -r %@ %@", @"cd %@; tar -czvf %@ %@", @"cd %@; tar --bzip2 -cvf %@ %@", @"cd %@; xar -cvf %@ %@", @"cd %@; dpkg-deb --build %@ %@", nil];

	fileName = [[UITextField alloc] initWithFrame: CGRectMake (20, 40, 280, 30)];
	fileName.placeholder = MFLocalizedString(@"Type file name here");
	fileName.text = [NSString stringWithFormat: @"%@.zip", [[someFiles objectAtIndex: 0] lastPathComponent]];
	fileName.borderStyle =  UITextBorderStyleRoundedRect;
	fileName.clearButtonMode = UITextFieldViewModeWhileEditing;
	fileName.delegate = self;
	[self.view addSubview: fileName];
	[fileName release];

	type = [[UISegmentedControl alloc] initWithItems: [NSArray arrayWithObjects: @"zip", @"gzip", @"bzip2", @"xar", @"deb", nil]];
	type.frame = CGRectMake (20, 100, 280, 45);
	type.selectedSegmentIndex = 0;
	[type addTarget: self action: @selector(selectionChanged:) forControlEvents: UIControlEventValueChanged];
	[self.view addSubview: type];
	[type release];

	doCompress = [UIButton buttonWithType: UIButtonTypeRoundedRect];
	doCompress.frame = CGRectMake (20,   180, 280, 45); 
	[doCompress setTitle: MFLocalizedString(@"Compress") forState: UIControlStateNormal];
	[doCompress addTarget: self action: @selector(compress) forControlEvents: UIControlEventTouchUpInside];
	[self.view addSubview: doCompress];

	return self;

}

- (void) compress {

	if ((fileName.text == nil) || [fileName.text isEqualToString: @""]) {
		[[[[UIAlertView alloc] initWithTitle: MFLocalizedString(@"Compress failed") message: MFLocalizedString(@"Please specify output filename.") delegate: nil cancelButtonTitle: MFLocalizedString(@"Dismiss") otherButtonTitles: nil] autorelease] show];
		return;
	}

	if (type.selectedSegmentIndex != 4) {

		NSString *cmd = [[NSString alloc] initWithFormat: [compressCommands objectAtIndex: type.selectedSegmentIndex], [self.mainController currentDirectory], fileName.text, [files count] > 1 ? [files componentsJoinedByString: @" "] : [[files objectAtIndex: 0] lastPathComponent]];
		MFCommandController *cmdCtrl = [[MFCommandController alloc] initWithCommand: cmd];
		[cmd release];
		[cmdCtrl presentFrom: self];
		[cmdCtrl start];
		[cmdCtrl release];

	} else {

		NSString *cmd = [[NSString alloc] initWithFormat: [compressCommands objectAtIndex: type.selectedSegmentIndex], [self.mainController currentDirectory], [files componentsJoinedByString: @" "], fileName.text];
		MFCommandController *cmdCtrl = [[MFCommandController alloc] initWithCommand: cmd];
		[cmd release];
		[cmdCtrl presentFrom: self];
		[cmdCtrl start];
		[cmdCtrl release];

	}

}

- (void) selectionChanged: (UISegmentedControl *) segCtrl {

	int idx = segCtrl.selectedSegmentIndex;
	NSString *stem = [[fileName.text lastPathComponent] stringByDeletingPathExtension];
	NSString *newExt;
	if (idx == 0) {
		newExt = @"zip";
	} else if (idx == 1) {
		newExt = @"tgz";
	} else if (idx == 2) {
		newExt = @"tbz";
	} else if (idx == 3) {
		newExt = @"xar";
	} else if (idx == 4) {
		newExt = @"deb";
	}
	
	fileName.text = [NSString stringWithFormat: @"%@.%@", stem, newExt];
	
}

// UITextFieldDelegate

- (BOOL) textFieldShouldReturn: (UITextField *) textField {

	[textField resignFirstResponder];

	return YES;

}

// UIAlertViewDelegate

- (void) alertView: (UIAlertView *) alertView didDismissWithButtonIndex: (int) index {

	[self close];
	
}

// super

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orientation {

	return UIInterfaceOrientationIsPortrait (orientation);

}

- (void) close {

        [self.mainController reloadDirectory];

        [super close];

}

- (void) dealloc {

	[files release];
	files = nil;
	[compressCommands release];
	compressCommands = nil;

	[super dealloc];

}

@end


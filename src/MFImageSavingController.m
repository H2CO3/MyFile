//
// MFImageSavingController.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFImageSavingController.h"
#undef MFLocalizedString
#define MFLocalizedString(x) (NSLocalizedString((x), @""))


@implementation MFImageSavingController

// self

- (id) initWithImage: (UIImage *) img directory: (NSString *) dir defaultFileName: (NSString *) fname {

	self = [super init];
	self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	self.navigationItem.title = MFLocalizedString(@"Saving image");
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(done)] autorelease];
	
	directory = [dir copy];
	image = [img retain];
	
	fileName = [[UITextField alloc] initWithFrame: CGRectMake (20, 40, 280, 30)];
	fileName.placeholder = MFLocalizedString(@"Type file name here");
	fileName.text = fname;
	fileName.borderStyle =	UITextBorderStyleRoundedRect;
	fileName.clearButtonMode = UITextFieldViewModeWhileEditing;
	fileName.delegate = self;
	[self.view addSubview: fileName];
	[fileName release];

	albumLabel = [[UILabel alloc] initWithFrame: CGRectMake (20, 40, 280, 30)];
	albumLabel.backgroundColor = [UIColor clearColor];
	albumLabel.alpha = 0.0;
	albumLabel.font = [UIFont boldSystemFontOfSize: 16.0];
	albumLabel.text = MFLocalizedString(@"Image will be saved to the camera roll.");
	[self.view addSubview: albumLabel];
	[albumLabel release];

	type = [[UISegmentedControl alloc] initWithItems: [NSArray arrayWithObjects: @"PNG", @"JPEG", MFLocalizedString(@"Photos"), nil]];
	type.frame = CGRectMake (20, 100, 280, 45);
	type.selectedSegmentIndex = 0;
	[type addTarget: self action: @selector(typeChanged:) forControlEvents: UIControlEventValueChanged];
	[self.view addSubview: type];
	[type release];

	saveButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
	saveButton.frame = CGRectMake (20, 165, 280, 45);
	[saveButton setTitle: MFLocalizedString(@"Save image") forState: UIControlStateNormal];
	[saveButton addTarget: self action: @selector(done) forControlEvents: UIControlEventTouchUpInside];
	[self.view addSubview: saveButton];

	return self;
	
}

- (void) typeChanged: (UISegmentedControl *) segCtrl {

	if (segCtrl.selectedSegmentIndex == 2) {

		// disable/hide filename field
		[UIView beginAnimations: NULL context: NULL];
		[UIView setAnimationDuration: 0.3];
		fileName.alpha = 0.0;
		albumLabel.alpha = 1.0;
		[UIView commitAnimations];
		fileName.enabled = NO;

	} else {

		// enable/show filename field
		fileName.enabled = YES;
		[UIView beginAnimations: NULL context: NULL];
		[UIView setAnimationDuration: 0.3];
		fileName.alpha = 1.0;
		albumLabel.alpha = 0.0;
		[UIView commitAnimations];

	}

}

- (void) done {

	if (type.selectedSegmentIndex == 0) {
		NSData *imageData = UIImagePNGRepresentation (image);
		seteuid(0);
		[imageData writeToFile: [directory stringByAppendingPathComponent: fileName.text] atomically: NO];
		seteuid(501);
	} else if (type.selectedSegmentIndex == 1) {
		NSData *imageData = UIImageJPEGRepresentation (image, 1.0);
		seteuid(0);
		[imageData writeToFile: [directory stringByAppendingPathComponent: fileName.text] atomically: NO];
		seteuid(501);
	} else if (type.selectedSegmentIndex == 2) {
		// save to Photo Album
				UIImageWriteToSavedPhotosAlbum (image, [[UIApplication sharedApplication] delegate], @selector(imageSaved:error:name:), fileName.text);
	}

	[self close];
	
}

// super

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orientation {
	return UIInterfaceOrientationIsPortrait (orientation);
}

- (void) dealloc {
	[directory release];
	[super dealloc];
}

// UITextFieldDelegate

- (BOOL) textFieldShouldReturn: (UITextField *) textField {

	[textField resignFirstResponder];
	
	return YES;
	
}

@end


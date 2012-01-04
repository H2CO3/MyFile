//
// MFFileViewerController.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFFileViewerController.h"
#import "MFImageSavingController.h"
#import "MFTextAlert.h"

#undef MFLocalizedString
#define MFLocalizedString(x) (NSLocalizedString((x), @""))


@implementation MFFileViewerController

@synthesize file = file;
@synthesize delegate = delegate;
@synthesize type = type;

// super

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orientation {

	BOOL result;

	if (landscapeOnly) {
	
		result = (orientation == UIInterfaceOrientationLandscapeRight) || ((orientation == UIInterfaceOrientationLandscapeLeft && (!rightOnly)));
		
	} else if (portraitOnly) {
	
		result = UIInterfaceOrientationIsPortrait (orientation);
		
	} else {

		result = YES;
	}
	
	return result;
	
}

- (void) close {

	[audioPlayer stop];
	[moviePlayer stop];
	if (filesystemModified) {
		[self.delegate fileViewerDidFinishViewing: self];
	}
	[super close];
	
}

- (void) dealloc {

	[archiveViewer release];
	archiveViewer = nil;
	[audioPlayer release];
	audioPlayer = nil;
	[hexEditor release];
	hexEditor = nil;
	[plistViewer release];
	plistViewer = nil;
	[sqlViewer release];
	sqlViewer = nil;
	[moviePlayer release];
	moviePlayer = nil;
	[webView release];
	webView = nil;
	[textView release];
	textView = nil;
	[scrollView release];
	scrollView = nil;
	[imageView release];
	imageView = nil;
	[imageOps release];
	imageOps = nil;
	[searchBar release];
	searchBar = nil;
	[effects release];
	effects = nil;

	[super dealloc];

}

// self

- (id) initWithFile: (MFFile *) aFile {

	self = [self initWithFile: aFile type: aFile.type];

	return self;

}

- (id) initWithFile: (MFFile *) aFile type: (NSString *) theType {

	self = [super init];
	
	self.file = aFile;
	self.view.backgroundColor = [UIColor whiteColor];
	self.title = self.file.name;
	self.type = theType;
	filesystemModified = NO;

	if ([self.type isEqualToString: @"text"]) {
	
		UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemSave target: self action: @selector(saveText)];
		rightButton.enabled = NO;
		self.navigationItem.rightBarButtonItem = rightButton;
		[rightButton release];

		searchBar = [[UISearchBar alloc] initWithFrame: CGRectMake (0, 0, 320, 44)];
		searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		searchBar.barStyle = UIBarStyleBlackOpaque;
		searchBar.showsCancelButton = YES;
		searchBar.delegate = self;
		searchBar.placeholder = MFLocalizedString(@"Text to be searched for");

		textRange = NSMakeRange (0, 0);
		searchText = @"";

		textView = [[UITextView alloc] initWithFrame: UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? [[UIScreen mainScreen] applicationFrame] : CGRectMake (0, 0, 320, 460)];
		textView.font = [UIFont fontWithName: @"courier" size: [[NSUserDefaults standardUserDefaults] floatForKey: @"MFFontSize"] != 0 ? [[NSUserDefaults standardUserDefaults] floatForKey: @"MFFontSize"] : 12.0];
		textView.autocorrectionType = UITextAutocorrectionTypeNo;
		textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
		textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		textView.delegate = self;
		NSString *str = [[NSString alloc] initWithContentsOfFile: [self.file fullPath] encoding: NSUTF8StringEncoding error: NULL];
		if ((str == nil) || ([str length] == 0)) {
			str = [[NSString alloc] initWithContentsOfFile: [self.file fullPath] encoding: NSASCIIStringEncoding error: NULL];
		}
		textView.text = str;
		[self.view addSubview: textView];

		UIMenuItem *findItem = [[UIMenuItem alloc] initWithTitle: MFLocalizedString(@"Find") action: @selector(findText)];
		[[UIMenuController sharedMenuController] setMenuItems: [NSArray arrayWithObject: findItem]];
		[findItem release];

		landscapeOnly = NO;
		rightOnly = NO;
		portraitOnly = NO;
		
	} else if ([self.type isEqualToString: @"image"]) {
	
		UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAction target: self action: @selector(showImageOps)];
		self.navigationItem.rightBarButtonItem = rightButton;
		[rightButton release];
		self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: @"imagebg.png"]];
		imageView = [[UIImageView alloc] initWithImage: [UIImage imageWithContentsOfFile: [self.file fullPath]]];
		imageView.backgroundColor = [UIColor clearColor];

		scrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
		scrollView.autoresizingMask = self.view.autoresizingMask;
		scrollView.contentSize = imageView.image.size;
		scrollView.delegate = self;
		scrollView.maximumZoomScale = 6.0;
		scrollView.minimumZoomScale = 0.25;
		[scrollView addSubview: imageView];
		[self.view addSubview: scrollView];

		imageOps = [[UIActionSheet alloc] init];
		imageOps.title = MFLocalizedString(@"Image operations");
		imageOps.delegate = self;
		imageOps.actionSheetStyle = UIActionSheetStyleBlackOpaque;
		imageOps.cancelButtonIndex = 4;
		[imageOps addButtonWithTitle: MFLocalizedString(@"Fit to screen")];
		[imageOps addButtonWithTitle: MFLocalizedString(@"Show metadata")];
		[imageOps addButtonWithTitle: MFLocalizedString(@"Image effects")];
		[imageOps addButtonWithTitle: MFLocalizedString(@"Save image")];
		[imageOps addButtonWithTitle: MFLocalizedString(@"Cancel")];

		effects = [[UIActionSheet alloc] init];
		effects.title = MFLocalizedString(@"Image effects");
		effects.actionSheetStyle = UIActionSheetStyleBlackOpaque;
		effects.delegate = self;
		effects.cancelButtonIndex = 7;
		[effects addButtonWithTitle: MFLocalizedString(@"Scale")];
		[effects addButtonWithTitle: MFLocalizedString(@"Crop")];
		[effects addButtonWithTitle: MFLocalizedString(@"Rotate")];
		[effects addButtonWithTitle: MFLocalizedString(@"Rounded corners")];
		[effects addButtonWithTitle: MFLocalizedString(@"Set transparency")];
		[effects addButtonWithTitle: MFLocalizedString(@"Grayscale")];
		[effects addButtonWithTitle: MFLocalizedString(@"Add labels")];
		[effects addButtonWithTitle: MFLocalizedString(@"Cancel")];

		UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(toggleNavBar)];
		[tapRec setNumberOfTapsRequired: 2];
		[self.view addGestureRecognizer: tapRec];
		[tapRec release];
		
		UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(goToPrevImage)];
		[leftSwipe setDirection: 1 << 1]; // left
		[leftSwipe setNumberOfTouchesRequired: 2];
		[self.view addGestureRecognizer: leftSwipe];
		[leftSwipe release];

		UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(goToNextImage)];
		[rightSwipe setDirection: 1 << 0]; // right
		[rightSwipe setNumberOfTouchesRequired: 2];
		[self.view addGestureRecognizer: rightSwipe];
		[rightSwipe release];

		imageTransform = MFImageTransformNone;

		landscapeOnly = NO;
		rightOnly = NO;
		portraitOnly = NO;

	} else if ([self.type isEqualToString: @"sound"]) {

		audioPlayer = [[MFAudioPlayer alloc] initWithFile: self.file];
		audioPlayer.controller = self;
		[self.view addSubview: audioPlayer];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemEdit target: self action: @selector(editId3Tags)] autorelease];
		landscapeOnly = NO;
		rightOnly = NO;
		portraitOnly = YES;
		
	} else if ([self.type isEqualToString: @"video"]) {
	/*
		landscapeOnly = YES;
		rightOnly = YES;
		portraitOnly = NO;
		moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL: [self.file fileUrl]];
		moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
		moviePlayer.view.frame = CGRectMake (0, 0, 480, 300);
		[self.view addSubview: moviePlayer.view];
		[moviePlayer setFullscreen: YES animated: YES];
		[moviePlayer play];

		UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(toggleNavBar)];
		[tapRec setNumberOfTapsRequired: 2];
		[tapRec setNumberOfTouchesRequired: 2];
		[moviePlayer.view addGestureRecognizer: tapRec];
		[tapRec release];
	*/
		MPMoviePlayerViewController *mpc = [[[MPMoviePlayerViewController alloc] initWithContentURL: [self.file fileUrl]] autorelease];
		[self performSelector: @selector(presentMoviePlayerViewControllerAnimated:) withObject: mpc afterDelay: 2.0];
	} else if ([self.type isEqualToString: @"package"]) {

		archiveViewer = [[MFArchiveViewer alloc] initWithFile: self.file frame: UIInterfaceOrientationIsLandscape (self.interfaceOrientation) ? [[UIScreen mainScreen] applicationFrame] : CGRectMake (0, 0, 320, 460)];
		archiveViewer.mainController = self;
		[self.view addSubview: archiveViewer];
		
		if (![[self.file.name pathExtension] isEqualToString: @"deb"]) {
			UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAction target: archiveViewer action: @selector(extractAll)];
			self.navigationItem.rightBarButtonItem = rightButton;
			[rightButton release];
		}
		
		landscapeOnly = NO;
		rightOnly = NO;
		portraitOnly = NO;

	} else if ([self.type isEqualToString: @"database"]) {

		sqlViewer = [[MFSQLViewer alloc] initWithFile: self.file frame: UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? [[UIScreen mainScreen] applicationFrame] : CGRectMake (0, 0, 320, 460)];
		sqlViewer.mainViewController = self;
		[self.view addSubview: sqlViewer];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemOrganize target: sqlViewer action: @selector(showTables)] autorelease];

		landscapeOnly = NO;
		rightOnly = NO;
		portraitOnly = NO;
		
	} else if ([self.type isEqualToString: @"plist"]) {
	
		plistViewer = [[MFPlistViewer alloc] initWithFile: self.file frame: (UIInterfaceOrientationIsLandscape (self.interfaceOrientation) ? [[UIScreen mainScreen] applicationFrame] : CGRectMake (0, 0, 320, 460))];
		plistViewer.mainController = self;
		[self.view addSubview: plistViewer];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAction target: plistViewer action: @selector(showAction)] autorelease];
		
		landscapeOnly = NO;
		portraitOnly = NO;
		
	} else if ([self.type isEqualToString: @"binary"]) {
	
		hexEditor = [[MFHexEditor alloc] initWithFile: self.file];
		[self.view addSubview: hexEditor];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(saveHex)] autorelease];

		landscapeOnly = YES;
		rightOnly = NO;
		portraitOnly = NO;		

	} else {
	
		webView = [[UIWebView alloc] initWithFrame: UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? [[UIScreen mainScreen] applicationFrame] : CGRectMake (0, 0, 320, 460)];
		webView.scalesPageToFit = YES;
		webView.userInteractionEnabled = YES;
		webView.multipleTouchEnabled = YES;
		webView.autoresizingMask = self.view.autoresizingMask;
		[webView loadRequest: [NSURLRequest requestWithURL: [self.file fileUrl]]];
		[self.view addSubview: webView];

		UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(toggleNavBar)];
		[tapRec setNumberOfTapsRequired: 2];
		[tapRec setNumberOfTouchesRequired: 3];
		[webView addGestureRecognizer: tapRec];
		[tapRec release];
		
		landscapeOnly = NO;
		rightOnly = NO;
		portraitOnly = NO;
	
	}

	return self;
	
}

- (void) setFilesystemModified {

	filesystemModified = YES;

}

- (void) toggleNavBar {

	if (navBarHidden) {

		[[UIApplication sharedApplication] setStatusBarHidden: NO animated: YES];
		[self.parentViewController setNavigationBarHidden: NO animated: YES];
		navBarHidden = NO;

	} else {

		[[UIApplication sharedApplication] setStatusBarHidden: YES animated: YES];
		[self.parentViewController setNavigationBarHidden: YES animated: YES];
		navBarHidden = YES;

	}

}

- (void) saveText {

	[textView resignFirstResponder];
	textView.frame = UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? CGRectMake(0, 0, 480, 268) : CGRectMake (0, 0, 320, 416);
	NSString *outText;
	if ([[NSUserDefaults standardUserDefaults] boolForKey: @"MFConvertSpaces"]) {
                NSMutableString *eightSpaces = [[NSMutableString alloc] init];
                for (int i = 0; i < 8; i++) {
                        [eightSpaces appendString:@" "];
                }
		outText = [textView.text stringByReplacingOccurrencesOfString:eightSpaces withString:@"\t"];
                [eightSpaces release];
	} else {
		outText = textView.text;
	}
	textView.text = outText;
	seteuid(0);
	[outText writeToFile: [self.file fullPath] atomically: NO encoding: NSUTF8StringEncoding error: NULL];
	seteuid(501);
	self.navigationItem.rightBarButtonItem.enabled = NO;
	[self setFilesystemModified];

}

- (void) saveHex {

	[hexEditor save];
	[self setFilesystemModified];

}

- (void) findText {

	textView.inputAccessoryView = searchBar;
	[textView resignFirstResponder];
	[textView becomeFirstResponder];
	[searchBar becomeFirstResponder];
	textView.frame = (UIInterfaceOrientationIsLandscape (self.interfaceOrientation) ? CGRectMake (0, 0, 480, 62) : CGRectMake (0, 0, 320, 156));

}

- (void) reloadAudioMetadata {

	[audioPlayer reloadMetadata];
	
}

- (void) showImageOps {

	[imageOps showInView: self.view];

}

- (void) fit {

	[scrollView zoomToRect: CGRectMake (0, 0, imageView.image.size.width, imageView.image.size.height) animated: YES];
	
}

- (void) editId3Tags {

	MFID3TagEditorController *tagEditor = [[MFID3TagEditorController alloc] initWithTag: audioPlayer.id3tag];
	tagEditor.mainController = self;
	[tagEditor presentFrom: self];
	[tagEditor release];
	
}

- (void) editImageMetadata {

	imgMetadataController = [[MFImageMetadataController alloc] initWithFileName: [file fullPath]];
	[imgMetadataController presentFrom: self];
	[imgMetadataController release];

}

- (void) goToNextImage {
	NSString *img = [self nextImageFile];
	if (img != nil) {
		[self setImageFile: img];
	}
}

- (void) goToPrevImage {
	NSString *img = [self prevImageFile];
	if (img != nil) {
		[self setImageFile: img];
	}
}

- (void) setImageFile: (NSString *) imageFile {

	[file release];
	file = [[MFFile alloc] init];
	file.path = [imageFile stringByDeletingLastPathComponent];
	file.name = [imageFile lastPathComponent];
	file.type = @"image";
	self.navigationItem.title = file.name;
	UIImage *tmpImage = [[UIImage alloc] initWithContentsOfFile: [file fullPath]];
	imageView.image = tmpImage;
	// imageView.frame = CGRectMake (0, 0, tmpImage.size.width, tmpImage.size.height);
	[imageView sizeToFit];
	[tmpImage release];
	
}

- (NSString *) nextImageFile {

	NSMutableArray *files = [[NSMutableArray alloc] init];
	NSMutableArray *imageFiles = [[NSMutableArray alloc] init];
	[files addObjectsFromArray: [[[self delegate] fileManager] contentsOfDirectory: file.path]];
	for (int i = 0; i < [files count]; i++) {
		if ([[[files objectAtIndex: i] type] isEqualToString: @"image"]) {
			[imageFiles addObject: [files objectAtIndex: i]];
		}
	}
	[files release];
	int nextFilePosition = -1;
	for (int i = 0; i < [imageFiles count]; i++) {
		if ([[[imageFiles objectAtIndex: i] name] isEqualToString: file.name]) {
			nextFilePosition = i + 1;
			break;
		}
	}
	NSString *ret;
	if (nextFilePosition >= [imageFiles count]) {
		ret = nil;
	} else {
		ret = [[imageFiles objectAtIndex: nextFilePosition] fullPath];
	}
	[imageFiles release];
	
	return ret;
	
}

- (NSString *) prevImageFile {

	NSMutableArray *files = [[NSMutableArray alloc] init];
	NSMutableArray *imageFiles = [[NSMutableArray alloc] init];
	[files addObjectsFromArray: [[[self delegate] fileManager] contentsOfDirectory: file.path]];
	for (int i = 0; i < [files count]; i++) {
		if ([[[files objectAtIndex: i] type] isEqualToString: @"image"]) {
			[imageFiles addObject: [files objectAtIndex: i]];
		}
	}
	[files release];
	int nextFilePosition = -1;
	for (int i = 0; i < [imageFiles count]; i++) {
		if ([[[imageFiles objectAtIndex: i] name] isEqualToString: file.name]) {
			nextFilePosition = i - 1;
			break;
		}
	}
	NSString *ret;
	if (nextFilePosition < 0) {
		ret = nil;
	} else {
		ret = [[imageFiles objectAtIndex: nextFilePosition] fullPath];
	}
	[imageFiles release];
	
	return ret;
	
}

// MFImageAddLabelsControllerDelegate

- (void) addLabelsControllerDone: (MFImageAddLabelsController *) ctrl {

	imageTransform = MFImageTransformNone;
	imageView.image = [imageView.image addText: ctrl.text atPoint: ctrl.point withFont: ctrl.font ofColor: ctrl.color];
	imageView.frame = CGRectMake (0, 0, imageView.image.size.width, imageView.image.size.height);
	
}

// UISearchBarDelegate

- (void) searchBarSearchButtonClicked: (UISearchBar *) bar {

	if (![[searchText lowercaseString] isEqualToString: [bar.text lowercaseString]]) {
		textRange = NSMakeRange (0, 0);
	}
	searchText = [bar.text copy];
	textRange = [textView.text rangeOfString: bar.text options: NSCaseInsensitiveSearch range: NSMakeRange (textRange.location + textRange.length, [textView.text length] - (textRange.location + textRange.length))];
	textView.selectedRange = textRange;

}

- (void) searchBarCancelButtonClicked: (UISearchBar *) bar {

	textView.frame = (UIInterfaceOrientationIsLandscape (self.interfaceOrientation) ? CGRectMake (0, 0, 480, 106) : CGRectMake (0, 0, 320, 200));
	[bar resignFirstResponder];
	textView.inputAccessoryView = nil;
	[textView resignFirstResponder];
	[textView becomeFirstResponder];

}

// UIActionSheetDelegate

- (void) actionSheet: (UIActionSheet *) actionSheet didDismissWithButtonIndex: (int) index {

	if (actionSheet == imageOps) {

		if (index == 0) {

			[self fit];

		} else if (index == 1) {

			[self editImageMetadata];
			
		} else if (index == 2) {
		
			[effects showInView: self.view];
			
		} else if (index == 3) {
		
			MFImageSavingController *imgSaver = [[MFImageSavingController alloc] initWithImage: imageView.image directory: self.file.path defaultFileName: self.file.name];
			[imgSaver presentFrom: self];
			[imgSaver release];
			[self setFilesystemModified];

		} else {

			return;

		}

	} else if (actionSheet == effects) {
	
		if (index == 0) {
		
			// Scale
			imageTransform = MFImageTransformScale;
			MFTextAlert *alrt = [[MFTextAlert alloc] initWithTitle: @"Scale"];
			alrt.delegate = self;
			alrt.textField.placeholder = MFLocalizedString(@"Specify percents");
			[alrt addButtonWithTitle: MFLocalizedString(@"OK")];
			[alrt addButtonWithTitle: MFLocalizedString(@"Cancel")];
			[alrt show];
			[alrt release];
					 
		} else if (index == 1) {
		
			// Crop
			imageTransform = MFImageTransformCrop;
			MFTextAlert *alrt = [[MFTextAlert alloc] initWithTitle: @"Crop"];
			alrt.delegate = self;
			alrt.textField.placeholder = MFLocalizedString(@"X, Y, Width, Height");
			[alrt addButtonWithTitle: MFLocalizedString(@"OK")];
			[alrt addButtonWithTitle: MFLocalizedString(@"Cancel")];
			[alrt show];
			[alrt release];
			
		} else if (index == 2) {
		
			// Rotate
			imageTransform = MFImageTransformRotate;
			MFTextAlert *alrt = [[MFTextAlert alloc] initWithTitle: @"Rotate"];
			alrt.delegate = self;
			alrt.textField.placeholder = MFLocalizedString(@"Specify degrees");
			[alrt addButtonWithTitle: MFLocalizedString(@"OK")];
			[alrt addButtonWithTitle: MFLocalizedString(@"Cancel")];
			[alrt show];
			[alrt release];
			
		} else if (index == 3) {
		
			// Rounded corners
			imageTransform = MFImageTransformRoundedCorners;
			MFTextAlert *alrt = [[MFTextAlert alloc] initWithTitle: @"Rounded corners"];
			alrt.delegate = self;
			alrt.textField.placeholder = MFLocalizedString(@"Radius in pixels");
			[alrt addButtonWithTitle: MFLocalizedString(@"OK")];
			[alrt addButtonWithTitle: MFLocalizedString(@"Cancel")];
			[alrt show];
			[alrt release];
			
		} else if (index == 4) {
		
			// Set transparency
			imageTransform = MFImageTransformSetTransparency;
			MFTextAlert *alrt = [[MFTextAlert alloc] initWithTitle: @"Set transparency"];
			alrt.delegate = self;
			alrt.textField.placeholder = MFLocalizedString(@"Specify percents");
			[alrt addButtonWithTitle: MFLocalizedString(@"OK")];
			[alrt addButtonWithTitle: MFLocalizedString(@"Cancel")];
			[alrt show];
			[alrt release];
			
		} else if (index == 5) {
		
			// Grayscale
			imageView.image = [imageView.image grayscaled];
			
		} else if (index == 6) {
		
			// Add labels
			imageTransform = MFImageTransformAddLabels;
			MFImageAddLabelsController *ctl = [[MFImageAddLabelsController alloc] init];
			ctl.delegate = self;
			[ctl presentFrom: self];
			[ctl release];
			
		} else {
		
			return;
			
		}
		
	}

}

// UIAlertViewDelegate

- (void) alertView: (UIAlertView *) alertView didDismissWithButtonIndex: (int) index {

	MFTextAlert *alrt = (MFTextAlert *)alertView;
	
	if (index == 0) {
	
		// OK
		if (imageTransform == MFImageTransformScale) {
		
			float ratio = [alrt.textField.text floatValue] / 100.0;
			imageView.image = [imageView.image resizedByRatio: ratio];

		} else if (imageTransform == MFImageTransformCrop) {
		
			NSArray *cmps = [[alrt.textField.text stringByReplacingOccurrencesOfString: @" " withString: @""] componentsSeparatedByString: @","];
			if ([cmps count] != 4) {
				// Error
				UIAlertView *av = [[UIAlertView alloc] init];
				av.title = MFLocalizedString(@"Error");
				av.message = MFLocalizedString(@"You have entered an invalid string.");
				[av addButtonWithTitle: MFLocalizedString(@"Dismiss")];
				[av show];
				[av release];
			} else {
				// Correct
				int x = [[cmps objectAtIndex: 0] intValue];
				int y = [[cmps objectAtIndex: 1] intValue];
				int w = [[cmps objectAtIndex: 2] intValue];
				int h = [[cmps objectAtIndex: 3] intValue];
				CGRect rect = CGRectMake (x, y, w, h);
				imageView.image = [imageView.image croppedToRect: rect];
			}
			
		} else if (imageTransform == MFImageTransformRotate) {
		
			float degrees = [alrt.textField.text floatValue];
			imageView.image = [imageView.image rotatedByDegrees: degrees];
			
		} else if (imageTransform == MFImageTransformRoundedCorners) {
		
			float borderRad = [alrt.textField.text floatValue];
			imageView.image = [imageView.image withBorderRadius: borderRad];
			
		} else if (imageTransform == MFImageTransformSetTransparency) {
		
			float alpha = [alrt.textField.text floatValue] / 100.0;
			imageView.image = [imageView.image withAlpha: alpha];
			
		}
		
		imageView.frame = CGRectMake (0, 0, imageView.image.size.width, imageView.image.size.height);
		
	} else {
	
		// Cancel
		// Do nothing
		
	}
	
	imageTransform = MFImageTransformNone;
	
}

// UIScrollViewDelegate

- (UIView *) viewForZoomingInScrollView: (UIScrollView *) theScrollView {

	return imageView;
	
}

// UITextViewDelegate

- (void) textViewDidBeginEditing: (UITextView *) theTextView {

	[UIView beginAnimations: nil context: NULL];
	[UIView setAnimationDuration: 0.3];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
	theTextView.frame = (UIInterfaceOrientationIsLandscape (self.interfaceOrientation) ? CGRectMake (0, 0, 480, 106) : CGRectMake (0, 0, 320, 200));
	[UIView commitAnimations];
	self.navigationItem.rightBarButtonItem.enabled = YES;

}

@end


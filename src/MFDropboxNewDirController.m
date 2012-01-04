//
// MFDropboxNewDirController.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFDropboxNewDirController.h"

@implementation MFDropboxNewDirController

@synthesize mainController = mainController;

// self

- (id) initWithPath: (NSString *) aPath {

	self = [super init];
	
	self.title = MFLocalizedString(@"New folder");
        path = [aPath copy];

	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(done)];
	self.navigationItem.rightBarButtonItem = rightButton;
	[rightButton release];

        mgr = [[MFFileManager alloc] init];
        mgr.delegate = self;

	tableView = [[UITableView alloc] initWithFrame: CGRectMake (0, 0, 320, 460) style: UITableViewStyleGrouped];
	tableView.dataSource = self;
	tableView.delegate = self;
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview: tableView];
	[tableView release];
       
	fileName = [[UITextField alloc] initWithFrame: CGRectMake (0, 10, NEW_LABEL_WIDTH, 30)];
	fileName.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	fileName.placeholder = MFLocalizedString(@"Folder name");
	fileName.delegate = self;
	fileName.autocapitalizationType = UITextAutocapitalizationTypeNone;
	fileName.autocorrectionType = UITextAutocorrectionTypeNo;

	return self;

}

// super

- (void) dealloc {

	[fileName release];
	fileName = nil;
        [path release];
        path = nil;
        [mgr release];
        mgr = nil;
	
	[super dealloc];
	
}

// self

- (void) done {

        loadingView = [[MFLoadingView alloc] initWithType: MFLoadingViewTypeTemporary];
        [loadingView show];
	[mgr dbCreateDirectory: [path stringByAppendingPathComponent: fileName.text]];

}

// UITableViewDataSource

- (int) tableView: (UITableView *) theTableView numberOfRowsInSection: (int) section {

	return 2;

}

- (UITableViewCell *) tableView: (UITableView *) theTableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier: @"MFDbNdCell"];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"MFDbNdCell"] autorelease];
	}

	if (indexPath.row == 0) {

		cell.textLabel.text = MFLocalizedString(@"Name");
		cell.accessoryView = fileName;

	} else if (indexPath.row == 1) {

		cell.textLabel.text = MFLocalizedString(@"Create");
		cell.accessoryView = nil;
 
	}

	return cell;

}

// UITableViewDelegate

- (void) tableView: (UITableView *) theTableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

	[theTableView deselectRowAtIndexPath: indexPath animated: YES];

	if (indexPath.row == 1) {

		[self done];

	}

}

// UITextFieldDelegate

- (BOOL) textFieldShouldReturn: (UITextField *) theTextField {

	[theTextField resignFirstResponder];

	return YES;

}

// MFFileManagerDelegate

- (void) fileManagerDBCreatedDirectory: (NSString *) thePath {

        [loadingView hide];
        [self.mainController loadMetadata: [[path copy] autorelease]];
        [self close];

}

- (void) fileManagerDBCreateDirectoryFailed {

        [loadingView hide];
        [[[[UIAlertView alloc] initWithTitle: MFLocalizedString(@"Error creating folder") message: MFLocalizedString(@"Please make sure that you are connected to the Internet, logged in and the folder to be created doesn't yet exist and try again.") delegate: nil cancelButtonTitle: MFLocalizedString(@"Dismiss") otherButtonTitles: nil] autorelease] show];

}

@end


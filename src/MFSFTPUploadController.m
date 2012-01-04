//
// MMFSFTPUploadController.m
// MyFile
//
// Created by Árpád Goretit, 2011.
//

#import "MFSFTPUploadController.h"
#import "MFSFTPController.h"

@implementation MFSFTPUploadController

@synthesize mainController = mainController;

// super

- (id) init {

	self = [super init];
	
	self.title = MFLocalizedString(@"Upload file");
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(done)] autorelease];
	
	tableView = [[UITableView alloc] initWithFrame: CGRectMake (0, 0, 320, 460) style: UITableViewStyleGrouped];
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview: tableView];
	
	remoteFile = [[UITextField alloc] initWithFrame: CGRectMake (0, 0, 160, 30)];
	remoteFile.delegate = self;
	remoteFile.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	remoteFile.autocorrectionType = UITextAutocorrectionTypeNo;
	remoteFile.autocapitalizationType = UITextAutocapitalizationTypeNone;
	
	localFile = [[UITextField alloc] initWithFrame: CGRectMake (0, 0, 160, 30)];
	localFile.delegate = self;
	localFile.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	localFile.autocorrectionType = UITextAutocorrectionTypeNo;
	localFile.autocapitalizationType = UITextAutocapitalizationTypeNone;
	
	return self;
	
}

- (void) dealloc {

	[tableView release];
	tableView = nil;
	[localFile release];
	localFile = nil;
	[remoteFile release];
	remoteFile = nil;
	
	[super dealloc];
	
}

// UITableViewDelegate

- (void) tableView: (UITableView *) theTableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

	if (indexPath.row == 2) {
	
		[self done];
		
	}
	
}

// UITableViewDataSource

- (int) tableView: (UITableView *) theTableView numberOfRowsInSection: (int) section {

	return 3;
	
}

- (UITableViewCell *) tableView: (UITableView *) theTableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier: @"SFTPUploadCell"];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"SFTPUploadCell"] autorelease];
	}
	
	if (indexPath.row == 0) {
		
		cell.textLabel.text = MFLocalizedString(@"Local file:");
		cell.accessoryView = localFile;
		
	} else if (indexPath.row == 1) {
	
		cell.textLabel.text = MFLocalizedString(@"Remote file:");
		cell.accessoryView = remoteFile;
		
	} else if (indexPath.row == 2) {
	
		cell.textLabel.text = MFLocalizedString(@"Upload file");
		
	}
	
	return cell;
	
}

// UITextFieldDelegate

- (BOOL) textFieldShouldReturn: (UITextField *) textField {

	[textField resignFirstResponder];
	
	return YES;
	
}

// self

- (void) done {

	[self.mainController uploadFile: localFile.text toPath: remoteFile.text];
	[self close];
	
}

@end

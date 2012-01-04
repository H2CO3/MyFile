//
// MFNewFileController.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFNewFileController.h"
#import "MFMainController.h"

@implementation MFNewFileController

@synthesize mainController = mainController;
@synthesize path = path;

// self

- (id) init {

	self = [super init];
	
	self.title = MFLocalizedString(@"New file");

	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(done)];
	self.navigationItem.rightBarButtonItem = rightButton;
	[rightButton release];

	tableView = [[UITableView alloc] initWithFrame: CGRectMake (0, 0, 320, 460) style: UITableViewStyleGrouped];
	tableView.dataSource = self;
	tableView.delegate = self;
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview: tableView];
	[tableView release];
       
	isDir = [[UISwitch alloc] initWithFrame: CGRectMake (0, 8, 100, 30)];
	isDir.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	isDir.on = NO;

	fileName = [[UITextField alloc] initWithFrame: CGRectMake (0, 10, NEW_LABEL_WIDTH, 30)];
	fileName.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	fileName.placeholder = MFLocalizedString(@"File name");
	fileName.delegate = self;
	fileName.autocapitalizationType = UITextAutocapitalizationTypeNone;
	fileName.autocorrectionType = UITextAutocorrectionTypeNo;

	permissions = [[UITextField alloc] initWithFrame: CGRectMake (0, 10, NEW_LABEL_WIDTH, 30)];
	permissions.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	permissions.placeholder = MFLocalizedString(@"Octal 4-digit");
	permissions.delegate = self;
	permissions.autocapitalizationType = UITextAutocapitalizationTypeNone;
	permissions.autocorrectionType = UITextAutocorrectionTypeNo;
       
	user = [[UITextField alloc] initWithFrame: CGRectMake (0, 10, NEW_LABEL_WIDTH, 30)];
	user.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	user.placeholder = MFLocalizedString(@"Owner's name");
	user.delegate = self;
	user.autocapitalizationType = UITextAutocapitalizationTypeNone;
	user.autocorrectionType = UITextAutocorrectionTypeNo;

	group = [[UITextField alloc] initWithFrame: CGRectMake (0, 10, NEW_LABEL_WIDTH, 30)];
	group.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	group.placeholder = MFLocalizedString(@"Group");
	group.delegate = self;
	group.autocapitalizationType = UITextAutocapitalizationTypeNone;
	group.autocorrectionType = UITextAutocorrectionTypeNo;

	return self;

}

- (void) dealloc {

	[fileName release];
	fileName = nil;
	[isDir release];
	isDir = nil;
	[permissions release];
	permissions = nil;
	[user release];
	user = nil;
	[group release];
	group = nil;
	
	[super dealloc];
	
}

// self

- (void) done {

	[[[self mainController] fileManager] createFile: [self.path stringByAppendingPathComponent: fileName.text] isDirectory: isDir.on];
	[[[self mainController] fileManager] chmodFile: [self.path stringByAppendingPathComponent: fileName.text] permissions: permissions.text];
	[[[self mainController] fileManager] chownFile: [self.path stringByAppendingPathComponent: fileName.text] user: user.text group: group.text];
	isDir.on = NO;
	fileName.text = nil;
	permissions.text = nil;
	user.text = nil;
	group.text = nil;
	[[self mainController] reloadDirectory];
	[self close];

}

// UITableViewDataSource

- (int) tableView: (UITableView *) theTableView numberOfRowsInSection: (int) section {

	return 6;

}

- (UITableViewCell *) tableView: (UITableView *) theTableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier: @"MFNFCell"];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle: 0 reuseIdentifier: @"MFNFCell"] autorelease];
	}

	if (indexPath.row == 0) {

		cell.textLabel.text = MFLocalizedString(@"Filename");
		cell.accessoryView = fileName;

	} else if (indexPath.row == 1) {

		cell.textLabel.text = MFLocalizedString(@"Directory?");
		cell.accessoryView = isDir;
 
	} else if (indexPath.row == 2) {

		cell.textLabel.text = MFLocalizedString(@"Permissions");
		cell.accessoryView = permissions;

	} else if (indexPath.row == 3) {
	
		cell.textLabel.text = MFLocalizedString(@"Owner");
		cell.accessoryView = user;
		
	} else if (indexPath.row == 4) {
	
		cell.textLabel.text = MFLocalizedString(@"Group");
		cell.accessoryView = group;
		
	} else if (indexPath.row == 5) {
	
		cell.textLabel.text = MFLocalizedString(@"Create file");
		cell.accessoryView = nil;
		
	}

	return cell;

}

// UITableViewDelegate

- (void) tableView: (UITableView *) theTableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

	[theTableView deselectRowAtIndexPath: indexPath animated: YES];

	if (indexPath.row == 5) {

		[self done];

	}

}

// UITextFieldDelegate

- (BOOL) textFieldShouldReturn: (UITextField *) theTextField {

	[theTextField resignFirstResponder];

	return YES;

}

@end

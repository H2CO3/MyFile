//
// MFSFTPHostController.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFSFTPHostController.h"

@implementation MFSFTPHostController

@synthesize delegate = delegate;

// super

- (id) init {

	self = [super init];

	self.title = MFLocalizedString(@"Log in");
	
	tableView = [[UITableView alloc] initWithFrame: (UIInterfaceOrientationIsPortrait (self.interfaceOrientation) ? CGRectMake (0, 0, 320, 460) : [[UIScreen mainScreen] applicationFrame]) style: UITableViewStyleGrouped];
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	tableView.dataSource = self;
	tableView.delegate = self;
	tableView.allowsSelection = NO;
	[self.view addSubview: tableView];
	[tableView release];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(done)] autorelease];
	
	hostName = [[UITextField alloc] initWithFrame: CGRectMake (0, 0, 180, 30)];
	hostName.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	hostName.autocapitalizationType = UITextAutocapitalizationTypeNone;
	hostName.autocorrectionType = UITextAutocorrectionTypeNo;
	hostName.delegate = self;
	login = [[UITextField alloc] initWithFrame: CGRectMake (0, 0, 180, 30)];
	login.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	login.autocapitalizationType = UITextAutocapitalizationTypeNone;
	login.autocorrectionType = UITextAutocorrectionTypeNo;
	login.delegate = self;
	password = [[UITextField alloc] initWithFrame: CGRectMake (0, 0, 180, 30)];
	password.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	password.autocapitalizationType = UITextAutocapitalizationTypeNone;
	password.autocorrectionType = UITextAutocorrectionTypeNo;
	password.delegate = self;
	password.secureTextEntry = YES;
	
	return self;
	
}

- (void) dealloc {

	[hostName release];
	hostName = nil;
	[login release];
	login = nil;
	[password release];
	password = nil;
	
	[super dealloc];
	
}

// self

- (void) done {

	NSDictionary *hostInfo = [NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat: @"%@@%@", login.text, hostName.text], @"HostURL", password.text, @"Password", nil];
	[self.delegate hostController: self didReceiveHostInfo: hostInfo];
	[self close];
	
}

// UITableViewDataSource

- (int) tableView: (UITableView *) theTableView numberOfRowsInSection: (int) section {

	return 3;
	
}

- (UITableViewCell *) tableView: (UITableView *) theTableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier: @"MFHostCell"];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"MFHostCell"] autorelease];
	}
	
	if (indexPath.row == 0) {
	
		cell.textLabel.text = MFLocalizedString(@"Host:");
		cell.accessoryView = hostName;
		
	} else if (indexPath.row == 1) {
	
		cell.textLabel.text = MFLocalizedString(@"Username:");
		cell.accessoryView = login;
		
	} else {
	
		cell.textLabel.text = MFLocalizedString(@"Password:");
		cell.accessoryView = password;
		
	}
	
	return cell;
	
}

// UITextFieldDelegate

- (BOOL) textFieldShouldReturn: (UITextField *) theTextField {

	[theTextField resignFirstResponder];
	
	return YES;
	
}

@end

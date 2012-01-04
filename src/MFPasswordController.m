//
// MFPasswordController.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFPasswordController.h"

@implementation MFPasswordController

@synthesize delegate = delegate;

// super

- (id) init {

	self = [super init];
	
	self.title = MFLocalizedString(@"Enter password");
	self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(done)];
	self.navigationItem.rightBarButtonItem = rightButton;
	[rightButton release];
	
	tableView = [[UITableView alloc] initWithFrame: CGRectMake (0, 0, 320, 460) style: UITableViewStyleGrouped];
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	tableView.dataSource = self;
	tableView.scrollEnabled = NO;
	
	textField = [[UITextField alloc] initWithFrame: CGRectMake (140, 10, 140, 30)];
	textField.delegate = self;
	textField.secureTextEntry = YES;
	textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[textField becomeFirstResponder];
	
	[self.view addSubview: tableView];
	[tableView release];

	numOfTries = 0;

	return self;
	
}

// UITableViewDataSource

- (int) tableView: (UITableView *) theTableView numberOfRowsInSection: (int) section {

	return 1;
	
}

- (UITableViewCell *) tableView: (UITableView *) theTableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"MFPCCell"] autorelease];
	cell.text = MFLocalizedString(@"Password:");
	[cell.contentView addSubview: textField];
	
	return cell;
	
}

// UITextFieldDelegate

- (BOOL) textFieldShouldReturn: (UITextField *) theTextField {

	[theTextField resignFirstResponder];
	[self done];
	
	return YES;
	
}

// self

- (void) done {
	
	if ([textField.text isEqualToString: [[NSUserDefaults standardUserDefaults] objectForKey: @"MFPasswordString"]]) {
	
		numOfTries = 0;
                if ([delegate respondsToSelector: @selector(passwordControllerAcceptedPassword)]) {
		        [self.delegate passwordControllerAcceptedPassword];
                }
	
        } else {

		numOfTries += 1;

		if (numOfTries == 3) {
			exit (0);
		}

		[[[[UIAlertView alloc] initWithTitle: MFLocalizedString(@"Wrong password") message: [NSString stringWithFormat: MFLocalizedString(@"You have entered an incorrect password. Remaining tries before exit: %i."), 3 - numOfTries] delegate: nil cancelButtonTitle: MFLocalizedString(@"Dismiss") otherButtonTitles: nil] autorelease] show];
		
	}
	
}

@end

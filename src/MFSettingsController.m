//
// MFSettingsController.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFSettingsController.h"

@implementation MFSettingsController

// super

- (id) init {

	self = [super init];

	self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	self.title = MFLocalizedString(@"Settings");

	UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(done)];
	self.navigationItem.rightBarButtonItem = rightButtonItem;
	[rightButtonItem release];

	tableView = [[UITableView alloc] initWithFrame: CGRectMake (0, 0, 320, 460) style: UITableViewStyleGrouped];
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	tableView.delegate = self;
	tableView.dataSource = self;
	[self.view addSubview: tableView];
	
	passwordEnabled = [[UISwitch alloc] initWithFrame: CGRectMake (217, 8, 80, 30)];
	passwordEnabled.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	passwordEnabled.on = [[NSUserDefaults standardUserDefaults] boolForKey: @"MFPasswordEnabled"];
	
	passwordString = [[UITextField alloc] initWithFrame: CGRectMake (140, 10, 140, 30)];
	passwordString.secureTextEntry = YES;
	passwordString.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	passwordString.placeholder = MFLocalizedString(@"Type new password here");
	passwordString.text = [[NSUserDefaults standardUserDefaults] stringForKey: @"MFPasswordString"];
	passwordString.delegate = self;
	
	fontSize = [[UITextField alloc] initWithFrame: CGRectMake (140, 10, 140, 30)];
	fontSize.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	fontSize.placeholder = MFLocalizedString(@"Font size of text editor");
	fontSize.text = [NSString stringWithFormat: @"%2.1f", [[NSUserDefaults standardUserDefaults] floatForKey: @"MFFontSize"] != 0.0 ? [[NSUserDefaults standardUserDefaults] floatForKey: @"MFFontSize"] : 12.0];
	fontSize.delegate = self;
	
	uploadPath = [[UITextField alloc] initWithFrame: CGRectMake (0, 0, 140, 30)];
	uploadPath.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	uploadPath.placeholder = MFLocalizedString(@"Dropbox upload path");
	NSString *uploadPathText = [[NSUserDefaults standardUserDefaults] stringForKey: @"MFDropboxUploadPath"];
	if ((uploadPathText == nil) || ([uploadPathText length] == 0)) { uploadPathText = @"/Public"; }
	uploadPath.text = uploadPathText;
	uploadPath.delegate = self;
	
	homeDir = [[UITextField alloc] initWithFrame: CGRectMake (0, 0, 140, 30)];
	homeDir.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	homeDir.placeholder = MFLocalizedString(@"Home directory");
	NSString *homeDirText = [[NSUserDefaults standardUserDefaults] stringForKey: @"MFHomeDirectory"];
	if ((homeDirText == nil) || ([homeDirText length] == 0)) { homeDirText = @"/var/mobile"; }
	homeDir.text = homeDirText;
	homeDir.delegate = self;

	dropboxdLocal = [[UITextField alloc] initWithFrame: CGRectMake (0, 0, 140, 30)];
	dropboxdLocal.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	dropboxdLocal.placeholder = MFLocalizedString(@"Local Dropbox sync folder");
	NSString *dbdLocalText = [[NSUserDefaults standardUserDefaults] stringForKey: @"MFDropboxDaemonPathLocal"];
	if ((dbdLocalText == nil) || ([dbdLocalText length] == 0)) { dbdLocalText = @"/var/mobile/Dropbox"; }
	dropboxdLocal.text = dbdLocalText;
	dropboxdLocal.delegate = self;

	dropboxdRemote = [[UITextField alloc] initWithFrame: CGRectMake (0, 0, 140, 30)];
	dropboxdRemote.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	dropboxdRemote.placeholder = MFLocalizedString(@"Remote Dropbox sync folder");
	NSString *dbdRemoteText = [[NSUserDefaults standardUserDefaults] stringForKey: @"MFDropboxDaemonPathRemote"];
	if ((dbdRemoteText == nil) || ([dbdRemoteText length] == 0)) { dbdRemoteText = @"/MyFile"; }
	dropboxdRemote.text = dbdRemoteText;;
	dropboxdRemote.delegate = self;

	useTrash = [[UISwitch alloc] initWithFrame: CGRectMake (0, 0, 80, 30)];
	useTrash.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	useTrash.on = [[NSUserDefaults standardUserDefaults] boolForKey: @"MFUseTrash"];
	
	uploadSpecific = [[UISwitch alloc] initWithFrame: CGRectMake (0, 0, 80, 30)];
	uploadSpecific.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	uploadSpecific.on = [[NSUserDefaults standardUserDefaults] boolForKey: @"MFDropboxUploadSpecific"];
	
	alwaysHome = [[UISwitch alloc] initWithFrame: CGRectMake (0, 0, 80, 30)];
	alwaysHome.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	alwaysHome.on = [[NSUserDefaults standardUserDefaults] boolForKey: @"MFAlwaysGoHome"];

	dropboxDaemon = [[UISwitch alloc] initWithFrame: CGRectMake (0, 0, 80, 30)];
        dropboxDaemon.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        dropboxDaemon.on = [[NSUserDefaults standardUserDefaults] boolForKey: @"MFDropboxDaemon"];

	convertSpaces = [[UISwitch alloc] initWithFrame: CGRectMake (0, 0, 80, 30)];
        convertSpaces.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        convertSpaces.on = [[NSUserDefaults standardUserDefaults] boolForKey: @"MFConvertSpaces"];
	
	aboutController = [[MFAboutController alloc] init];
        helpController = [[MFHelpController alloc] init];
	
	return self;

}

- (void) dealloc {

	[tableView release];
	tableView = nil;
	[aboutController release];
	aboutController = nil;
        [helpController release];
        helpController = nil;
	[passwordEnabled release];
	passwordEnabled = nil;
	[passwordString release];
	passwordString = nil;
	[fontSize release];
	fontSize = nil;
	[uploadPath release];
	uploadPath = nil;
	[homeDir release];
	homeDir = nil;
	[useTrash release];
	useTrash = nil;
	[uploadSpecific release];
	uploadSpecific = nil;
	[alwaysHome release];
	alwaysHome = nil;
        [convertSpaces release];
        convertSpaces = nil;
        [dropboxdLocal release];
        dropboxdLocal = nil;
        [dropboxdRemote release];
        dropboxdRemote = nil;
	
	[super dealloc];

}

// self

- (void) done {

	if ((uploadPath.text == nil) || ([uploadPath.text length] == 0)) {
		uploadPath.text = @"/Public";
	}

	if ((homeDir.text == nil) || ([homeDir.text length] == 0)) {
		homeDir.text = @"/var/mobile";
	}

        if ((dropboxdLocal.text == nil) || ([dropboxdLocal.text length] == 0)) {
                dropboxdLocal.text = @"/var/mobile/Dropbox";
        }

        if ((dropboxdRemote.text == nil) || ([dropboxdRemote.text length] == 0)) {
                dropboxdRemote.text = @"/MyFile";
        }

	[[NSUserDefaults standardUserDefaults] setBool: passwordEnabled.on forKey: @"MFPasswordEnabled"];
	[[NSUserDefaults standardUserDefaults] setObject: passwordString.text forKey: @"MFPasswordString"];
	[[NSUserDefaults standardUserDefaults] setFloat: [fontSize.text floatValue] forKey: @"MFFontSize"];
	[[NSUserDefaults standardUserDefaults] setObject: uploadPath.text forKey: @"MFDropboxUploadPath"];
	[[NSUserDefaults standardUserDefaults] setObject: homeDir.text forKey: @"MFHomeDirectory"];
	[[NSUserDefaults standardUserDefaults] setBool: useTrash.on forKey: @"MFUseTrash"];
	[[NSUserDefaults standardUserDefaults] setBool: uploadSpecific.on forKey: @"MFDropboxUploadSpecific"];
	[[NSUserDefaults standardUserDefaults] setBool: alwaysHome.on forKey: @"MFAlwaysGoHome"];
        [[NSUserDefaults standardUserDefaults] setBool: dropboxDaemon.on forKey: @"MFDropboxDaemon"];
        system ("kill `cat /var/root/myfile/dropboxd.pid`");
        if (dropboxDaemon.on) {
                system ("/usr/libexec/dropboxd");
        }
        [[NSUserDefaults standardUserDefaults] setObject: dropboxdLocal.text forKey: @"MFDropboxDaemonPathLocal"];
        [[NSUserDefaults standardUserDefaults] setObject: dropboxdRemote.text forKey: @"MFDropboxDaemonPathRemote"];
        [[NSUserDefaults standardUserDefaults] setBool: convertSpaces.on forKey: @"MFConvertSpaces"];
	[[NSUserDefaults standardUserDefaults] synchronize];

	[self close];

}

// UITableViewDataSource

- (int) numberOfSectionsInTableView: (UITableView *) theTableView {

	return 3;
	
}

- (int) tableView: (UITableView *) theTableView numberOfRowsInSection: (int) section {

	int nRows;
	if (section == 0) {
		nRows = 7;
	} else if (section == 1) {
		nRows = 8;
	} else if (section == 2) {
		nRows = 2;
	}

	return nRows;

}

- (NSString *) tableView: (UITableView *) theTableView titleForHeaderInSection: (int) section {

	NSString *title;

	if (section == 0) {
		title = MFLocalizedString(@"Local");
	} else if (section == 1) {
		title = MFLocalizedString(@"Social");
	} else if (section == 2) {
		title = MFLocalizedString(@"App info");
	}
	
	return title;
	
}

- (UITableViewCell *) tableView: (UITableView *) theTableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"MFSCCell"];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"MFSCCell"] autorelease];
	}
	
	if (indexPath.section == 0) {
	
		if (indexPath.row == 0) {
		
			cell.textLabel.text = MFLocalizedString(@"Enable password");
			cell.accessoryView = passwordEnabled;
			
		} else if (indexPath.row == 1) {
		
			cell.textLabel.text = MFLocalizedString(@"Password");
			cell.accessoryView = passwordString;
			
		} else if (indexPath.row == 2) {
		
			cell.textLabel.text = MFLocalizedString(@"Text font size");
			cell.accessoryView = fontSize;
			
		} else if (indexPath.row == 3) {
		
			cell.textLabel.text = MFLocalizedString(@"Home directory");
			cell.accessoryView = homeDir;
			
		} else if (indexPath.row == 4) {
		
			cell.textLabel.text = MFLocalizedString(@"Load home on startup");
			cell.accessoryView = alwaysHome;
			
		} else if (indexPath.row == 5) {
		
			cell.textLabel.text = MFLocalizedString(@"Use trash");
			cell.accessoryView = useTrash;
			
		} else if (indexPath.row == 6) {

                        cell.textLabel.text = MFLocalizedString(@"Convert 8 spaces to TAB");
                        cell.accessoryView = convertSpaces;

                }
		
	} else if (indexPath.section == 1) {
	
		if (indexPath.row == 0) {
	
			cell.textLabel.text = [[DBSession sharedSession] isLinked] ? MFLocalizedString(@"Unlink iPhone from Dropbox") : MFLocalizedString(@"Log in to Dropbox");
			cell.accessoryView = nil;
			
		} else if (indexPath.row == 1) {
		
			cell.textLabel.text = MFLocalizedString(@"Upload path");
			cell.accessoryView = uploadPath;
			
		} else if (indexPath.row == 2) {
		
			cell.textLabel.text = MFLocalizedString(@"Upload specificly");
			cell.accessoryView = uploadSpecific;
			
		} else if (indexPath.row == 3) {
		
			cell.textLabel.text = [[MFSocialManager sharedManager] isServiceLoggedIn: MFSocialServiceFacebook] ? MFLocalizedString(@"Logout from Facebook") : MFLocalizedString(@"Login to Facebook");
			cell.accessoryView = nil;
			
		} else if (indexPath.row == 4) {
		
			cell.textLabel.text = [[MFSocialManager sharedManager] isServiceLoggedIn: MFSocialServiceTwitter] ? MFLocalizedString(@"Logout from Twitter") : MFLocalizedString(@"Login to Twitter");
			cell.accessoryView = nil;

		} else if (indexPath.row == 5) {

                        cell.textLabel.text = MFLocalizedString(@"Dropbox sync");
                        cell.accessoryView = dropboxDaemon;

                } else if (indexPath.row == 6) {

                        cell.textLabel.text = MFLocalizedString(@"Local sync folder");
                        cell.accessoryView = dropboxdLocal;

                } else if (indexPath.row == 7) {

                        cell.textLabel.text = MFLocalizedString(@"Remote sync folder");
                        cell.accessoryView = dropboxdRemote;

                }
		
	} else if (indexPath.section == 2) {
	
		if (indexPath.row == 0) {
		
			cell.textLabel.text = MFLocalizedString(@"About MyFile");
			cell.accessoryView = nil;
			
		} else if (indexPath.row == 1) {

                        cell.textLabel.text = MFLocalizedString(@"Help");
                        cell.accessoryView = nil;

                }
		
	}

	return cell;

}

// UITableViewDelegate

- (void) tableView: (UITableView *) theTableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

	[theTableView deselectRowAtIndexPath: indexPath animated: YES];

	if (indexPath.section == 0) {
	
		
		
	} else if (indexPath.section == 1) {
	
		if (indexPath.row == 0) {

			if ([[DBSession sharedSession] isLinked]) {

				[[DBSession sharedSession] unlink];

			} else {

				DBLoginController *lc = [[DBLoginController alloc] init];
				lc.delegate = self;
				[lc presentFromController: self];
				[lc release];

			}
			
			[theTableView reloadData];

			[self close];
			
		} else if (indexPath.row == 3) {

			if ([[MFSocialManager sharedManager] isServiceLoggedIn: MFSocialServiceFacebook]) {
				[[MFSocialManager sharedManager] logoutFromService: MFSocialServiceFacebook];
			} else {
				[[MFSocialManager sharedManager] loginToService: MFSocialServiceFacebook];
			}
			
			[theTableView reloadData];
		
		} else if (indexPath.row == 4) {

			if ([[MFSocialManager sharedManager] isServiceLoggedIn: MFSocialServiceTwitter]) {
				[[MFSocialManager sharedManager] logoutFromService: MFSocialServiceTwitter];
			} else {
				UIViewController *ctrl = [[MFSocialManager sharedManager] loginToService: MFSocialServiceTwitter];
				if (ctrl != nil) {
					[self presentModalViewController: ctrl animated: YES];
				}
			}
			
			[theTableView reloadData];

		}

	} else if (indexPath.section == 2) {
	
		if (indexPath.row == 0) {
		
			[aboutController presentFrom: self];
			
		} else if (indexPath.row == 1) {

                        [helpController presentFrom: self];

                }
		
	}

}

// UITextFieldDelegate

- (BOOL) textFieldShouldReturn: (UITextField *) theTextField {

	[theTextField resignFirstResponder];
	
	return YES;
	
}

// DBLoginControllerDelegate

- (void) loginControllerDidLogin: (DBLoginController *) controller {

	[tableView reloadData];

}

- (void) loginControllerDidCancel: (DBLoginController *) controller {

}

@end

//
// MFFileSharingController.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFFileSharingController.h"
#undef MFLocalizedString
#define MFLocalizedString(x) (NSLocalizedString((x), @""))


@implementation MFFileSharingController

// super

- (id) init {

	self = [super init];
	
	state = NO;
	self.title = MFLocalizedString(@"File sharing");
	self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	
	port = [[UITextField alloc] initWithFrame: CGRectMake (170, 50, 120, 30)];
	port.enabled = YES;
	port.delegate = self;
	port.borderStyle = UITextBorderStyleRoundedRect;
	port.clearButtonMode = UITextFieldViewModeWhileEditing;
	port.text = @"8080";
	port.backgroundColor = [UIColor clearColor];
	port.placeholder = MFLocalizedString(@"Type port number here");
	[self.view addSubview: port];
	
	portLabel = [[UILabel alloc] initWithFrame: CGRectMake (40, 50, 120, 30)];
	portLabel.text = MFLocalizedString(@"Server port:");
	portLabel.backgroundColor = [UIColor clearColor];
	portLabel.font = [UIFont boldSystemFontOfSize: [UIFont labelFontSize]];
	[self.view addSubview: portLabel];
	
	stateLabel = [[UILabel alloc] initWithFrame: CGRectMake (40, 160, 240, 30)];
	stateLabel.text = MFLocalizedString(@"Server is off");
	stateLabel.backgroundColor = [UIColor clearColor];
	stateLabel.font = [UIFont boldSystemFontOfSize: [UIFont labelFontSize]];
	[self.view addSubview: stateLabel];
	
	IPLabel = [[UILabel alloc] initWithFrame: CGRectMake (40, 240, 240, 30)];
	IPLabel.text = nil;
	IPLabel.backgroundColor = [UIColor clearColor];
	IPLabel.font = [UIFont boldSystemFontOfSize: [UIFont labelFontSize]];
	[self.view addSubview: IPLabel];
	
	toggleStateButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
	toggleStateButton.frame = CGRectMake (40, 320, 240, 48);
	[toggleStateButton addTarget: self action: @selector(toggleState) forControlEvents: UIControlEventTouchUpInside];
	[toggleStateButton setTitle: MFLocalizedString(@"Start server") forState: UIControlStateNormal];
	[self.view addSubview: toggleStateButton];
	
	return self;
	
}

- (void) dealloc {

	[stateLabel release];
	stateLabel = nil;
	[portLabel release];
	portLabel = nil;
	[port release];
	port = nil;
	[IPLabel release];
	IPLabel = nil;
	[toggleStateButton release];
	toggleStateButton = nil;
	
	[super dealloc];
	
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orientation {

	return UIInterfaceOrientationIsPortrait (orientation);
	
}

// self

- (void) toggleState {

	if (port.text == nil || [port.text isEqualToString: @""]) {
	
		[[[[UIAlertView alloc] initWithTitle: MFLocalizedString(@"Error") message: MFLocalizedString(@"You must enter a valid port number") delegate: nil cancelButtonTitle: MFLocalizedString(@"Dismiss") otherButtonTitles: nil] autorelease] show];
		
		return;
		
	}

	state = !state;
	port.enabled = !port.enabled;
	if (state) {
		seteuid(0);
		ctx = mg_start ();
		mg_set_option (ctx, "root", "/./");
		mg_set_option (ctx, "ports", [port.text UTF8String]);
		mg_set_option (ctx, "cgi_interp", "/usr/bin/php-cgi");
		mg_set_option (ctx, "index_files", "index.html,index.php");
		stateLabel.text = [NSString stringWithFormat: MFLocalizedString(@"Serving on port %@"), port.text];
		IPLabel.text = [NSString stringWithFormat: MFLocalizedString(@"IP address: %@"), [self localIPAddress]];
		[toggleStateButton setTitle: MFLocalizedString(@"Stop server") forState: UIControlStateNormal];
		
	} else {
	
		mg_stop (ctx);
		stateLabel.text = MFLocalizedString(@"Server is off");
		IPLabel.text = nil;
		[toggleStateButton setTitle: MFLocalizedString(@"Start server") forState: UIControlStateNormal];
		seteuid(501);
	}
	
}

- (NSString *) localIPAddress {

	char baseHostName[255];
	gethostname (baseHostName, 255);
	NSString *ipstr;

	char hn[255];
	sprintf (hn, "%s.local", baseHostName);
	
	struct hostent *host = gethostbyname (hn);
	if (host == NULL) {
		herror ("resolv");
		ipstr = NULL;
	} else {
		struct in_addr **list = (struct in_addr **)host->h_addr_list;
		ipstr = [NSString stringWithUTF8String: inet_ntoa (*list[0])];
	}
	
	return ipstr;
	
}

// UITextFieldDelegate

- (BOOL) textFieldShouldReturn: (UITextField *) textField {

	[textField resignFirstResponder];
	
	return YES;
	
}

@end


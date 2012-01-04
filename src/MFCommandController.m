//
// MFCommandController.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFCommandController.h"

#undef MFLocalizedString
#define MFLocalizedString(x) (NSLocalizedString((x), @""))


@implementation MFCommandController

// self

- (id) initWithCommand: (NSString *) command {

	self = [super init];

	self.navigationItem.title = MFLocalizedString(@"Executing command");
	cmd = [command copy];

	output = [[UITextView alloc] initWithFrame: (UIInterfaceOrientationIsPortrait (self.interfaceOrientation) ? CGRectMake (0, 0, 320, 460) : [[UIScreen mainScreen] applicationFrame])];
	output.editable = NO;
	output.text = [NSString stringWithFormat: MFLocalizedString(@"Executing command:\n%@...\n\n"), cmd];
	output.font = [UIFont fontWithName: @"CourierNewPS-BoldMT" size: 12.0];
	output.backgroundColor = [UIColor blackColor];
	output.textColor = [UIColor whiteColor];
	output.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview: output];
	[output release];

	return self;

}

- (void) start {
	isRunning = YES;
	seteuid(0);
	f = popen ([cmd UTF8String], "r");
	if (f == NULL) {
		[[[[UIAlertView alloc] initWithTitle: MFLocalizedString(@"Command failed") message: MFLocalizedString(@"The specified command couldn't be executed.") delegate: nil cancelButtonTitle: MFLocalizedString(@"Dismiss") otherButtonTitles: nil] autorelease] show];
	} else {
		 timer = [NSTimer scheduledTimerWithTimeInterval: 0.333 target: self selector: @selector(update) userInfo: NULL repeats: YES];
	}
}

- (void) update {
	char *out = malloc (sizeof(char) * 1025);
	if (fgets (out, 1024, f) != NULL) {
		output.text = [output.text stringByAppendingFormat: @"%s", out];
		[output scrollRangeToVisible: NSMakeRange ([output.text length] - 1, 0)];
	} else {
		[self end];
	}
	free (out);
}

- (void) end {
	if (isRunning) {
		seteuid(501);
		isRunning = NO;
		[timer invalidate];
		int exitCode = pclose (f);
		output.text = [output.text stringByAppendingFormat: MFLocalizedString(@"\nFinished with exit code: %i\n"), exitCode];
		[output scrollRangeToVisible: NSMakeRange ([output.text length] - 1, 0)];
	}
}

// super

- (void) dealloc {
	[cmd release];
	[super dealloc];
}

- (void) close {
	[self end];
	[super close];
}

@end

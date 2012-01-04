//
// MFTextAlert.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFTextAlert.h"

@implementation MFTextAlert

@synthesize textField = textField;

// self

- (id) initWithTitle: (NSString *) t {

	self = [super init];
	self.title = t;
	self.message = @"\n\n\n";

	textField = [[UITextField alloc] initWithFrame: CGRectMake (21, 55, 240, 28)];
	textField.borderStyle = UITextBorderStyleRoundedRect;
	textField.delegate = self;
	[self addSubview: textField];
	[textField release];

	return self;

}

// super

- (void) show {

	[super show];
	[textField becomeFirstResponder];

}

// UITextFieldDelegate

- (BOOL) textFieldShouldReturn: (UITextField *) tf {

	[tf resignFirstResponder];

	return YES;

}

@end


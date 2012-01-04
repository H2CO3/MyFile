//
// MFAboutController.m
// MyFile
//
// Created by Àrpád Goretity, 2011.
//

#import "MFAboutController.h"

@implementation MFAboutController

- (id) init {

	self = [super init];
	
	self.title = MFLocalizedString(@"About");
	self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	webView = [[UIWebView alloc] initWithFrame: CGRectMake (0, 0, 320, 460)];
	webView.scalesPageToFit = YES;
	webView.userInteractionEnabled = YES;
	webView.multipleTouchEnabled = YES;
	webView.autoresizingMask = self.view.autoresizingMask;
        NSString *path = [[NSBundle mainBundle] pathForResource: MFLocalizedString(@"about") ofType: @"html"];
        if (path == nil) {
                // unsupported language
                // default to English
                path = [[NSBundle mainBundle] pathForResource: @"about_en" ofType: @"html"];
        }
	[webView loadRequest: [NSURLRequest requestWithURL: [NSURL fileURLWithPath: path]]];
	[self.view addSubview: webView];
	[webView release];
	
	return self;
	
}

@end


//
// MFDonateController.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFDonateController.h"

@implementation MFDonateController

// super

- (id) init {

	self = [super init];
	
	self.title = MFLocalizedString(@"Please donate");
	
	webView = [[UIWebView alloc] initWithFrame: CGRectMake (0, 0, 320, 460)];
	webView.delegate = self;
	[webView loadRequest: [NSURLRequest requestWithURL: [NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource: MFLocalizedString(@"donate") ofType: @"html"]]]];
	[self.view addSubview: webView];
	[webView release];
	
	return self;
	
}

- (BOOL) shouldAutorotateToInterfaceOrientaion: (UIInterfaceOrientation) orientation {

	return UIInterfaceOrientationIsPortrait (orientation);
	
}

- (void) close {

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
	
	[super close];

}

// UIWebViewDelegate

- (void) webViewDidStartLoad: (UIWebView *) theWebView {

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
	
}

- (void) webViewDidFinishLoad: (UIWebView *) theWebView {

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
	
}

- (void) webView: (UIWebView *) theWebView didFailLoadWithError: (NSError *) theError {

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];

}

@end


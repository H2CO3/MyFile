//
// MFLoadingView.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFLoadingView.h"

@implementation MFLoadingView

// super

- (void) dealloc {

	[background release];
	background = nil;
	[spinwheel release];
	spinwheel = nil;
	[progressBar release];
	progressBar = nil;
	[text release];
	text = nil;
	
	[super dealloc];
	
}

// self

- (id) initWithType: (MFLoadingViewType) type {

	self = [super initWithFrame: CGRectMake (0, 0, 320, 480)];
	background = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"loadingbg.png"]];
	background.frame = CGRectMake (80, 160, 160, 160);
	[self addSubview: background];

	spinwheel = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
	spinwheel.center = CGPointMake (160, 240);
	[self addSubview: spinwheel];
	
	text = [[UILabel alloc] initWithFrame: CGRectMake (90, 170, 140, 30)];
	text.backgroundColor = [UIColor clearColor];
	text.textColor = [UIColor whiteColor];
	text.font = [UIFont boldSystemFontOfSize: 18.0];
	text.textAlignment = UITextAlignmentCenter;
	[self addSubview: text];

	if (type == MFLoadingViewTypeProgress) {
		progressBar = [[UIProgressView alloc] initWithFrame: CGRectMake (90, 290, 140, 20)];
		[self addSubview: progressBar];
		text.text = MFLocalizedString(@"Loading file");	
	} else if (type == MFLoadingViewTypeTemporary) {
		progressBar = nil;
		text.text = MFLocalizedString(@"Working");
	}
	
	return self;
	
}

- (void) show {

	[[[UIApplication sharedApplication] keyWindow] addSubview: self];
	[spinwheel startAnimating];

}

- (void) hide {

	[spinwheel stopAnimating];
	[self removeFromSuperview];

}

- (void) setProgress: (float) progress {

	progressBar.progress = progress;

}

- (void) setTitle: (NSString *) title {

	text.text = title;
	
}

@end

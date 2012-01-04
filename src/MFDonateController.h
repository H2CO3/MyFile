//
// MFDonateController.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MFModalController.h"

@interface MFDonateController: MFModalController <UIWebViewDelegate> {
	UIWebView *webView;
}

@end

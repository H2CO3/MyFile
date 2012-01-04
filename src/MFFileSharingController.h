//
// MFFileSharingController.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <arpa/inet.h>
#import <netdb.h>
#import <sys/types.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "mongoose.h"
#import "MFModalController.h"

@interface MFFileSharingController: MFModalController <UITextFieldDelegate> {
	UILabel *stateLabel;
	UILabel *IPLabel;
	UITextField *port;
	UILabel *portLabel;
	UIButton *toggleStateButton;
	struct mg_context *ctx;
	BOOL state;
}

- (void) toggleState;
- (NSString *) localIPAddress;

@end


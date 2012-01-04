//
// MFSocialManager.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"
#import "Twitter.h"
#import "MFAPIDefines.h"

enum MFSocialService {
	MFSocialServiceFacebook,
	MFSocialServiceTwitter
};

typedef enum MFSocialService MFSocialService;

@interface MFSocialManager: NSObject <FBSessionDelegate, SA_OAuthTwitterEngineDelegate, SA_OAuthTwitterControllerDelegate> {
	Facebook *facebook;
	SA_OAuthTwitterEngine *twitter;
}

@property (retain) Facebook *facebook;
@property (retain) SA_OAuthTwitterEngine *twitter;

+ (id) sharedManager;
- (id) loginToService: (MFSocialService) service;
- (void) logoutFromService: (MFSocialService) service;
- (BOOL) isServiceLoggedIn: (MFSocialService) service;

@end


//
// MFSocialManager.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFSocialManager.h"

static MFSocialManager *_sharedManager = nil;

@implementation MFSocialManager

@synthesize facebook = facebook;
@synthesize twitter = twitter;

// class

+ (id) sharedManager {

	if (_sharedManager == nil) {
		_sharedManager = [[self alloc] init];
	}
	
	return _sharedManager;
	
}

// super

- (id) init {

	self = [super init];
	
	facebook = [[Facebook alloc] initWithAppId: MF_FACEBOOK_KEY andDelegate: self];
	
	NSString *fbAccessToken = [[NSUserDefaults standardUserDefaults] objectForKey: @"FBAccessTokenKey"];
	NSDate *fbExpirationDate = [[NSUserDefaults standardUserDefaults] objectForKey: @"FBExpirationDateKey"];
	if ((fbAccessToken != nil) && (fbExpirationDate != nil)) {	
		facebook.accessToken = fbAccessToken;
		facebook.expirationDate = fbExpirationDate;
	}

	twitter = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate: self];
	twitter.consumerKey = MF_TWITTER_KEY;
	twitter.consumerSecret = MF_TWITTER_SECRET;
	
	return self;
	
}

// self

- (id) loginToService: (MFSocialService) service {

        id retVal;

	if (service == MFSocialServiceFacebook) {
	
		if (![[self facebook] isSessionValid]) {
			[[self facebook] authorize: [NSArray arrayWithObjects: @"publish_stream", nil]];
		}

                retVal = nil;
		
	} else if (service == MFSocialServiceTwitter) {
	
                if ([twitter isAuthorized]) {
                        return nil;
                }

		retVal = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: twitter delegate: self];

	}

        return retVal;
	
}

- (void) logoutFromService: (MFSocialService) service {

	if (service == MFSocialServiceFacebook) {
	
		[facebook logout: self];
		
	} else if (service == MFSocialServiceTwitter) {
	
		[twitter clearAccessToken];
		
	}
	
}

- (BOOL) isServiceLoggedIn: (MFSocialService) service {

	BOOL isLoggedIn;

	if (service == MFSocialServiceFacebook) {
	
		isLoggedIn = [facebook isSessionValid];
		
	} else if (service == MFSocialServiceTwitter) {
	
		isLoggedIn = [twitter isAuthorized];
		
	}
	
	return isLoggedIn;
	
}

// FBSessionDelegate

- (void) fbDidLogin {

	[[NSUserDefaults standardUserDefaults] setObject: [[self facebook] accessToken] forKey: @"FBAccessTokenKey"];
	[[NSUserDefaults standardUserDefaults] setObject: [[self facebook] expirationDate] forKey: @"FBExpirationDateKey"];
	[[NSUserDefaults standardUserDefaults] synchronize];

}

// SA_AOuthTwitterEngineDelegate

- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {

	[[NSUserDefaults standardUserDefaults] setObject: data forKey: @"MFTwitterOAuthData"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {

	return [[NSUserDefaults standardUserDefaults] objectForKey: @"MFTwitterOAuthData"];
	
}

// SA_OAuthTwitterControllerDelegate

@end


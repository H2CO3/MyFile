//
//  SA_OAuthTwitterEngine.h
//
//  Created by Ben Gottlieb on 24 July 2009.
//  Copyright 2009 Stand Alone, Inc.
//
//  Some code and concepts taken from examples provided by 
//  Matt Gemmell, Chris Kimpton, and Isaiah Carew
//  See ReadMe for further attributions, copyrights and license info.
//

#import "MGTwitterEngine.h"
#import "OAToken.h"
#import "OAConsumer.h"

// Implement these methods to store off the creds returned by Twitter
// If you don't do this, the user will have to re-authenticate every time they run your app
@protocol SA_OAuthTwitterEngineDelegate
@optional
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username;
- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username;
- (void) twitterOAuthConnectionFailedWithData: (NSData *) data; 
@end

@interface SA_OAuthTwitterEngine : MGTwitterEngine {
	NSURL		*_requestTokenURL;
	NSURL		*_accessTokenURL;
	NSURL		*_authorizeURL;
	NSString	*_pin;
@private
	OAConsumer	*_consumer;
	OAToken		*_requestToken;
}

@property (nonatomic, readwrite, retain) NSString *consumerSecret, *consumerKey;
@property (nonatomic, readwrite, retain) NSURL *requestTokenURL, *accessTokenURL, *authorizeURL;
@property (nonatomic, readonly) BOOL OAuthSetup;
@property (nonatomic, readwrite, retain)  NSString *pin;
@property (nonatomic, readonly) NSURLRequest *authorizeURLRequest;
@property (nonatomic, readonly) OAConsumer *consumer;

+ (SA_OAuthTwitterEngine *) OAuthTwitterEngineWithDelegate: (NSObject *) delegate;
- (SA_OAuthTwitterEngine *) initOAuthWithDelegate: (NSObject *) delegate;
- (BOOL) isAuthorized;
- (void) requestAccessToken;
- (void) requestRequestToken;
- (void) clearAccessToken;

@end


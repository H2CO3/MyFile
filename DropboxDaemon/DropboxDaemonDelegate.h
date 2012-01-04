//
// DropboxDaemonDelegate.h
// dropboxd, MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <sys/types.h>
#import <sys/stat.h>
#import <openssl/md5.h>
#import <Foundation/Foundation.h>
#import "DropboxSDK.h"
#import "MFAPIDefines.h"

@interface DropboxDaemonDelegate: NSObject <DBRestClientDelegate> {
	DBSession *session;
	DBMetadata *data;
	DBRestClient *restClient;
	NSMutableArray *a;
	NSMutableArray *astat;
	NSMutableArray *b;
	NSMutableArray *bstat;
	NSFileManager *mgr;
        NSUserDefaults *userDefaults;
        NSDictionary *defaultsDict;
}

- (void) uploadFiles: (NSArray *) files;
- (void) deleteFiles: (NSArray *) files;
- (void) downloadFiles: (NSArray *) files;
- (void) deleteLocalFiles: (NSArray *) files;
- (void) check;

@end


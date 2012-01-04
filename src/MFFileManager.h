//
// MFFileManager.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <stdio.h>
#import <stdlib.h>
#import <unistd.h>
#import <math.h>
#import <string.h>
#import <time.h>
#import <errno.h>
#import <pwd.h>
#import <grp.h>
#import <sys/types.h>
#import <sys/stat.h>
#import <Foundation/Foundation.h>
#import "Dropbox.h"
#import "MFFile.h"
#import "MFFileType.h"
#import "MFAPIDefines.h"

@protocol MFFileManagerDelegate;

@interface MFFileManager: NSObject <DBRestClientDelegate> {
	NSFileManager *fileManager;
	NSString *userID;
	DBSession *session;
	DBRestClient *restClient;
	id <MFFileManagerDelegate> delegate;
}

@property (assign) id <MFFileManagerDelegate> delegate;
@property (copy) NSString *userID;

- (NSMutableArray *) contentsOfDirectory: (NSString *) path;
- (NSString *) freeSpace: (NSString *) path;
- (unsigned) numberOfItemsInDirectory: (NSString *) path;
- (BOOL) fileIsDirectory: (NSString *) path;
- (void) deleteFile: (NSString *) path;
- (void) createFile: (NSString *) path isDirectory: (BOOL) dir;
- (void) copyFile: (NSString *) path1 toPath: (NSString *) path2;
- (void) moveFile: (NSString *) path1 toPath: (NSString *) path2;
- (void) linkFile: (NSString *) path1 toPath: (NSString *) path2;
- (void) chmodFile: (NSString *) path permissions: (NSString *) permissions;
- (void) chownFile: (NSString *) path user: (NSString *) user group: (NSString *) group;

- (void) dbLoadMetadata: (NSString *) path;
- (void) dbLoadUserInfo;

- (void) dbDownloadFile: (NSString *) path;
- (void) dbUploadFile: (NSString *) path1 toPath: (NSString *) path2;
- (void) dbCreateDirectory: (NSString *) path;
- (void) dbDeleteFile: (NSString *) path;

@end

@protocol MFFileManagerDelegate <NSObject>
@optional
- (void) fileManagerDBLoadedMetadata: (DBMetadata *) metadata;
- (void) fileManagerDBLoadMetadataFailed;
- (void) fileManagerDBLoadedUserInfo: (DBAccountInfo *) accountInfo;
- (void) fileManagerDBLoadUserInfoFailed;

- (void) fileManagerDBDownloadedFile: (NSString *) path;
- (void) fileManagerDBDownloadProgress: (float) progress forFile: (NSString *) path;
- (void) fileManagerDBDownloadFileFailed;
- (void) fileManagerDBUploadedFile: (NSString *) path toPath: (NSString *) path;
- (void) fileManagerDBUploadProgress: (float) progress forFile: (NSString *) path;
- (void) fileManagerDBUploadFileFailed;
- (void) fileManagerDBDeletedFile: (NSString *) path;
- (void) fileManagerDBDeleteFileFailed;
- (void) fileManagerDBCreatedDirectory: (NSString *) path;
- (void) fileManagerDBCreateDirectoryFailed;
@end


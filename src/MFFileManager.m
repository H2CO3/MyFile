//
// MFFileManager.m
// MyFile
//
// Created by Àrpád Goretity, 2011.
//

#import "MFFileManager.h"

@implementation MFFileManager

@synthesize delegate = delegate;
@synthesize userID = userID;

// super

- (id) init {

	self = [super init];
	
	fileManager = [[NSFileManager alloc] init];
	session = [[DBSession alloc] initWithConsumerKey: MF_DROPBOX_KEY consumerSecret: MF_DROPBOX_SECRET];
	[DBSession setSharedSession: session];
	[session release];
	restClient = [[DBRestClient alloc] initWithSession: [DBSession sharedSession]];
	restClient.delegate = self;

	return self;

}

- (void) dealloc {

	[fileManager release];
	fileManager = nil;
	[restClient release];
	restClient = nil;
	
	[super dealloc];
	
}

// self

- (NSMutableArray *) contentsOfDirectory: (NSString *) path {
	seteuid(0);
	struct stat attributes;
	float fs;
	char prefix;
	NSArray *cnt = [fileManager contentsOfDirectoryAtPath: path error: NULL];
	NSMutableArray *contents = [[[NSMutableArray alloc] init] autorelease];
	for (int i = 0; i < [cnt count]; i++) {

		NSString *fileName = [path stringByAppendingPathComponent: [cnt objectAtIndex: i]];
		stat ([fileName UTF8String], &attributes);

		MFFile *file = [[MFFile alloc] init];
		file.path = path;
		file.name = [cnt objectAtIndex: i];
		file.type = [MFFileType fileTypeForName: [cnt objectAtIndex: i]];
		file.mime = [MFFileType mimeTypeForName: [cnt objectAtIndex: i]];
		file.isDirectory = [self fileIsDirectory: fileName];
		file.isSymlink = (readlink ([fileName UTF8String], NULL, 0) != -1);
		
		if (attributes.st_size > 1024 * 1024 * 1024) {
			fs = (float)attributes.st_size / (1024.0 * 1024.0 * 1024.0);
			prefix = 'G';
		} else if (attributes.st_size > 1024 * 1024) {
			fs = (float)attributes.st_size / (1024.0 * 1024.0);
			prefix = 'M';
		} else if (attributes.st_size > 1024) {
			fs = (float)attributes.st_size / 1024.0;
			prefix = 'k';
		} else {
			fs = (float)attributes.st_size;
			prefix = NULL;
		}
		file.fsize = [NSString stringWithFormat: @"%.2f %cB", fs, prefix];
		file.bytessize = attributes.st_size;
		file.permissions = [NSString stringWithFormat: @"%04o", attributes.st_mode & 07777];
		struct passwd *usr = getpwuid (attributes.st_uid);
		struct group *grp = getgrgid (attributes.st_gid);
		if ((usr != NULL) && (grp != NULL)) {
			file.owner = [NSString stringWithUTF8String: usr->pw_name];
			file.group = [NSString stringWithUTF8String: grp->gr_name];
			time_t at = attributes.st_atime;
			time_t mt = attributes.st_mtime;
			file.atime = [NSString stringWithUTF8String: ctime (&at)];
			file.mtime = [NSString stringWithUTF8String: ctime (&mt)];
		}
		[contents addObject: file];
		[file release];

	}
	
	NSMutableArray *dirs = [[NSMutableArray alloc] init];
	NSMutableArray *files = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < [contents count]; i++) {
	
		if ([[contents objectAtIndex: i] isDirectory]) {
		
			[dirs addObject: [contents objectAtIndex: i]];
			
		} else {
		
			[files addObject: [contents objectAtIndex: i]];
			
		}
		
	}
	
	[contents removeAllObjects];
	
	for (int i = 0; i < [dirs count]; i++) {
	
		for (int j = 0; j < i; j++) {
		
			if ([[[dirs objectAtIndex: i] name] compare: [[dirs objectAtIndex: j] name] options: NSCaseInsensitiveSearch] == NSOrderedAscending) {
			
				[dirs exchangeObjectAtIndex: i withObjectAtIndex: j];
				
			}
			
		}
		
	}

	for (int i = 0; i < [files count]; i++) {
	
		for (int j = 0; j < i; j++) {
		
			if ([[[files objectAtIndex: i] name] compare: [[files objectAtIndex: j] name] options: NSCaseInsensitiveSearch] == NSOrderedAscending) {
			
				[files exchangeObjectAtIndex: i withObjectAtIndex: j];
				
			}
			
		}
		
	}

	[contents addObjectsFromArray: dirs];
	[contents addObjectsFromArray: files];
	[dirs release];
	dirs = nil;
	[files release];
	files = nil;
	seteuid(501);
	return contents;

}

- (NSString *) freeSpace: (NSString *) path {
	seteuid(0);
	NSDictionary* fsAttr = [fileManager attributesOfFileSystemForPath: path error: NULL];
	unsigned long long freeSize = [(NSNumber *)[fsAttr objectForKey: NSFileSystemFreeSize] unsignedLongLongValue];
	NSString *res;
	if (freeSize >= 1024 * 1024 * 1024) {
		res = [NSString stringWithFormat: @"%.2f GB", freeSize / (1024.0 * 1024.0 * 1024.0)];
	} else if (freeSize >= 1024 * 1024) {
		res = [NSString stringWithFormat: @"%.2f MB", freeSize / (1024.0 * 1024.0)];
	} else if (freeSize >= 1024) {
		res = [NSString stringWithFormat: @"%.2f kB", freeSize / 1024.0];
	} else {
		res = [NSString stringWithFormat: @"%ld B", freeSize];
	}
	seteuid(501);
	return res;

}

- (unsigned) numberOfItemsInDirectory: (NSString *) path {
	unsigned count = 0;
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSArray *conts = [fileManager contentsOfDirectoryAtPath: path error: NULL];
	count = [conts count];
	[pool release];
	return count;

}

- (BOOL) fileIsDirectory: (NSString *) path {
	seteuid(0);
	BOOL isDirectory;
	[fileManager fileExistsAtPath: path isDirectory: &isDirectory];
	seteuid(501);
	return isDirectory;
	
}

- (void) createFile: (NSString *) path isDirectory: (BOOL) dir {
	seteuid(0);
	if (dir) {
		[fileManager createDirectoryAtPath: path withIntermediateDirectories: YES attributes: nil error: NULL];
	} else {
		[fileManager createFileAtPath: path contents: nil attributes: nil];
	}
	seteuid(501);
}

- (void) deleteFile: (NSString *) path {
	seteuid(0);
	if ([[NSUserDefaults standardUserDefaults] boolForKey: @"MFUseTrash"]) {
		[self moveFile: path toPath: @"/var/mobile/Library/MyFile/Trash/"];
	} else {
		char *cmd = [[NSString stringWithFormat: @"rm -rf %@", [path stringByReplacingOccurrencesOfString: @" " withString: @"\\ "]] UTF8String];
		system (cmd);
	}
	seteuid(501);
}

- (void) copyFile: (NSString *) path1 toPath:  (NSString *) path2 {
	seteuid(0);
	char *npath1 = [[path1 stringByReplacingOccurrencesOfString: @" " withString: @"\\ "] UTF8String];
	char *npath2 = [[path2 stringByReplacingOccurrencesOfString: @" " withString: @"\\ "] UTF8String];
	NSString *copycmd = [[NSString alloc] initWithFormat: @"cp -r %s %s", npath1, npath2];
	system ([copycmd UTF8String]);
	[copycmd release];
	struct stat attr;
	stat (npath1, &attr);
	chmod (npath2, attr.st_mode & 07777);
	chown (npath2, attr.st_uid, attr.st_gid);
	seteuid(501);
}

- (void) moveFile: (NSString *) path1 toPath: (NSString *) path2 {
	seteuid(0);
	char *cmd = [[NSString stringWithFormat: @"mv %@ %@", [path1 stringByReplacingOccurrencesOfString: @" " withString: @"\\ "], [path2 stringByReplacingOccurrencesOfString: @" " withString: @"\\ "]] UTF8String];
	system (cmd);
	seteuid(501);
}

- (void) linkFile: (NSString *) path1 toPath: (NSString *) path2 {
	seteuid(0);
	[fileManager createSymbolicLinkAtPath: [path2 stringByReplacingOccurrencesOfString: @" " withString: @"\\ "] withDestinationPath: [path1 stringByReplacingOccurrencesOfString: @" " withString: @"\\ "] error: NULL];
	seteuid(501);
}

- (void) chmodFile: (NSString *) path permissions: (NSString *) permissions {
	seteuid(0);
	if ([permissions length] == 4) {

		int permissionsOctal = 0;
		for (int i = 0; i < 4; i++) {
			char c = [permissions characterAtIndex: i];
			permissionsOctal += atoi(&c) * pow(8, 3 - i);
		}
	
		chmod ([[path stringByReplacingOccurrencesOfString: @" " withString: @"\\ "] UTF8String], permissionsOctal);
		
	}
	seteuid(501);
}
	
- (void) chownFile: (NSString *) file user: (NSString *) user group: (NSString *) group {
	seteuid(0);
	struct passwd *usr = getpwnam ([user UTF8String]);
	struct group *grp = getgrnam ([group UTF8String]);
	if ((usr != NULL) && (grp != NULL)) {
		chown ([[file stringByReplacingOccurrencesOfString: @" " withString: @"\\ "] UTF8String], usr->pw_uid, grp->gr_gid);
	}
	seteuid(501);
}

- (void) dbLoadMetadata: (NSString *) path {

	[restClient loadMetadata: path];
	
}

- (void) dbLoadUserInfo {

	[restClient loadAccountInfo];
	
}

- (void) dbDownloadFile: (NSString *) path {
	seteuid(0);
	[restClient loadFile: path intoPath: [@"/var/mobile/Documents" stringByAppendingPathComponent: [path lastPathComponent]]];
	
}

- (void) dbUploadFile: (NSString *) path1 toPath: (NSString *) path2 {
	seteuid(0);
	[restClient loadAccountInfo];
	[restClient uploadFile: [path1 lastPathComponent] toPath: path2 fromPath: path1];
		
}

- (void) dbCreateDirectory: (NSString *) path {

	[restClient createFolder: path];
	
}

- (void) dbDeleteFile: (NSString *) path {

	[restClient deletePath: path];
	
}

// DBRestClientDelegate

- (void) restClient: (DBRestClient *) client loadedMetadata: (DBMetadata *) metadata {

	if ([self.delegate respondsToSelector: @selector(fileManagerDBLoadedMetadata:)]) {
		[self.delegate fileManagerDBLoadedMetadata: metadata];
	}
	
}

- (void) restClient: (DBRestClient *) client loadMetadataFailedWithError: (NSError *) error {

	if ([self.delegate respondsToSelector: @selector(fileManagerDBLoadMetadataFailed)]) {
		[self.delegate fileManagerDBLoadMetadataFailed];
	}
	
}

- (void) restClient: (DBRestClient *) client loadedAccountInfo: (DBAccountInfo *) accountInfo {

	self.userID = accountInfo.userId;
	
}

- (void) restClient: (DBRestClient *) client loadAccountInfoFailedWithError: (NSError * )error {

	self.userID = nil;
	
}

- (void) restClient: (DBRestClient *) client loadedFile: (NSString *) path {
	seteuid(501);
	if ([self.delegate respondsToSelector: @selector(fileManagerDBDownloadedFile:)]) {
		[self.delegate fileManagerDBDownloadedFile: path];
	}

}

- (void) restClient: (DBRestClient *) client loadProgress: (CGFloat) progress forFile: (NSString *) path {

	if ([self.delegate respondsToSelector: @selector(fileManagerDBDownloadProgress:forFile:)]) {
		[self.delegate fileManagerDBDownloadProgress: progress forFile: path];
	}
	
}

- (void) restClient: (DBRestClient *) client loadFileFailedWithError: (NSError *) error {
	seteuid(501);
	if ([self.delegate respondsToSelector: @selector(fileManagerDBDownloadFileFailed)]) {
	[self.delegate fileManagerDBDownloadFileFailed];
	}
	
}

- (void) restClient: (DBRestClient *) client uploadedFile: (NSString *) destPath from: (NSString *) srcPath {
	seteuid(501);
	if ([self.delegate respondsToSelector: @selector(fileManagerDBUploadedFile:toPath:)]) {
		[self.delegate fileManagerDBUploadedFile: srcPath toPath: destPath ];
	}
	
}

- (void) restClient: (DBRestClient *) client uploadProgress: (CGFloat) progress forFile: (NSString *) destPath from: (NSString *) srcPath {

	if ([self.delegate respondsToSelector: @selector(fileManagerDBUploadProgress:forFile:)]) {
		[self.delegate fileManagerDBUploadProgress: progress forFile: destPath];
	}
	
}

- (void) restClient: (DBRestClient *) client uploadFileFailedWithError: (NSError *) error {
	seteuid(501);
	if ([self.delegate respondsToSelector: @selector(fileManagerDBUploadFileFailed)]){
		[self.delegate fileManagerDBUploadFileFailed];
	}
	
}

- (void) restClient: (DBRestClient*) client createdFolder: (DBMetadata*) folder {

	if ([self.delegate respondsToSelector: @selector(fileManagerDBCreatedDirectory:)]) {
		[self.delegate fileManagerDBCreatedDirectory: folder.path];
	}

}

- (void) restClient: (DBRestClient *) client createFolderFailedWithError: (NSError *) error {

	if ([self.delegate respondsToSelector: @selector(fileManagerDBCreateDirectoryFailed)]) {
		[self.delegate fileManagerDBCreateDirectoryFailed];
	}
	
}

- (void) restClient: (DBRestClient *) client deletedPath: (NSString *) path {

	if ([self.delegate respondsToSelector: @selector(fileManagerDBDeletedFile:)]) {
		[self.delegate fileManagerDBDeletedFile: path];
	}
	
}

- (void) restClient: (DBRestClient *) client deletePathFailedWithError: (NSError*) error {

	if ([self.delegate respondsToSelector: @selector(fileManagerDBDeleteFileFailed)]){
		[self.delegate fileManagerDBDeleteFileFailed];
	}
	
}

@end



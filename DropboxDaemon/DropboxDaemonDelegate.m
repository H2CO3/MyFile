//
// DropboxDaemonDelegate.m
// dropboxd, MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "DropboxDaemonDelegate.h"

@implementation DropboxDaemonDelegate

// super

- (id) init {

	self = [super init];
	
	session = [[DBSession alloc] initWithConsumerKey: MF_DROPBOX_KEY consumerSecret: MF_DROPBOX_SECRET];
	[DBSession setSharedSession: session];
	[session release];
	restClient = [[DBRestClient alloc] initWithSession: [DBSession sharedSession]];
	restClient.delegate = self;

	data = [[DBMetadata alloc] init];
	mgr = [[NSFileManager alloc] init];
	userDefaults = [[NSUserDefaults alloc] init];
	defaultsDict = [userDefaults persistentDomainForName: @"org.h2co3.myfile"];
	[restClient loadMetadata: [defaultsDict objectForKey: @"MFDropboxDaemonPathRemote"]];
	a = [[NSMutableArray alloc] init];
	astat = [[NSMutableArray alloc] init];
	b = [[NSMutableArray alloc] init];
	bstat = [[NSMutableArray alloc] init];	
	return self;
	
}

- (void) dealloc {

	[restClient release];
	[mgr release];
	[a release];
	[b release];
	[astat release];
	[bstat release];
	[data release];
	[userDefaults release];

	[super dealloc];
	
}

// DBRestClientDelegate

- (void)restClient: (DBRestClient *) rc loadedMetadata: (DBMetadata *) md {

	if (![data isEqualToMetadata: md]) {
		// metadata has changed
		CFUserNotificationDisplayAlert (5.0, 3, NULL, NULL, NULL, CFSTR ("Contents changed"), ([md.contents count] > [data.contents count] ? CFSTR ("One or more files were added to your remote Dropbox folder.") : CFSTR ("One or more files were deleted from your remote Dropbox folder.")), CFSTR ("Dismiss"), NULL, NULL, NULL);
		if ([md.contents count] > [data.contents count]) {
			// remote add; proceed with download
			NSMutableArray *prev = [[NSMutableArray alloc] init];
			NSMutableArray *next = [[NSMutableArray alloc] init];
			for (int i = 0; i < [md.contents count]; i++) {
				[next addObject: [[md.contents objectAtIndex: i] path]];
			}
			for (int j = 0; j < [data.contents count]; j++) {
				[prev addObject: [[data.contents objectAtIndex: j] path]];
			}
			[next removeObjectsInArray: prev];
			[self downloadFiles: next];
			[prev release];
			[next release];
		} else if ([md.contents count] < [data.contents count]) {
			// remote deletion; proceed with local
			NSMutableArray *prev = [[NSMutableArray alloc] init];
			NSMutableArray *next = [[NSMutableArray alloc] init];
			for (int i = 0; i < [md.contents count]; i++) {
				[next addObject: [[md.contents objectAtIndex: i] path]];
			}
			for (int j = 0; j < [data.contents count]; j++) {
				[prev addObject: [[data.contents objectAtIndex: j] path]];
			}
			[prev removeObjectsInArray: next];
			[self deleteLocalFiles: prev];
			[prev release];
			[next release];
		} else {
			// only updated a file/some files
			NSMutableArray *changed = [[NSMutableArray alloc] init];
			for (int i = 0; i < [md.contents count]; i++) {
				// find which file(s) has/have been modified
				if (![[md.contents objectAtIndex: i] isEqualToMetadata: [data.contents objectAtIndex: i]]) {
					// Add modified file to download queue
					[changed addObject: [[md.contents objectAtIndex: i] path]];
				}
			}
			[self downloadFiles: changed];
			[changed release];
		}
	}

	[data release];
	data = [md retain];

}

// self

- (void) uploadFiles: (NSArray *) files {

	for (int i = 0; i < [files count]; i++) {
	
		NSString *path = [[defaultsDict objectForKey: @"MFDropboxDaemonPathLocal"] stringByAppendingPathComponent: [files objectAtIndex: i]];
		[restClient uploadFile: [files objectAtIndex: i] toPath: [defaultsDict objectForKey: @"MFDropboxDaemonPathRemote"] fromPath: path];
		
	}
	
}

- (void) downloadFiles: (NSArray *) files {

	for (int i = 0; i < [files count]; i++) {
		[restClient loadFile: [files objectAtIndex: i] intoPath: [[defaultsDict objectForKey: @"MFDropboxDaemonPathLocal"] stringByAppendingPathComponent: [[files objectAtIndex: i] lastPathComponent]]];
	}

}

- (void) deleteFiles: (NSArray *) files {

	for (int i = 0; i < [files count]; i++) {
		[restClient deletePath: [[defaultsDict objectForKey: @"MFDropboxDaemonPathRemote"] stringByAppendingPathComponent: [files objectAtIndex: i]]];
	}
	
}

- (void) deleteLocalFiles: (NSArray *) files {

	for (int i = 0; i < [files count]; i++) {
		NSString *path = [[defaultsDict objectForKey: @"MFDropboxDaemonPathLocal"] stringByAppendingPathComponent: [[files objectAtIndex: i] lastPathComponent]];
		[mgr removeItemAtPath: path error: NULL];
	}

}

- (void) check {

	if (![[DBSession sharedSession] isLinked]) {

		CFUserNotificationDisplayAlert (5.0, 3, NULL, NULL, NULL, CFSTR ("Not authorized"), CFSTR ("You haven't yet logged in to Dropbox. Please log in using MyFile Settings then restart the Dropbox daemon."), CFSTR ("Dismiss"), NULL, NULL, NULL);
		exit (1);

	}

	[restClient loadMetadata: [defaultsDict objectForKey: @"MFDropboxDaemonPathRemote"]];
	[a removeAllObjects];
	[astat removeAllObjects];
	[a addObjectsFromArray: [mgr contentsOfDirectoryAtPath: [defaultsDict objectForKey: @"MFDropboxDaemonPathLocal"] error: NULL]];
	for (int i = 0; i < [a count]; i++) {
		struct stat *attr = malloc (sizeof (struct stat));
		stat ([[[defaultsDict objectForKey: @"MFDropboxDaemonPathLocal"] stringByAppendingPathComponent: [a objectAtIndex: i]] UTF8String], attr);
		[astat addObject: [NSNumber numberWithLong: attr->st_mtime]];
		free (attr);
	}
	if ([a count] != [b count]){
		// alert user
		CFUserNotificationDisplayAlert (5.0, 3, NULL, NULL, NULL, CFSTR ("Contents changed"), [a count] > [b count] ? CFSTR ("One or more files were added to your local Dropbox folder.") : CFSTR("One or more files were deleted from your local Dropbox folder."), CFSTR ("Dismiss"), NULL, NULL, NULL);
		// upload the new files
		if ([a count] > [b count]) {
			// files were added, so we upload the difference
			[a removeObjectsInArray: b];
			[self uploadFiles: a];
		} else if ([a count] < [b count]) {
			// files were deleted, so remotely delete the difference
			[b removeObjectsInArray: a];
			[self deleteFiles: b];
		}
		
	} else {
	
		// if the directory count equals, it can still be the case that some files were modified
		NSMutableArray *changed = [[NSMutableArray alloc] init];
		for (int i = 0; i < [a count]; i++) {
			if ([[astat objectAtIndex: i] longValue] != [[bstat objectAtIndex: i] longValue]) {
				[changed addObject: [a objectAtIndex: i]];
			}
		}
		if ([changed count] > 0) {
			CFUserNotificationDisplayAlert (5.0, 3, NULL, NULL, NULL, CFSTR ("Contents changed"), CFSTR ("One or more files were modified in your local Dropbox folder."), CFSTR ("Dismiss"), NULL, NULL, NULL);
		}
		[self uploadFiles: changed];
		[changed release];
		
	}

	[b removeAllObjects];
	[bstat removeAllObjects];
	[b addObjectsFromArray: [mgr contentsOfDirectoryAtPath: [defaultsDict objectForKey: @"MFDropboxDaemonPathLocal"] error: NULL]];
	for (int i = 0; i < [b count]; i++) {
		struct stat *attr = malloc (sizeof (struct stat));
		stat ([[[defaultsDict objectForKey: @"MFDropboxDaemonPathLocal"] stringByAppendingPathComponent: [b objectAtIndex: i]] UTF8String], attr);
		[bstat addObject: [NSNumber numberWithLong: attr->st_mtime]];
		free (attr);
	}

}

@end


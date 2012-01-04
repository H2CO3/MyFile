//
// MFDropboxController.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFDropboxController.h"
#import "MFMainController.h"

@implementation MFDropboxController

@synthesize mainController = mainController;

// super

- (id) init {

	self = [super init];

	self.title = @"/";
	
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAction target: self action: @selector(showActions)];
	self.navigationItem.rightBarButtonItem = rightButton;
	[rightButton release];
	
	loginController = [[DBLoginController alloc] init];
	loginController.delegate = self;
	files = [[NSMutableArray alloc] init];
	currentDirectory = @"/";
	
	actions = [[UIActionSheet alloc] init];
	actions.delegate = self;
	actions.title = MFLocalizedString(@"Dropbox actions");
	actions.cancelButtonIndex = 2;
	actions.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[actions addButtonWithTitle: MFLocalizedString(@"Parent directory")];
	[actions addButtonWithTitle: MFLocalizedString(@"Create folder")];
	[actions addButtonWithTitle: MFLocalizedString(@"Cancel")];
	
	return self;
	
}

- (void) refresh {

	[self performSelector: @selector(loadMetadata:) withObject: currentDirectory afterDelay: 0.0];
	
}

- (void) dealloc {

	[loginController release];
	[tableView release];
	[actions release];

	[super dealloc];

}

// self

- (void) showActions {

	[actions showInView: self.view];

}

- (void) loadRoot {

	if ([[DBSession sharedSession] isLinked]) {
	
		[self loadMetadata: [currentDirectory stringByDeletingLastPathComponent]];
		
	} else {
	
		[loginController presentFromController: self];
		
	}
	
}

- (void) loadMetadata: (NSString *) path {

	if (!isLoading) {
		loadingView = [[MFLoadingView alloc] initWithType: MFLoadingViewTypeTemporary];
		[loadingView show];
	}
	currentDirectory = [path copy];
	[[self.mainController fileManager] dbLoadMetadata: path];

}

- (void) downloadFile: (NSString *) path {

	loadingView = [[MFLoadingView alloc] initWithType: MFLoadingViewTypeProgress];
	[loadingView show];
	[[self.mainController fileManager] dbDownloadFile: path];
	
}

- (void) deleteFile: (NSString *) path {

	loadingView = [[MFLoadingView alloc] initWithType: MFLoadingViewTypeTemporary];
	[loadingView show];
	[[self.mainController fileManager] dbDeleteFile: path];
	
}

- (void) createDirectory: (NSString *) path {

	loadingView = [[MFLoadingView alloc] initWithType: MFLoadingViewTypeTemporary];
	[loadingView show];
	[[self.mainController fileManager] dbCreateDirectory: path];
	
}

// UIActionSheetDelegate

- (void) actionSheet: (UIActionSheet *) actionSheet didDismissWithButtonIndex: (int) index {

	if (index == 0) {
		[self loadRoot];
	} else if (index == 1) {
		MFDropboxNewDirController *dirCtrl = [[MFDropboxNewDirController alloc] initWithPath: currentDirectory];
		dirCtrl.mainController = self;
		[dirCtrl presentFrom: self];
		[dirCtrl release];
	}

}

// UITableViewDataSource

- (int) tableView: (UITableView *) theTableView numberOfRowsInSection: (int) section {

	return [files count];
	
}

- (NSString *) tableView: (UITableView *) theTableView titleForHeaderInSection: (int) section {

	return currentDirectory;

}

- (UITableViewCell *) tableView: (UITableView *) theTableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier: @"MFDBCell"];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: @"MFDBCell"] autorelease];
	}
	cell.textLabel.text = [[[files objectAtIndex: indexPath.row] path] lastPathComponent];
	cell.detailTextLabel.text = [[files objectAtIndex: indexPath.row] isDirectory] ? nil : [[files objectAtIndex: indexPath.row] humanReadableSize];
	cell.imageView.image = [[files objectAtIndex: indexPath.row] isDirectory] ? [UIImage imageNamed: @"dir.png"] : [MFFileType imageForName: cell.textLabel.text];
	
	return cell;
		
}

// UITableViewDelegate

- (void) tableView: (UITableView *) theTableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

	[theTableView deselectRowAtIndexPath: indexPath animated: YES];

	if ([[files objectAtIndex: indexPath.row] isDirectory]) {

		[self loadMetadata: [[files objectAtIndex: indexPath.row] path]];

	} else {

		[self downloadFile: [[files objectAtIndex: indexPath.row] path]];

	}

}

- (void) tableView: (UITableView *) theTableView commitEditingStyle: (UITableViewCellEditingStyle) style forRowAtIndexPath: (NSIndexPath *) indexPath {

	[self deleteFile: [[files objectAtIndex: indexPath.row] path]];
	[files removeObjectAtIndex: indexPath.row];
	[tableView deleteRowsAtIndexPaths: [NSArray arrayWithObject: indexPath] withRowAnimation: UITableViewRowAnimationRight];

}

// DBLoginControllerDelegate

- (void) loginControllerDidLogin: (DBLoginController *) controller {

	[self loadMetadata: @"/"];
	
}

- (void) loginControllerDidCancel: (DBLoginController *) controller {

	[[[[UIAlertView alloc] initWithTitle: MFLocalizedString(@"Login required") message: MFLocalizedString(@"Please note that you'll need to log in in order to use MyFile with your Dropbox account.") delegate: nil cancelButtonTitle: MFLocalizedString(@"Dismiss") otherButtonTitles: nil] autorelease] show];

}

// MFFileManagerDelegate

- (void) fileManagerDBLoadedMetadata: (DBMetadata *) metadata {

	if (!isLoading) {
		if (loadingView != nil) {
			[loadingView hide];
			loadingView = nil;
		}
	}
	[files removeAllObjects];
	self.title = [metadata.path lastPathComponent];
	[files addObjectsFromArray: metadata.contents];

	[tableView reloadData];
	[self stopLoading];

}

- (void) fileManagerDBLoadMetadataFailed {

	if (!isLoading) {
		if (loadingView != nil) {
			[loadingView hide];
			loadingView = nil;
		}
	}
	[[[[UIAlertView alloc] initWithTitle: MFLocalizedString(@"Error loading metadata") message: MFLocalizedString(@"Please make sure that you are connected to the Internet and try again.") delegate: nil cancelButtonTitle: MFLocalizedString(@"Dismiss") otherButtonTitles: nil] autorelease] show];
	[self stopLoading];

}

- (void) fileManagerDBDownloadedFile: (NSString *) path {

	if (loadingView != nil) {
		[loadingView hide];
		loadingView = nil;
	}
	[[[[UIAlertView alloc] initWithTitle: MFLocalizedString(@"Download successful") message: [NSString stringWithFormat: MFLocalizedString(@"You've successfully downloaded the file to %@"), path] delegate: nil cancelButtonTitle: MFLocalizedString(@"Dismiss") otherButtonTitles: nil] autorelease] show];

}

- (void) fileManagerDBDownloadProgress: (float) progress forFile: (NSString *) path {

	[loadingView setProgress: progress];

}

- (void) fileManagerDBDownloadFileFailed {

	if (loadingView != nil) {
		[loadingView hide];
		loadingView = nil;
	}
	[[[[UIAlertView alloc] initWithTitle: MFLocalizedString(@"Error downloading file") message: MFLocalizedString(@"Please make sure that you are connected to the Internet, logged in and you have enough space on your device and try again.") delegate: nil cancelButtonTitle: MFLocalizedString(@"Dismiss") otherButtonTitles: nil] autorelease] show];

}

- (void) fileManagerDBUploadedFile: (NSString *) path toPath: (NSString *) path2 {

	if (loadingView != nil) {
		[loadingView hide];
		loadingView = nil;
	}

}

- (void) fileManagerDBUploadProgress: (float) progress forFile: (NSString *) path {

	[loadingView setProgress: progress];

}

- (void) fileManagerDBUploadFileFailed {

	if (loadingView != nil) {
		[loadingView hide];
		loadingView = nil;
	}
	[[[[UIAlertView alloc] initWithTitle: MFLocalizedString(@"Error uploading file") message: MFLocalizedString(@"Please make sure that you are connected to the Internet, logged in and the file to be uploaded doesn't exist yet and try again.") delegate: nil cancelButtonTitle: MFLocalizedString(@"Dismiss") otherButtonTitles: nil] autorelease] show];

}

- (void) fileManagerDBDeletedFile: (NSString *) path {

	if (loadingView != nil) {
		[loadingView hide];
		loadingView = nil;
	}

}

- (void) fileManagerDBDeleteFileFailed {

	if (loadingView != nil) {
		[loadingView hide];
		loadingView = nil;
	}
	[[[[UIAlertView alloc] initWithTitle: MFLocalizedString(@"Error deleting file") message: MFLocalizedString(@"Please make sure that you are connected to the Internet, logged in and the file to be deleted exists and try again.") delegate: nil cancelButtonTitle: MFLocalizedString(@"Dismiss") otherButtonTitles: nil] autorelease] show];

}

- (void) fileManagerDBCreatedDirectory: (NSString *) path {

	if (loadingView != nil) {
		[loadingView hide];
		loadingView = nil;
	}
	[self loadMetadata: currentDirectory];

}

- (void) fileManagerDBCreateDirectoryFailed {

	if (loadingView != nil) {
		[loadingView hide];
		loadingView = nil;
	}
	[[[[UIAlertView alloc] initWithTitle: MFLocalizedString(@"Error creating folder") message: MFLocalizedString(@"Please make sure that you are connected to the Internet, logged in and the folder to be created doesn't yet exist and try again.") delegate: nil cancelButtonTitle: MFLocalizedString(@"Dismiss") otherButtonTitles: nil] autorelease] show];

}

@end


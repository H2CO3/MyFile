//
// MFMainController.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <Foundation/Foundation.h>
#import "MFBookmarksController.h"
#import "MFDetailsController.h"
#import "MFDropboxController.h"
#import "MFFileSharingController.h"
#import "MFFileViewerController.h"
#import "MFNewFileController.h"
#import "MFPasteController.h"
#import "MFSFTPController.h"
#import "MFSettingsController.h"
#import "MFMyPodPlaylistsController.h"
#import "MFMyPodAlbumsController.h"
#import "MFMyPodArtistsController.h"
#import "MFMyPodSongsController.h"
#import "MFMainController.h"

@implementation MFMainController

@synthesize fileManager = fileManager;

// super

- (id) init {

	self = [super init];
	
	self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	self.fileManager = [[MFFileManager alloc] init];
	if ([[NSUserDefaults standardUserDefaults] boolForKey: @"MFAlwaysGoHome"]) {
		currentDirectory = [[NSUserDefaults standardUserDefaults] objectForKey: @"MFHomeDirectory"];
	} else {
		currentDirectory = [[NSUserDefaults standardUserDefaults] objectForKey: @"MFLastOpenedDirectory"];
	}
	if (currentDirectory == nil) {
		currentDirectory = @"/var/mobile";
	}
	files = [[NSMutableArray alloc] init];
	[files addObjectsFromArray: [self.fileManager contentsOfDirectory: currentDirectory]];
	self.title = [currentDirectory lastPathComponent];
	self.view.backgroundColor = [UIColor whiteColor];
	
	fileIndex = -1;
	
	searchResult = [[NSMutableArray alloc] init];

	UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"upbutton.png"] style: UIBarButtonItemStyleBordered target: self action: @selector(leftButtonPressed)];
	self.navigationItem.leftBarButtonItem = leftButton;
	[leftButton release];

	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCompose target: self action: @selector(rightButtonPressed)];
	self.navigationItem.rightBarButtonItem = rightButton;
	[rightButton release];
	
	searchBar = [[UISearchBar alloc] initWithFrame: CGRectMake (0, 62, 320, 48)];
	searchBar.placeholder = MFLocalizedString(@"Enter filename");
	searchBar.barStyle = UIBarStyleBlack;
	searchBar.showsCancelButton = YES;
	searchBar.delegate = self;
	self.tableView.tableHeaderView = searchBar;
	
	footerLabel = [[UILabel alloc] initWithFrame: CGRectMake (0, 0, 320, 44)];
	footerLabel.textColor = [UIColor lightGrayColor];
	footerLabel.textAlignment = UITextAlignmentCenter;
	footerLabel.text = [NSString stringWithFormat: MFLocalizedString(@"%i item(s); %@ free"), [files count], [fileManager freeSpace: currentDirectory]];
	self.tableView.tableFooterView = footerLabel;
	
	toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake (0, 412, 320, 48)];
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: NULL];
	UIBarButtonItem *toolbarItem_0 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target: self action: @selector(createFile)];
	UIBarButtonItem *toolbarItem_1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAction target: self action: @selector(showAction)];
	UIBarButtonItem *toolbarItem_2 = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"dropboxbutton.png"] style: UIBarButtonItemStylePlain target: self action: @selector(showDropbox)];
	UIBarButtonItem *toolbarItem_3 = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"homebutton.png"] style: UIBarButtonItemStylePlain target: self action: @selector(goHome)];
	UIBarButtonItem *toolbarItem_4 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemBookmarks target: self action: @selector(showBookmarks)];
	NSArray *toolbarItems = [NSArray arrayWithObjects: toolbarItem_0, flexItem, toolbarItem_1, flexItem, toolbarItem_2, flexItem, toolbarItem_3, flexItem, toolbarItem_4, nil];
	toolbar.barStyle = UIBarStyleBlack;
	toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
	[toolbar setItems: toolbarItems animated: YES];
	[self.view addSubview: toolbar];

	bookmarksController = [[MFBookmarksController alloc] init];
	bookmarksController.mainController = self;
	detailsController = nil;
	dropboxController = [[MFDropboxController alloc] init];
	dropboxController.mainController = self;
	fileViewerController = nil;
	newFileController = [[MFNewFileController alloc] init];
	newFileController.mainController = self;
	pasteController = [[MFPasteController alloc] init];
	pasteController.mainController = self;
	settingsController = [[MFSettingsController alloc] init];
	fileSharingController = [[MFFileSharingController alloc] init];
	sftpController = [[MFSFTPController alloc] init];

	myPodController = [[UITabBarController alloc] init];
        myPodController.navigationItem.title = @"MyPod";
        myPodController.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(closeMyPod)] autorelease];
	MFMyPodPlaylistsController *playlistsController = [[MFMyPodPlaylistsController alloc] init];
	MFMyPodAlbumsController *albumsController = [[MFMyPodAlbumsController alloc] init];
	MFMyPodArtistsController *artistsController = [[MFMyPodArtistsController alloc] init];
	MFMyPodSongsController *songsController = [[MFMyPodSongsController alloc] init];
	myPodController.viewControllers = [NSArray arrayWithObjects: playlistsController, albumsController, artistsController, songsController, nil];
	myPodController.selectedIndex = 0;
	[playlistsController release];
	[albumsController release];
	[artistsController release];
	[songsController release];
	
	sheet = [[UIActionSheet alloc] init];
	sheet.title = MFLocalizedString(@"Miscellaneous");
	sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	sheet.delegate = self;
	sheet.cancelButtonIndex = 5;
	[sheet addButtonWithTitle: MFLocalizedString(@"Settings")];
	[sheet addButtonWithTitle: MFLocalizedString(@"File sharing")];
	[sheet addButtonWithTitle: MFLocalizedString(@"Paste file(s)")];
	[sheet addButtonWithTitle: MFLocalizedString(@"MyPod")];
	[sheet addButtonWithTitle: MFLocalizedString(@"Trash")];
	[sheet addButtonWithTitle: MFLocalizedString(@"Cancel")];
	
	operations = [[UIActionSheet alloc] init];
	operations.title = MFLocalizedString(@"File operations");
	operations.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	operations.delegate = self;
	operations.cancelButtonIndex = 6;
	[operations addButtonWithTitle: MFLocalizedString(@"Delete")];
	[operations addButtonWithTitle: MFLocalizedString(@"Copy")];
	[operations addButtonWithTitle: MFLocalizedString(@"Cut")];
	[operations addButtonWithTitle: MFLocalizedString(@"Symlink")];
	[operations addButtonWithTitle: MFLocalizedString(@"Add to Queue")];
	[operations addButtonWithTitle: MFLocalizedString(@"Add bookmark")];
	[operations addButtonWithTitle: MFLocalizedString(@"Cancel")];

	sharing = [[UIActionSheet alloc] init];
	sharing.title = MFLocalizedString(@"File sharing");
	sharing.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	sharing.delegate = self;
	sharing.cancelButtonIndex = 2;
	[sharing addButtonWithTitle: MFLocalizedString(@"HTTP server")];
	[sharing addButtonWithTitle: MFLocalizedString(@"SFTP/SCP")];
	[sharing addButtonWithTitle: MFLocalizedString(@"Cancel")];
	
	trash = [[UIActionSheet alloc] init];
	trash.title = MFLocalizedString(@"Trash operations");
	trash.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	trash.delegate = self;
	trash.cancelButtonIndex = 2;
	[trash addButtonWithTitle: MFLocalizedString(@"Go to trash")];
	[trash addButtonWithTitle: MFLocalizedString(@"Empty trash")];
	[trash addButtonWithTitle: MFLocalizedString(@"Cancel")];

	return self;

}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orientation {

	return (orientation == UIInterfaceOrientationPortrait) || (orientation == UIInterfaceOrientationLandscapeRight);

}

- (void) refresh {

	[self performSelector: @selector(reloadDirectory) withObject: nil afterDelay: 0.0];
	
}

- (void) dealloc {

	[fileManager release];
	fileManager = nil;
	[files release];
	files = nil;
	[sheet release];
	sheet = nil;
	[operations release];
	operations = nil;
	[sharing release];
	sharing = nil;
	[trash release];
	trash = nil;
	currentDirectory = nil;
	[searchResult release];
	searchResult = nil;
	[toolbar release];
	toolbar = nil;
	[footerLabel release];
	footerLabel = nil;
	[bookmarksController release];
	bookmarksController = nil;
	[pasteController release];
	pasteController = nil;
	[dropboxController release];
	dropboxController = nil;
	[settingsController release];
	settingsController = nil;
	[newFileController release];
	newFileController = nil;
	[fileSharingController release];
	fileSharingController = nil;
	[sftpController release];
	sftpController = nil;
	[myPodController release];
	myPodController = nil;
	
	[super dealloc];

}

// self

- (NSString *) currentDirectory {

	return currentDirectory;
	
}

- (void) leftButtonPressed {

	[self loadDirectory: [currentDirectory stringByDeletingLastPathComponent]];

}

- (void) rightButtonPressed {

	[pasteController presentFrom: self];

}

- (void) loadDirectory: (NSString *) path {

	currentDirectory = path;
	self.title = [path lastPathComponent];
	[files removeAllObjects];
	[files addObjectsFromArray: [self.fileManager contentsOfDirectory: path]];
	footerLabel.text = [NSString stringWithFormat: MFLocalizedString(@"%i item(s); %@ free"), [files count], [fileManager freeSpace: currentDirectory]];

	[self.tableView reloadData];
	[[NSUserDefaults standardUserDefaults] setObject: path forKey: @"MFLastOpenedDirectory"];
	[[NSUserDefaults standardUserDefaults] synchronize];

}

- (void) showFile: (MFFile *) f {

	if ([f.type isEqualToString: @"file"]) {
		// unknown filetype
		MFUnknownFileController *unknownFileController = [[MFUnknownFileController alloc] initWithFile: f];
		[unknownFileController presentFrom: self];
		[unknownFileController release];
	} else {
		// known filetype
		fileViewerController = [[MFFileViewerController alloc] initWithFile: f];
		fileViewerController.delegate = self;
		[fileViewerController presentFrom: self];
		[fileViewerController release];
	}

}

- (void) reloadDirectory {

	[self loadDirectory: currentDirectory];
	[self stopLoading];

}

- (void) createFile {

	newFileController.path = currentDirectory;
	[newFileController presentFrom: self];
	
}

- (void) showAction {

	[sheet showInView: self.view];
	
}

- (void) showDropbox {

	self.fileManager.delegate = dropboxController;
	[dropboxController presentFrom: self];
	
}

- (void) goHome {

	NSString *homeDirectory = [[NSUserDefaults standardUserDefaults] stringForKey: @"MFHomeDirectory"];
	if ((homeDirectory == nil) || ([homeDirectory length] == 0)) {
		homeDirectory = @"/var/mobile";
	}
	[self loadDirectory: homeDirectory];
	
}
	
- (void) showBookmarks {

	[bookmarksController presentFrom: self];
	
}

- (void) closeMyPod {
        [self dismissModalViewControllerAnimated: YES];
}

// UITableViewDataSource

- (int) tableView: (UITableView *) theTableView numberOfRowsInSection: (int) section {

	return [files count];

}

- (NSString *) tableView: (UITableView *) theTableView titleForHeaderInSection: (int) section {

	return currentDirectory;

}

- (UITableViewCell *) tableView: (UITableView *) theTableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier: @"MFMainControllerCell"];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: @"MFMainControllerCell"] autorelease];
	}
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	cell.imageView.image = [[files objectAtIndex: indexPath.row] isDirectory] ? [UIImage imageNamed: @"dir.png"] : [MFFileType imageForType: [[files objectAtIndex: indexPath.row] type]];
	cell.textLabel.text = [[files objectAtIndex: indexPath.row] name];
	if (([currentDirectory isEqualToString: @"/var/mobile/Applications"] || [currentDirectory isEqualToString: @"/User/Applications"] || [currentDirectory isEqualToString: @"/private/var/mobile/Applications"]) && ([[files objectAtIndex: indexPath.row] isDirectory])) {
		NSArray *appFiles = [self.fileManager contentsOfDirectory: [currentDirectory stringByAppendingPathComponent: [[files objectAtIndex: indexPath.row] name]]];
		NSString *appDir = nil;
		for (int i = 0; i < [appFiles count]; i++) {
			if ([[[appFiles objectAtIndex: i] name] hasSuffix: @".app"]) {
				appDir = [@"/var/mobile/Applications" stringByAppendingPathComponent: [[[files objectAtIndex: indexPath.row] name] stringByAppendingPathComponent: [[appFiles objectAtIndex: i] name]]];
				break;
			}
		}
		NSDictionary *infoPlist = [[NSDictionary alloc] initWithContentsOfFile: [appDir stringByAppendingPathComponent: @"Info.plist"]];
		NSString *appName = [infoPlist objectForKey: @"CFBundleDisplayName"];
		cell.detailTextLabel.text = [NSString stringWithFormat: MFLocalizedString(@"Application: %@"), appName];
		[infoPlist release];
	} else if ([[files objectAtIndex: indexPath.row] isSymlink]) {
		char *buf = malloc (sizeof (char) * 256);
		int bytes = readlink ([[[files objectAtIndex: indexPath.row] fullPath] UTF8String], buf, 255);
		buf[bytes] = '\0';
		cell.detailTextLabel.text = [NSString stringWithUTF8String: buf];
		free (buf);
	} else {
		if ([[files objectAtIndex: indexPath.row] isDirectory]) {
			unsigned items = [fileManager numberOfItemsInDirectory: [[files objectAtIndex: indexPath.row] fullPath]];
			cell.detailTextLabel.text = [NSString stringWithFormat: (items == 1 ? MFLocalizedString(@"%i item; permissions: %@") : MFLocalizedString(@"%i items; permissions: %@")), items, [[files objectAtIndex: indexPath.row] permissions]];
		} else {
			cell.detailTextLabel.text = [NSString stringWithFormat: MFLocalizedString(@"Size: %@, permissions: %@"), [[files objectAtIndex: indexPath.row] fsize], [[files objectAtIndex: indexPath.row] permissions]];
		}
	}
	if ([[files objectAtIndex: indexPath.row] isSymlink]) {
		cell.textLabel.textColor = [UIColor colorWithRed: 0.1 green: 0.3 blue: 1.0 alpha: 1.0];
	} else {
		cell.textLabel.textColor = [UIColor blackColor];
	}

	return cell;

}

// UITableViewDelegate

- (void) tableView: (UITableView *) theTableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

	[theTableView deselectRowAtIndexPath: indexPath animated: YES];

	if ([[files objectAtIndex: indexPath.row] isDirectory]) {

		[self loadDirectory: [currentDirectory stringByAppendingPathComponent: [[files objectAtIndex: indexPath.row] name]]];

	} else {

		[self showFile: [files objectAtIndex: indexPath.row]];

	}

}

- (void) tableView: (UITableView *) theTableView accessoryButtonTappedForRowWithIndexPath: (NSIndexPath *) indexPath {

	detailsController = [[MFDetailsController alloc] initWithFile: [files objectAtIndex: indexPath.row]];
	detailsController.mainController = self;
	self.fileManager.delegate = detailsController;
	[detailsController presentFrom: self];
	[detailsController release];

}

- (NSString *) tableView: (UITableView *) theTableView titleForDeleteConfirmationButtonForRowAtIndexPath: (NSIndexPath *) indexPath {

	return MFLocalizedString(@"Options");
	
}

- (void) tableView: (UITableView *) theTableView commitEditingStyle: (UITableViewCellEditingStyle) style forRowAtIndexPath: (NSIndexPath *) indexPath {

	[operations showInView: self.view];
	fileIndex = indexPath.row;

}

// UIActionSheetDelegate

- (void) actionSheet: (UIActionSheet *) actionSheet didDismissWithButtonIndex: (int) index {

	if (actionSheet == sheet) {

		if (index == 0) {
			[settingsController presentFrom: self];
		} else if (index == 1) {
			[sharing showInView: self.view];
		} else if (index == 2) {
		
			if ([[MFPasteManager sharedManager] state] == MFPasteManagerStateCut) {
				for (int i = 0; i < [[[UIPasteboard generalPasteboard] strings] count]; i++) {
					[self.fileManager moveFile: [[[UIPasteboard generalPasteboard] strings] objectAtIndex: i] toPath: [currentDirectory stringByAppendingPathComponent: [[[[UIPasteboard generalPasteboard] strings] objectAtIndex: i] lastPathComponent]]];
				}
			} else if ([[MFPasteManager sharedManager] state] == MFPasteManagerStateSymlink) {
				for (int i = 0; i < [[[UIPasteboard generalPasteboard] strings] count]; i++) {
					[self.fileManager linkFile: [[[UIPasteboard generalPasteboard] strings] objectAtIndex: i] toPath: [currentDirectory stringByAppendingPathComponent: [[[[UIPasteboard generalPasteboard] strings] objectAtIndex: i] lastPathComponent]]];
				}
			} else if ([[MFPasteManager sharedManager] state] == MFPasteManagerStateCopy) {
				for (int i = 0; i < [[[UIPasteboard generalPasteboard] strings] count]; i++) {
					[self.fileManager copyFile: [[[UIPasteboard generalPasteboard] strings] objectAtIndex: i] toPath: [currentDirectory stringByAppendingPathComponent: [[[[UIPasteboard generalPasteboard] strings] objectAtIndex: i] lastPathComponent]]];
				}
			}

			[self reloadDirectory];

		} else if (index == 3) {

			// show MyPod
                        UINavigationController *myPodNavController = [[UINavigationController alloc] initWithRootViewController: myPodController];
                        myPodNavController.navigationBar.barStyle = UIBarStyleBlack;
			[self presentModalViewController: myPodNavController animated: YES];
                        [myPodNavController release];
			
		} else if (index == 4) {
		
			[trash showInView: self.view];
			
		} else {

			return;

		}
		
	} else if (actionSheet == operations) {
	
		if (index == 0) {
		
			[self.fileManager deleteFile: [[files objectAtIndex: fileIndex] fullPath]];
			[files removeObjectAtIndex: fileIndex];
			footerLabel.text = [NSString stringWithFormat: MFLocalizedString(@"%i item(s); %@ free"), [files count], [fileManager freeSpace: currentDirectory]];
			[self.tableView deleteRowsAtIndexPaths: [NSArray arrayWithObject: [NSIndexPath indexPathForRow: fileIndex inSection: 0]] withRowAnimation: UITableViewRowAnimationRight];
			
		} else if (index == 1) {
		
			[[UIPasteboard generalPasteboard] setStrings: [NSArray arrayWithObject: [[files objectAtIndex: fileIndex] fullPath]]];
			[[MFPasteManager sharedManager] setState: MFPasteManagerStateCopy];
			
		} else if (index == 2) {
		
			[[UIPasteboard generalPasteboard] setStrings: [NSArray arrayWithObject: [[files objectAtIndex: fileIndex] fullPath]]];
			[[MFPasteManager sharedManager] setState: MFPasteManagerStateCut];
			
		} else if (index == 3) {
		
			[[UIPasteboard generalPasteboard] setStrings: [NSArray arrayWithObject: [[files objectAtIndex: fileIndex] fullPath]]];
			[[MFPasteManager sharedManager] setState: MFPasteManagerStateSymlink];
			
		} else if (index == 4) {
		
			[pasteController addFile: [files objectAtIndex: fileIndex]];

		} else if (index == 5) {

			[bookmarksController addFile: [[files objectAtIndex: fileIndex] fullPath]];
			
		} else {
		
			return;
			
		}
		
	} else if (actionSheet == sharing) {

		if (index == 0) {

			[fileSharingController presentFrom: self];

		} else if (index == 1) {

			[sftpController presentFrom: self];

		} else {

			return;

		}

	} else if (actionSheet == trash) {
	
		if (index == 0) {
		
			[self loadDirectory: @"/var/mobile/Library/MyFile/Trash"];
			
		} else if (index == 1) {
		
			UIAlertView *av = [[UIAlertView alloc] init];
			av.title = MFLocalizedString(@"Confirm deletion");
			av.message = MFLocalizedString(@"Are you sure you want to empty the trash?");
			av.delegate = self;
			[av addButtonWithTitle: MFLocalizedString(@"No")];
			[av addButtonWithTitle: MFLocalizedString(@"Yes")];
			[av show];
			[av release];
			
		}
		
	}

}

// UIAlertViewDelegate

- (void) alertView: (UIAlertView *) alertView didDismissWithButtonIndex: (int) index {

	if (index == 1) {
		system ("rm -rf /var/mobile/Library/MyFile/Trash/*");
		[self reloadDirectory];
	}
	
}

// UISearchBarDelegate

- (void) searchBarSearchButtonClicked: (UISearchBar *) bar {

	[bar resignFirstResponder];
	
	[self reloadDirectory];
	
	for (int i = 0; i < [files count]; i++) {
		NSRange textRange;
		textRange = [[[[files objectAtIndex: i] name] lowercaseString] rangeOfString: [bar.text lowercaseString]];
		if (textRange.location != NSNotFound) {
			[searchResult addObject: [files objectAtIndex: i]];
		}
	}
	
	[files removeAllObjects];
	[files addObjectsFromArray: searchResult];
	[searchResult removeAllObjects];
	[self.tableView reloadData];
	
}

- (void) searchBarCancelButtonClicked: (UISearchBar *) bar {

	[bar resignFirstResponder];
	[self reloadDirectory];

}

// MFFileViewerControllerDelegate

- (void) fileViewerDidFinishViewing: (MFFileViewerController *) fileViewer {

	[self reloadDirectory];

}

@end


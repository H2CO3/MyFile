//
// MFDetailsController.m
// MyFile
//
// Created by Àrpád Goretity, 2011.
//

#import <MFMusicLibrary/MFMusicLibrary.h>
#import "MFDetailsController.h"
#import "MFMainController.h"
#import "MFTextAlert.h"
#import "PTTagViewController.h"

#undef MFLocalizedString
#define MFLocalizedString(x) (NSLocalizedString((x), @""))


@implementation MFDetailsController

@synthesize file = file;
@synthesize mainController = mainController;

// super

- (void) dealloc {

	[sections release];
	sections = nil;

	[super dealloc];
	
}

// self

- (id) initWithFile: (MFFile *) aFile {

	self = [super init];
	
	self.file = aFile;
	self.title = self.file.name;

	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(done)];
	self.navigationItem.rightBarButtonItem = rightButton;
	[rightButton release];
	
	fileQueueCount = 0;

	newName = [[UITextField alloc] initWithFrame: CGRectMake (0, 15, DETAILS_LABEL_WIDTH, 30)];
	newName.placeholder = MFLocalizedString(@"Enter filename");
	newName.text = self.file.name;
	newName.delegate = self;
	newName.autocapitalizationType = UITextAutocapitalizationTypeNone;
	newName.autocorrectionType = UITextAutocorrectionTypeNo;
	newName.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	newChmod = [[UITextField alloc] initWithFrame: CGRectMake (0, 15, DETAILS_LABEL_WIDTH, 30)];
	newChmod.placeholder = MFLocalizedString(@"Enter file mode");
	newChmod.text = self.file.permissions;
	newChmod.delegate = self;
	newChmod.autocapitalizationType = UITextAutocapitalizationTypeNone;
	newChmod.autocorrectionType = UITextAutocorrectionTypeNo;
	newChmod.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	newUID = [[UITextField alloc] initWithFrame: CGRectMake (0, 15, DETAILS_LABEL_WIDTH, 30)];
	newUID.placeholder = MFLocalizedString(@"Enter user ID");
	newUID.text = self.file.owner;
	newUID.delegate = self;
	newUID.autocapitalizationType = UITextAutocapitalizationTypeNone;
	newUID.autocorrectionType = UITextAutocorrectionTypeNo;
	newUID.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	newGID = [[UITextField alloc] initWithFrame: CGRectMake (0, 15, DETAILS_LABEL_WIDTH, 30)];
	newGID.placeholder = MFLocalizedString(@"Enter group ID");
	newGID.text = self.file.group;
	newGID.delegate = self;
	newGID.autocapitalizationType = UITextAutocapitalizationTypeNone;
	newGID.autocorrectionType = UITextAutocorrectionTypeNo;
	newGID.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	sizeLabel = [[UILabel alloc] initWithFrame: CGRectMake (0, 15, DETAILS_LABEL_WIDTH, 30)];
	sizeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	sizeLabel.text = [NSString stringWithFormat: @"%i", self.file.bytessize];

	mimeLabel = [[UILabel alloc] initWithFrame: CGRectMake (0, 15, DETAILS_LABEL_WIDTH, 30)];
	mimeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	mimeLabel.text = self.file.mime;

	md5Label = [[UILabel alloc] initWithFrame: CGRectMake (0, 15, DETAILS_LABEL_WIDTH, 30)];
	md5Label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	md5Label.text = MFLocalizedString(@"Calculating...");

	fileLabel = [[UILabel alloc] initWithFrame: CGRectMake (0, 15, DETAILS_LABEL_WIDTH, 30)];
	fileLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	fileLabel.text = MFLocalizedString(@"Running...");

	atimeLabel = [[UILabel alloc] initWithFrame: CGRectMake (0, 15, DETAILS_LABEL_WIDTH, 30)];
	atimeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	atimeLabel.text = file.atime;

	mtimeLabel = [[UILabel alloc] initWithFrame: CGRectMake (0, 15, DETAILS_LABEL_WIDTH, 30)];
	mtimeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	mtimeLabel.text = file.mtime;

	tableView = [[UITableView alloc] initWithFrame: UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? [[UIScreen mainScreen] applicationFrame] : CGRectMake (0, 0, 320, 460) style: UITableViewStyleGrouped];
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	tableView.delegate = self;
	tableView.dataSource = self;
	[self.view addSubview: tableView];
	[tableView release];
	
	sections = [[NSMutableArray alloc] init];
	
	section0 = [[NSMutableArray alloc] init];
	section1 = [[NSMutableArray alloc] init];
	section2 = [[NSMutableArray alloc] init];
	section3 = [[NSMutableArray alloc] init];

	tempCell = [[UITableViewCell alloc] initWithStyle: 0 reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = MFLocalizedString(@"Permissions");
	tempCell.accessoryView = newChmod;
	[newChmod release];
	[section0 addObject: tempCell];
	[tempCell release];
	
	tempCell = [[UITableViewCell alloc] initWithStyle: 0 reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = MFLocalizedString(@"Size");
	tempCell.accessoryView = sizeLabel;
	[sizeLabel release];
	[section0 addObject: tempCell];
	[tempCell release];
	
	tempCell = [[UITableViewCell alloc] initWithStyle: 0 reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = MFLocalizedString(@"Name");
	tempCell.accessoryView = newName;
	[newName release];
	[section0 addObject: tempCell];
	[tempCell release];

	tempCell = [[UITableViewCell alloc] initWithStyle: 0 reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = MFLocalizedString(@"User ID");
	tempCell.accessoryView = newUID;
	[newUID release];
	[section0 addObject: tempCell];
	[tempCell release];

	tempCell = [[UITableViewCell alloc] initWithStyle: 0 reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = MFLocalizedString(@"Group ID");
	tempCell.accessoryView = newGID;
	[newGID release];
	[section0 addObject: tempCell];
	[tempCell release];

	tempCell = [[UITableViewCell alloc] initWithStyle: 0 reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = MFLocalizedString(@"Access time");
	tempCell.accessoryView = atimeLabel;
	[atimeLabel release];
	[section0 addObject: tempCell];
	[tempCell release];

	tempCell = [[UITableViewCell alloc] initWithStyle: 0 reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = MFLocalizedString(@"Modification time");
	tempCell.accessoryView = mtimeLabel;
	[mtimeLabel release];
	[section0 addObject: tempCell];
	[tempCell release];

	tempCell = [[UITableViewCell alloc] initWithStyle: 0 reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = MFLocalizedString(@"MIME type");
	tempCell.accessoryView = mimeLabel;
	[mimeLabel release];
	[section0 addObject: tempCell];
	[tempCell release];

	tempCell = [[UITableViewCell alloc] initWithStyle: 0 reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = MFLocalizedString(@"MD5 hash");
	tempCell.accessoryView = md5Label;
	[md5Label release];
	[section0 addObject: tempCell];
	[tempCell release];
	
	tempCell = [[UITableViewCell alloc] initWithStyle: 0 reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = MFLocalizedString(@"'file' command");
	tempCell.accessoryView = fileLabel;
	[fileLabel release];
	[section0 addObject: tempCell];
	[tempCell release];

	tempCell = [[UITableViewCell alloc] initWithStyle: 0 reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = MFLocalizedString(@"Upload file to Dropbox");
	[section1 addObject: tempCell];
	[tempCell release];

	tempCell = [[UITableViewCell alloc] initWithStyle: 0 reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = MFLocalizedString(@"Share on Facebook");
	[section1 addObject: tempCell];
	[tempCell release];

	tempCell = [[UITableViewCell alloc] initWithStyle: 0 reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = MFLocalizedString(@"Share on Twitter");
	[section1 addObject: tempCell];
	[tempCell release];

	tempCell = [[UITableViewCell alloc] initWithStyle: 0 reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = MFLocalizedString(@"Web browser");
	[section2 addObject: tempCell];
	[tempCell release];

	tempCell = [[UITableViewCell alloc] initWithStyle: 0 reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = MFLocalizedString(@"Image viewer");
	[section2 addObject: tempCell];
	[tempCell release];

	tempCell = [[UITableViewCell alloc] initWithStyle: 0 reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = MFLocalizedString(@"Audio player");
	[section2 addObject: tempCell];
	[tempCell release];

	tempCell = [[UITableViewCell alloc] initWithStyle: 0 reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = MFLocalizedString(@"Movie player");
	[section2 addObject: tempCell];
	[tempCell release];

	tempCell = [[UITableViewCell alloc] initWithStyle: 0 reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = MFLocalizedString(@"Text editor");
	[section2 addObject: tempCell];
	[tempCell release];

	tempCell = [[UITableViewCell alloc] initWithStyle: 0 reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = MFLocalizedString(@"Archive manager");
	[section2 addObject: tempCell];
	[tempCell release];

	tempCell = [[UITableViewCell alloc] initWithStyle: 0 reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = MFLocalizedString(@"Property list viewer");
	[section2 addObject: tempCell];
	[tempCell release];

	tempCell = [[UITableViewCell alloc] initWithStyle: 0 reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = MFLocalizedString(@"SQL viewer");
	[section2 addObject: tempCell];
	[tempCell release];
	
	tempCell = [[UITableViewCell alloc] initWithStyle: 0 reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = MFLocalizedString(@"Hex editor");
	[section2 addObject: tempCell];
	[tempCell release];
	
	tempCell = [[UITableViewCell alloc] initWithStyle: 0 reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = MFLocalizedString(@"Send by e-mail");
	[section2 addObject: tempCell];
	[tempCell release];

	tempCell = [[UITableViewCell alloc] initWithStyle: 0 reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = MFLocalizedString(@"Compress");
	[section3 addObject: tempCell];
	[tempCell release];

	tempCell = [[UITableViewCell alloc] initWithStyle: 0 reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = MFLocalizedString(@"Preview and print");
	[section3 addObject: tempCell];
	[tempCell release];
	
	tempCell = [[UITableViewCell alloc] initWithStyle: 0 reuseIdentifier: @"MFDCTempCell"];
	if ([self.file.type isEqualToString: @"sound"]) {
		tempCell.text = MFLocalizedString(@"Add to iPod");
	} else if ([self.file.type isEqualToString: @"image"]) {
		tempCell.text = MFLocalizedString(@"Add to Camera Roll");
	} else if ([self.file.type isEqualToString: @"video"]) {
		tempCell.text = MFLocalizedString(@"Add to Camera Roll");
	}
	[section3 addObject: tempCell];
	[tempCell release];
	
	// for videos only
	tempCell = [[UITableViewCell alloc] initWithStyle: 0 reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = MFLocalizedString(@"Add to iPod");
	[section3 addObject: tempCell];
	[tempCell release];

	[sections addObject: section0];
	[section0 release];
	[sections addObject: section1];
	[section1 release];
	[sections addObject: section2];
	[section2 release];
	[sections addObject: section3];
	[section3 release];
	
	if (!self.file.isDirectory) {
		[self runFile];
		MFThread *md5Calc = [[[NSThread alloc] initWithTarget: self selector: @selector(calculateMD5) object: nil] autorelease];
		[md5Calc start];
	}

	return self;
	
}

- (void) upload: (NSString *) path {

	if ([[[self mainController] fileManager] fileIsDirectory: path]) {

		[[[self mainController] fileManager] dbCreateDirectory: [[[NSUserDefaults standardUserDefaults] stringForKey: @"MFDropboxUploadPath"] stringByAppendingPathComponent: path]];
		
		NSMutableArray *contents = [[[self mainController] fileManager] contentsOfDirectory: path];
		for (int i = 0; i < [contents count]; i++) {
		
			[self upload: [[contents objectAtIndex: i] fullPath]];
			
		}

	} else {
	
		if (fileQueueCount == 0) {
			loadingView = [[MFLoadingView alloc] initWithType: MFLoadingViewTypeProgress];
			[loadingView show];
			[loadingView release];
		}
		fileQueueCount++;
		NSString *uploadPath;
		
		if ([[NSUserDefaults standardUserDefaults] boolForKey: @"MFDropboxUploadSpecific"] && (!self.file.isDirectory) && (!shareOnFacebook) && (!shareOnTwitter)) {
			if ([self.file.type isEqualToString: @"image"]) {
				uploadPath = @"/Photos";
			} else if ([self.file.type isEqualToString: @"sound"]) {
				uploadPath = @"/Music";
			} else if ([self.file.type isEqualToString: @"video"]) {
				uploadPath = @"/Videos";
			} else if ([self.file.type isEqualToString: @"package"]) {
				uploadPath = @"/Packages";
			} else {
				uploadPath = [[[self mainController] fileManager] fileIsDirectory: [self.file fullPath]] ? [[[NSUserDefaults standardUserDefaults] stringForKey: @"MFDropboxUploadPath"] stringByAppendingPathComponent: [path stringByDeletingLastPathComponent]] : [[NSUserDefaults standardUserDefaults] stringForKey: @"MFDropboxUploadPath"];
			}
		} else {
			uploadPath = [[[self mainController] fileManager] fileIsDirectory: [self.file fullPath]] ? [[[NSUserDefaults standardUserDefaults] stringForKey: @"MFDropboxUploadPath"] stringByAppendingPathComponent: [path stringByDeletingLastPathComponent]] : [[NSUserDefaults standardUserDefaults] stringForKey: @"MFDropboxUploadPath"];
		}
		
		[[[self mainController] fileManager] dbUploadFile: path toPath: uploadPath];
		
	}

}

- (void) runFile {

	NSString *cmd = [[NSString alloc] initWithFormat: @"file %@ | cut -d ':' -f 2 >/tmp/MFFileOut.txt; file --mime %@ | cut -d ':' -f 2 >>/tmp/MFFileOut.txt", [[self.file fullPath] stringByReplacingOccurrencesOfString: @" " withString: @"\\ "], [[self.file fullPath] stringByReplacingOccurrencesOfString: @" " withString: @"\\ "]];
	fileCmd = [[[MFThread alloc] init] autorelease];
	fileCmd.cmd = cmd;
	[cmd release];
	fileCmd.delegate = self;
	[fileCmd start];
	
}

- (void) calculateMD5 {

	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	md5Label.text = [NSString fileMD5: [file fullPath]];
	[tableView reloadData];
	[pool release];
	
}

- (void) done {

	if (![self.file.permissions isEqualToString: newChmod.text]) {
		[[[self mainController] fileManager] chmodFile: [self.file fullPath] permissions: newChmod.text];
	}
	if ((![self.file.owner isEqualToString: newUID.text]) || (![self.file.group isEqualToString: newGID.text])) {
		[[[self mainController] fileManager] chownFile: [self.file fullPath] user: newUID.text group: newGID.text];
	}
	if (![self.file.name isEqualToString: newName.text]) {	
		[[[self mainController] fileManager] moveFile: [self.file fullPath] toPath: [self.file.path stringByAppendingPathComponent: newName.text]];
	}
		
	[[self mainController] reloadDirectory];
	[self close];

}

// QLPreviewControllerDelegate

- (id) previewController: (QLPreviewController *) pc previewItemAtIndex: (int) idx {

	return [file fileUrl];

}

- (int) numberOfPreviewItemsInPreviewController: (QLPreviewController *) pc {

	return 1;

}

// UIAlertViewDelegate

- (void) alertView: (UIAlertView *) av didDismissWithButtonIndex: (int) index {
	MFTextAlert *ta = (MFTextAlert *) av;
	if (index == 0) {
		// user pressed 'OK', send to Twitter
		[[[MFSocialManager sharedManager] twitter] sendUpdate: ta.textField.text];
		[[[[UIAlertView alloc] initWithTitle: MFLocalizedString(@"Tweet sent") message: MFLocalizedString(@"Public link was shared on Twitter.") delegate: nil cancelButtonTitle: MFLocalizedString(@"Dismiss") otherButtonTitles: nil] autorelease] show];
	} else {
		// user pressed 'Cancel', so nothing to do
	}
}

// UITableViewDataSource

- (int) numberOfSectionsInTableView: (UITableView *) theTableView {

	return self.file.isDirectory ? 4 : 5;
	
}

- (int) tableView: (UITableView *) theTableView numberOfRowsInSection: (int) section {

	int nRows;
	
	if (section == 0) {
		nRows = self.file.isDirectory ? 7 : 10;
	} else if (section == 1) {
		nRows = self.file.isDirectory ? 1 : 3;
	} else if (section == 2) {
		nRows = self.file.isDirectory ? 0 : 10;
	} else if (section == 3) {
		if (self.file.isDirectory) {
			nRows = 1;
		} else if ([self.file.type isEqualToString: @"image"]) {
			nRows = 3;
		} else if ([self.file.type isEqualToString: @"sound"]) {
			nRows = 3;
		} else if ([self.file.type isEqualToString: @"video"]) {
			nRows = 4;
		} else {
			nRows = 2;
		}
	} else if (section == 4) {
	       nRows = [[MFPluginManager sharedInstance] numberOfPlugins];
	}
	
	return nRows;
	
}

- (NSString *) tableView: (UITableView *) theTableView titleForHeaderInSection: (int) section {

	NSString *title;

	if (section == 0) {
		title = MFLocalizedString(@"General");
	} else if (section == 1) {
		title = MFLocalizedString(self.file.isDirectory ? @"Dropbox" : @"Social");
	} else if (section == 2) {
		title = self.file.isDirectory ? nil : MFLocalizedString(@"Open with...");
	} else if (section == 3) {
		title = MFLocalizedString(@"Miscellaneous");
	} else if (section == 4) {
		title = MFLocalizedString(@"Installed extensions");
	}
	
	return title;
	
}

- (UITableViewCell *) tableView: (UITableView *) theTableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {
	UITableViewCell *cell = nil;
	if (indexPath.section != 4) {
		cell = [[sections objectAtIndex: indexPath.section] objectAtIndex: indexPath.row];
	} else {
		cell = [theTableView dequeueReusableCellWithIdentifier: @"MFAllPluginsCell"];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: @"MFAllPluginsCell"] autorelease];
		}
		cell.textLabel.text = [[[MFPluginManager sharedInstance] pluginAtIndex: indexPath.row] name];
		cell.detailTextLabel.text = [[[MFPluginManager sharedInstance] pluginAtIndex: indexPath.row] description];
	}
	return cell;
}

// UITableViewDelegate

- (void) tableView: (UITableView *) theTableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

	[theTableView deselectRowAtIndexPath: indexPath animated: YES];

	if (indexPath.section == 0) {
	
		if (indexPath.row == 9) {
		
			// Show full output of 'file' command
			UIAlertView *av = [[UIAlertView alloc] init];
			av.title = MFLocalizedString(@"'file' command");
			av.message = [(UILabel *)[(UITableViewCell *)[theTableView cellForRowAtIndexPath: indexPath] accessoryView] text];
			[av addButtonWithTitle: MFLocalizedString(@"Dismiss")];
			[av show];
			[av release];
			
		}

	} else if (indexPath.section == 1) {
	
		if (indexPath.row == 0) {
	
			[self upload: [self.file fullPath]];
			
		} else if (indexPath.row == 1) {

			shareOnFacebook = YES;
			[self upload: [self.file fullPath]];
			
		} else if (indexPath.row == 2) {

			shareOnTwitter = YES;
			[self upload: [self.file fullPath]];

		}
		
	} else if (indexPath.section == 2) {
	
		if (indexPath.row == 0) {
		
			fileViewerController = [[MFFileViewerController alloc] initWithFile: self.file type: @"html"];
			
		} else if (indexPath.row == 1) {
		
			fileViewerController = [[MFFileViewerController alloc] initWithFile: self.file type: @"image"];
			
		} else if (indexPath.row == 2) {
		
			fileViewerController = [[MFFileViewerController alloc] initWithFile: self.file type: @"sound"];
			
		} else if (indexPath.row == 3) {
		
			fileViewerController = [[MFFileViewerController alloc] initWithFile: self.file type: @"video"];
			
		} else if (indexPath.row == 4) {
		
			fileViewerController = [[MFFileViewerController alloc] initWithFile: self.file type: @"text"];
		
		} else if (indexPath.row == 5) {
		
			fileViewerController = [[MFFileViewerController alloc] initWithFile: self.file type: @"package"];
			
		} else if (indexPath.row == 6) {

			fileViewerController = [[MFFileViewerController alloc] initWithFile: self.file type: @"plist"];

		} else if (indexPath.row == 7) {

			fileViewerController = [[MFFileViewerController alloc] initWithFile: self.file type: @"database"];
			
		} else if (indexPath.row == 8) {
		
			fileViewerController = [[MFFileViewerController alloc] initWithFile: self.file type: @"binary"];

		} else if (indexPath.row == 9) {

			// Send by e-mail
			mailController = [[MFMailComposeViewController alloc] init];

			NSData *attachment = [NSData dataWithContentsOfFile: [self.file fullPath]];

			[mailController setSubject: [NSString stringWithFormat: MFLocalizedString(@"[MyFile] Attachment: %@ (%@, %@)"), self.file.name, self.file.mime, self.file.fsize]];
			[mailController setMessageBody: MFLocalizedString(@"This mail was sent you using MyFile. See attachment.") isHTML: NO];
			[mailController addAttachmentData: attachment mimeType: self.file.mime fileName: self.file.name];
			mailController.mailComposeDelegate = self;
			[self presentModalViewController: mailController animated: YES];
			[mailController release];
			
			return;

		}
		
		[fileViewerController presentFrom: self];
		[fileViewerController release];
		
	} else if (indexPath.section == 3) {

		if (indexPath.row == 0) {
	
			// compress
			MFCompressController *compressController = [[MFCompressController alloc] initWithFiles: [NSArray arrayWithObject: [self.file fullPath]]];
			compressController.mainController = self.mainController;
			[compressController presentFrom: self];
			[compressController release];
			
		} else if (indexPath.row == 1) {
			
			// Preview & Print
			QLPreviewController *qlpc = [[QLPreviewController alloc] init];
			qlpc.dataSource = self;
			[self presentModalViewController: qlpc animated: YES];
			[qlpc release];

		} else if (indexPath.row == 2) {

			if ([self.file.type isEqualToString: @"sound"]) {

 				// *** Add song to iPod ***
				PTTagViewController *tvc = [[PTTagViewController alloc] initWithPath: [file fullPath]];
				[tvc presentFrom: self];
				[tvc release];
			} else if ([self.file.type isEqualToString: @"image"]) {

				// add to camera roll
				UIImage *img = [[UIImage alloc] initWithContentsOfFile: [self.file fullPath]];
				seteuid (501); // change to user "mobile"
				UIImageWriteToSavedPhotosAlbum (img, [[UIApplication sharedApplication] delegate], @selector(imageSaved:error:name:), self.file.name);
				seteuid (0); // change back to root

			} else if ([self.file.type isEqualToString: @"video"]) {

				// add to camera roll
				seteuid (501); // change to user "mobile"
				UISaveVideoAtPathToSavedPhotosAlbum ([self.file fullPath], [[UIApplication sharedApplication] delegate], @selector(videoSaved:error:name:), self.file.name);
				seteuid (0); // change back to root

			}

		} else if (indexPath.row == 3) {
		
			// if the file is a video, add to iPod library
			if ([self.file.type isEqualToString: @"video"]) {
				// *** Add video to iPod ***
				PTTagViewController *tvc = [[PTTagViewController alloc] initWithPath: [file fullPath]];
				[tvc presentFrom: self];
				[tvc release];
			}
			
		}

	} else if (indexPath.section == 4) {
		MFPlugin *pl = [[MFPluginManager sharedInstance] pluginAtIndex: indexPath.row];
		NSDictionary *env = [NSDictionary dictionaryWithObjectsAndKeys: self, @"MFPViewController", [self.file fullPath], @"MFPFile", nil];
		[[MFPluginManager sharedInstance] activatePlugin: pl withEnvironment: env];
	}
	
}

// MFFileManagerDelegate

- (void) fileManagerDBUploadedFile: (NSString *) path toPath: (NSString *) path2 {

	if ([[[path2 lowercaseString] substringToIndex: 7] isEqualToString: @"/public"] && (!self.file.isDirectory)) {
		// Migrate to Adf.ly in order to generate revenue
		// NSURL *bitlyRequestUrl = [NSURL URLWithString: [NSString stringWithFormat: @"http://api.bitly.com/v3/shorten?login=%@&apiKey=%@&longUrl=http://dl.dropbox.com/u/%@/%@&format=txt", MF_BITLY_KEY, MF_BITLY_SECRET, [[[self mainController] fileManager] userID], [path2 substringFromIndex: 8]]];
		// NSString *shortUrlString = [NSString stringWithContentsOfURL: bitlyRequestUrl];
		NSString *adflyUrlString = [[NSString alloc] initWithFormat:@"http://api.adf.ly/api.php?key=%@&uid=%@&advert_type=int&domain=adf.ly&url=http://dl.dropbox.com/u/%@/%@", MF_ADFLY_KEY, MF_ADFLY_UID, [[[self mainController] fileManager] userID], [path2 substringFromIndex:8]];
		NSURL *adflyUrl = [[NSURL alloc] initWithString:adflyUrlString];
		[adflyUrlString release];
		NSString *shortUrlString = [[NSString alloc] initWithContentsOfURL:adflyUrl];
		[adflyUrl release];
		[[UIPasteboard generalPasteboard] setString: shortUrlString];
		if (shareOnFacebook) {
			shareOnFacebook = NO;
			if ([[[MFSocialManager sharedManager] facebook] isSessionValid]) {
				NSDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat: MFLocalizedString(@"Hey! I just shared a file on Facebook! %@"), shortUrlString], @"message", nil];
				[[[MFSocialManager sharedManager] facebook] dialog: @"feed" andParams: params andDelegate: [MFSocialManager sharedManager]];
			} else {
				[[MFSocialManager sharedManager] loginToService: MFSocialServiceFacebook];
			}
		} else if (shareOnTwitter) {
			shareOnTwitter = NO;
			if ([[[MFSocialManager sharedManager] twitter] isAuthorized]) {
				// present text alert to user for confirmation
				MFTextAlert *ta = [[MFTextAlert alloc] initWithTitle: MFLocalizedString(@"Share on Twitter")];
				ta.textField.text = [NSString stringWithFormat: MFLocalizedString(@"Check out my file: %@"), shortUrlString];
				ta.delegate = self;
				[ta addButtonWithTitle: MFLocalizedString(@"OK")];
				[ta addButtonWithTitle: MFLocalizedString(@"Cancel")];
				[ta show];
				[ta release];
			} else {
				UIViewController *ctrl = [[MFSocialManager sharedManager] loginToService: MFSocialServiceTwitter];
				if (ctrl != nil) {
					[self presentModalViewController: ctrl animated: YES];
				}
			}
		} else if (!self.file.isDirectory) {
			[[[[UIAlertView alloc] initWithTitle: MFLocalizedString(@"Upload successful") message: MFLocalizedString(@"Public link was copied to the pasteboard.") delegate: nil cancelButtonTitle: MFLocalizedString(@"Dismiss") otherButtonTitles: nil] autorelease] show];
		}
		[shortUrlString release];
	} else if (!self.file.isDirectory) {
		[[[[UIAlertView alloc] initWithTitle: MFLocalizedString(@"Upload successful") message: [NSString stringWithFormat: MFLocalizedString(@"File %@ was uploaded to %@"), path, path2] delegate: nil cancelButtonTitle: MFLocalizedString(@"Dismiss") otherButtonTitles: nil] autorelease] show];
	}
	
	fileQueueCount--;
	if (fileQueueCount == 0) {
		[loadingView hide];
		loadingView = nil;
	}

}

- (void) fileManagerDBUploadFileFailed {

	[loadingView hide];
	loadingView = nil;
	[[[[UIAlertView alloc] initWithTitle: MFLocalizedString(@"Error uploading file") message: MFLocalizedString(@"Please make sure that you're connected to the Internet, logged in to your Dropbox account and the specified file does not exist yet and try again.") delegate: nil cancelButtonTitle: MFLocalizedString(@"Dismiss") otherButtonTitles: nil] autorelease] show];

	fileQueueCount--;
	if (fileQueueCount == 0) {
		[loadingView hide];
		loadingView = nil;
	}

}

- (void) fileManagerDBUploadProgress: (float) progress forFile: (NSString *) path {

	[loadingView setProgress: progress];
	[loadingView setTitle: [path lastPathComponent]];

}

// UITextFieldDelegate

- (BOOL) textFieldShouldReturn: (UITextField *) theTextField {

	[theTextField resignFirstResponder];

	return YES;

}

// MFThreadDelegate

- (void) threadEnded: (MFThread *) theThread {

	NSString *props = [[NSString alloc] initWithContentsOfFile: @"/tmp/MFFileOut.txt" encoding: NSUTF8StringEncoding error: NULL];
	system ("rm /tmp/MFFileOut.txt");
	fileLabel.text = [[props stringByReplacingOccurrencesOfString: @"\n" withString: @""] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	[props release];
	[tableView reloadData];
	
}

// MFMailComposeViewControllerDelegate

- (void) mailComposeController: (MFMailComposeViewController *) controller didFinishWithResult: (MFMailComposeResult) result error: (NSError *) error {

	[self dismissModalViewControllerAnimated: YES];
	
}

@end


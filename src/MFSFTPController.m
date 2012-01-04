//
// MFSFTPController.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFSFTPController.h"
#import "MFSFTPUploadController.h"

@implementation MFSFTPController

// super

- (id) init {

	self = [super init];

	currentDirectory = @"/";

	self.title = currentDirectory;
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"upbutton.png"] style: UIBarButtonItemStyleBordered target: self action: @selector(loadParent)] autorelease];
	
	tableView = [[UITableView alloc] initWithFrame: CGRectMake (0, 0, 320, 417)];
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
	tableView.delegate = self;
	tableView.dataSource = self;
	[self.view addSubview: tableView];
	[tableView release];

	operation = [[UIActionSheet alloc] init];
	operation.cancelButtonIndex = 2;
	operation.title = MFLocalizedString(@"File tasks");
	operation.delegate = self;
	operation.actionSheetStyle = UIBarStyleBlack;
	[operation addButtonWithTitle: MFLocalizedString(@"Load directory")];
	[operation addButtonWithTitle: MFLocalizedString(@"Download file")];
	[operation addButtonWithTitle: MFLocalizedString(@"Cancel")];

	toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake (0, 412, 320, 48)];
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: NULL];
	UIBarButtonItem *toolbarItem_0 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAction target: self action: @selector(showLogin)];
	UIBarButtonItem *toolbarItem_1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target: self action: @selector(showUpload)];
	NSArray *toolbarItems = [NSArray arrayWithObjects: toolbarItem_0, flexItem, toolbarItem_1, nil];
	toolbar.barStyle = UIBarStyleBlack;
	toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
	[toolbar setItems: toolbarItems animated: YES];
	[self.view addSubview: toolbar];

	files = [[NSMutableArray alloc] init];
	uploadController = [[MFSFTPUploadController alloc] init];
	uploadController.mainController = self;
	
	return self;
	
}

- (void) dealloc {

	[files release];
	files = nil;
	[operation release];
	operation = nil;
	[toolbar release];
	toolbar = nil;

	[super dealloc];
	
}

// self

- (void) showLogin {

	hostController = [[MFSFTPHostController alloc] init];
	hostController.delegate = self;
	[hostController presentFrom: self];
	[hostController release];

}

- (void) showUpload {

	[uploadController presentFrom: self];
	
}

- (void) downloadFile: (NSString *) file {

	loadingView = [[MFLoadingView alloc] initWithType: MFLoadingViewTypeTemporary];
	[loadingView setTitle: [file lastPathComponent]];
	[loadingView show];
	MFThread *downloader = [[[MFThread alloc] init] autorelease];
	downloader.delegate = self;
	NSString *command = [[NSString alloc] initWithFormat: @"/var/root/myfile/sftpget.sh %@ %@ %@ /var/mobile/Documents", [server objectForKey: @"HostURL"], [server objectForKey: @"Password"], file];
	downloader.cmd = command;
	[command release];
	[downloader start];
	
}

- (void) uploadFile: (NSString *) file toPath: (NSString *) path {

	loadingView = [[MFLoadingView alloc] initWithType: MFLoadingViewTypeTemporary];
	[loadingView setTitle: [file lastPathComponent]];
	[loadingView show];
	MFThread *uploader = [[[MFThread alloc] init] autorelease];
	uploader.delegate = self;
	NSString *command = [[NSString alloc] initWithFormat: @"/var/root/myfile/sftpput.sh %@ %@ %@ %@", [server objectForKey: @"HostURL"], [server objectForKey: @"Password"], file, path];
	uploader.cmd = command;
	[command release];
	[uploader start];
	
}

- (void) loadParent {

	[self loadDirectory: [currentDirectory stringByDeletingLastPathComponent]];
	
}

- (void) loadDirectory: (NSString *) dir {

	currentDirectory = dir;
	self.title = currentDirectory;
	
	NSString *cmd = [NSString stringWithFormat: @"/var/root/myfile/sftpls.sh %@ %@ %@", [server objectForKey: @"HostURL"], [server objectForKey: @"Password"], dir];

	system ([cmd UTF8String]);
	NSString *filesStr = [[NSString alloc] initWithContentsOfFile: @"/var/root/myfile/sftpls.txt"];
	system ("rm /var/root/myfile/sftpls.txt");
	[files removeAllObjects];
	
	NSArray *filesComponents = [filesStr componentsSeparatedByString: @"\n"];

	for (int i = 0; i < [filesComponents count]; i++) {
	
		NSMutableArray *fileProperties = [[NSMutableArray alloc] init];
		[fileProperties addObjectsFromArray: [[filesComponents objectAtIndex: i] componentsSeparatedByString: @" "]];
		[fileProperties removeObject: @""];
		
		if ([fileProperties count] > 0) {
	
			MFFile *f = [[MFFile alloc] init];
			f.path = currentDirectory;
			f.name = [fileProperties objectAtIndex: 8];
			f.permissions = [fileProperties objectAtIndex: 0];
			f.fsize = [fileProperties objectAtIndex: 4];
			f.isDirectory = ([f.permissions characterAtIndex: 0] == 'd');
			[files addObject: f];
			[f release];

		}
		
		[fileProperties release];
		
	}
	
	[filesStr release];
	[tableView reloadData];

}

// MFSFTPHostControllerDelegate

- (void) hostController: (MFSFTPHostController *) controller didReceiveHostInfo: (NSDictionary *) hostInfo {

	[server release];
	server = [hostInfo copy];
	[self loadDirectory: @"/"];

}

// MFThreadDelegate

- (void) threadEnded: (MFThread *) thread {

	[loadingView hide];
	
}

// UIActionSheetDelegate

- (void) actionSheet: (UIActionSheet *) sheet didDismissWithButtonIndex: (int) index {

	if (sheet == operation) {

		if (index == 0) {

			[self loadDirectory: [currentDirectory stringByAppendingPathComponent: [[files objectAtIndex: fileIndex] name]]];

		} else if (index == 1) {

			[self downloadFile: [[files objectAtIndex: fileIndex] fullPath]];

		} else {

			return;

		}

	}

}

// UITableViewDelegate

- (void) tableView: (UITableView *) theTableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

	[theTableView deselectRowAtIndexPath: indexPath animated: YES];

	if ([[files objectAtIndex: indexPath.row] isDirectory]) {
	
		[self loadDirectory: [[files objectAtIndex: indexPath.row] fullPath]];
		
	} else {
	
		[self downloadFile: [[files objectAtIndex: indexPath.row] fullPath]];
		
	}

}

- (void) tableView: (UITableView *) theTableView accessoryButtonTappedForRowWithIndexPath: (NSIndexPath *) indexPath {

	fileIndex = indexPath.row;
	[operation showInView: self.view];

}

- (void) tableView: (UITableView *) theTableView commitEditingStyle: (UITableViewCellEditingStyle) style forRowAtIndexPath: (NSIndexPath *) indexPath {

        if (style == UITableViewCellEditingStyleDelete) {

                NSString *cmd = [[NSString alloc] initWithFormat: @"/var/root/myfile/sftprm.sh %@ %@ %@", [server objectForKey: @"HostURL"], [server objectForKey: @"Password"], [[files objectAtIndex: indexPath.row] fullPath]];
                system ([cmd UTF8String]);
                [cmd release];
                [files removeObjectAtIndex: indexPath.row];
                [theTableView deleteRowsAtIndexPaths: [NSArray arrayWithObject: indexPath] withRowAnimation: UITableViewRowAnimationRight];

        }

}

// UITableViewDataSource

- (int) tableView: (UITableView *) theTableView numberOfRowsInSection: (int) section {

	return [files count];
	
}

- (UITableViewCell *) tableView: (UITableView *) theTableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier: @"MFSFTPCell"];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: @"MFSFTPCell"] autorelease];
	}
	
	cell.textLabel.text = [[files objectAtIndex: indexPath.row] name];
	cell.detailTextLabel.text = [NSString stringWithFormat: MFLocalizedString(@"Size: %@; mode: %@"), [[files objectAtIndex: indexPath.row] fsize], [[files objectAtIndex: indexPath.row] permissions]];
	cell.imageView.image = [[files objectAtIndex: indexPath.row] isDirectory] ? [UIImage imageNamed: @"dir.png"] : [MFFileType imageForName: [[files objectAtIndex: indexPath.row] name]];
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	
	return cell;
	
}

@end

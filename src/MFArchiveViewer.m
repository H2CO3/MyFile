//
// MFArchiveViewer.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFArchiveViewer.h"
#import "MFFileViewerController.h"
#undef MFLocalizedString
#define MFLocalizedString(x) (NSLocalizedString((x), @""))


@implementation MFArchiveViewer

@synthesize mainController = mainController;

// super

- (void) dealloc {

	[tableView release];
	tableView = nil;
	[files release];
	files = nil;
	[archive release];

	[super dealloc];

}

// self

- (void) extractFile: (NSString *) path {

	[self.mainController setFilesystemModified];

	NSString *cmd;

	if ([[[archive name] pathExtension] isEqualToString: @"tar"] || [[[archive name] pathExtension] isEqualToString: @"gz"] || [[[archive name] pathExtension] isEqualToString: @"tgz"] || [[[archive name] pathExtension] isEqualToString: @"bz2"] || [[[archive name] pathExtension] isEqualToString: @"tbz"]) {
		cmd = [[NSString alloc] initWithFormat: @"cd %@; tar -xvf %@ %@ 2>&1", archive.path, [[archive fullPath] stringByReplacingOccurrencesOfString: @" " withString: @"\\ "], path];
	} else if ([[[archive name] pathExtension] isEqualToString: @"xar"]) {
		cmd = [[NSString alloc] initWithFormat: @"cd %@; xar -xvf %@ %@ 2>&1", archive.path, [[archive fullPath] stringByReplacingOccurrencesOfString: @" " withString: @"\\ "], path];
	} else if ([[[archive name] pathExtension] isEqualToString: @"zip"] || [[[archive name] pathExtension] isEqualToString: @"ipa"]) {
		cmd = [[NSString alloc] initWithFormat: @"cd %@; unzip %@ %@ 2>&1", archive.path, [[archive fullPath] stringByReplacingOccurrencesOfString: @" " withString: @"\\ "], path];
	} else if ([[[archive name] pathExtension] isEqualToString: @"rar"]) {
		cmd = [[NSString alloc] initWithFormat: @"cd %@; unrar x %@ %@ 2>&1", archive.path, [[archive fullPath] stringByReplacingOccurrencesOfString: @" " withString: @"\\ "], path];
	} else {
		cmd = [[NSString alloc] initWithFormat: @"cd %@; 7z x %@ %@ 2>&1", archive.path, [[archive fullPath] stringByReplacingOccurrencesOfString: @" " withString: @"\\ "], path];
	}

	MFCommandController *cmdCtrl = [[MFCommandController alloc] initWithCommand: cmd];
	[cmd release];
	[cmdCtrl presentFrom: self.mainController];
	[cmdCtrl start];
	[cmdCtrl release];

}

- (void) extractAll {

	[self.mainController setFilesystemModified];

	if ([[[archive name] pathExtension] isEqualToString: @"tar"] || [[[archive name] pathExtension] isEqualToString: @"gz"] || [[[archive name] pathExtension] isEqualToString: @"tgz"] || [[[archive name] pathExtension] isEqualToString: @"bz2"] || [[[archive name] pathExtension] isEqualToString: @"tbz"]) {
		command = [[NSString alloc] initWithFormat: @"cd %@; tar -xvf %@ 2>&1", archive.path, [[archive fullPath] stringByReplacingOccurrencesOfString: @" " withString: @"\\ "]];
	} else if ([[[archive name] pathExtension] isEqualToString: @"xar"]) {
		command = [[NSString alloc] initWithFormat: @"cd %@; xar -xvf %@ 2>&1", archive.path, [[archive fullPath] stringByReplacingOccurrencesOfString: @" " withString: @"\\ "]];
	} else if ([[[archive name] pathExtension] isEqualToString: @"zip"] || [[[archive name] pathExtension] isEqualToString: @"ipa"]) {
		command = [[NSString alloc] initWithFormat: @"cd %@; unzip %@ 2>&1", archive.path, [[archive fullPath] stringByReplacingOccurrencesOfString: @" " withString: @"\\ "]];
	} else if ([[[archive name] pathExtension] isEqualToString: @"rar"]) {
		command = [[NSString alloc] initWithFormat: @"cd %@; unrar x %@ 2>&1", archive.path, [[archive fullPath] stringByReplacingOccurrencesOfString: @" " withString: @"\\ "]];
	} else {
		command = [[NSString alloc] initWithFormat: @"cd %@; 7z x %@ 2>&1", archive.path, [[archive fullPath] stringByReplacingOccurrencesOfString: @" " withString: @"\\ "]];
	}

	MFCommandController *cmdCtrl = [[MFCommandController alloc] initWithCommand: command];
	[command release];
	[cmdCtrl presentFrom: self.mainController];
	[cmdCtrl start];
	[cmdCtrl release];

}

- (id) initWithFile: (MFFile *) file frame: (CGRect) theFrame {

	self = [super initWithFrame: theFrame];
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	archive = [file retain];
	seteuid(0);
	if ([[[archive name] pathExtension] isEqualToString: @"zip"]) {

		zipfile = zip_open ([[archive fullPath] UTF8String], 0, NULL);
		files = [[NSMutableArray alloc] init];
		int items = zip_get_num_entries (zipfile, 0);

		for (int i = 0; i < items; i++) {
			[files addObject: [[NSString stringWithUTF8String: zip_get_name (zipfile, i, 0)] retain]];
		}

		zip_close (zipfile);

	} else if ([[[archive name] pathExtension] isEqualToString: @"deb"]) {
		files = [[NSMutableArray alloc] initWithObjects: MFLocalizedString(@"Install package"), MFLocalizedString(@"Extract package"), nil];
	} else if ([[[archive name] pathExtension] isEqualToString: @"ipa"]) {
		files = [[NSMutableArray alloc] initWithObjects: @"Install application", @"Extract application", nil];
	} else {
	
		a = archive_read_new ();
		files = [[NSMutableArray alloc] init];
		archive_read_support_compression_all (a);
		archive_read_support_format_all (a);
		archive_read_open_filename (a, [[archive fullPath] UTF8String], 8192);
		while (archive_read_next_header (a, &entry) == ARCHIVE_OK) {
			[files addObject: [NSString stringWithUTF8String: archive_entry_pathname (entry)]];
		}
		archive_read_finish(a);
	
	}
	seteuid(501);

	tableView = [[UITableView alloc] initWithFrame: theFrame];
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	tableView.delegate = self;
	tableView.dataSource = self;
	[self addSubview: tableView];

	return self;

}

// UITableViewDataSource

- (int) tableView: (UITableView *) theTableView numberOfRowsInSection: (int) section {

	return [files count];

}

- (UITableViewCell *) tableView: (UITableView *) theTableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier: @"MFAVCell"];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"MFAVCell"] autorelease];
	}

	cell.text = [files objectAtIndex: indexPath.row];

	return cell;

}

// UITableViewDelegate

- (void) tableView: (UITableView *) theTableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

	if ([[[archive name] pathExtension] isEqualToString: @"deb"]) {

		[self.mainController setFilesystemModified];

		if (indexPath.row == 0) {

			NSString *installCmd = [[NSString alloc] initWithFormat: @"dpkg -i %@ 2>&1", [[archive fullPath] stringByReplacingOccurrencesOfString: @" " withString: @"\\ "]];
			MFCommandController *cmdCtrl = [[MFCommandController alloc] initWithCommand: installCmd];
			[installCmd release];
			[cmdCtrl presentFrom: self.mainController];
			[cmdCtrl start];
			[cmdCtrl release];

		} else if (indexPath.row == 1) {
		
			NSString *extractCmd = [[NSString alloc] initWithFormat: @"cd %@; mkdir -p %@; cd %@; 7z x %@ 2>&1", archive.path, [archive.name stringByDeletingPathExtension], [archive.name stringByDeletingPathExtension], [[archive fullPath] stringByReplacingOccurrencesOfString: @" " withString: @"\\ "]];
			MFCommandController *cmdCtrl = [[MFCommandController alloc] initWithCommand: extractCmd];
			[extractCmd release];
			[cmdCtrl presentFrom: self.mainController];
			[cmdCtrl start];
			[cmdCtrl release];

		}
		
	} else if ([[[archive name] pathExtension] isEqualToString: @"ipa"]) {
	
		[self.mainController setFilesystemModified];

		if (indexPath.row == 0) {

			NSString *installCmd = [[NSString alloc] initWithFormat: @"/usr/libexec/installipa -i %@ 2>&1", [[archive fullPath] stringByReplacingOccurrencesOfString: @" " withString: @"\\ "]];
			MFCommandController *cmdCtrl = [[MFCommandController alloc] initWithCommand: installCmd];
			[installCmd release];
			[cmdCtrl presentFrom: self.mainController];
			[cmdCtrl start];
			[cmdCtrl release];

		} else if (indexPath.row == 1) {
		
			NSString *extractCmd = [[NSString alloc] initWithFormat: @"cd %@; mkdir -p %@; cd %@; unzip %@ 2>&1", archive.path, [[archive.name stringByDeletingPathExtension] stringByReplacingOccurrencesOfString: @" " withString: @"\\ "], [[archive.name stringByDeletingPathExtension] stringByReplacingOccurrencesOfString: @" " withString: @"\\ "], [[archive fullPath] stringByReplacingOccurrencesOfString: @" " withString: @"\\ "]];
			MFCommandController *cmdCtrl = [[MFCommandController alloc] initWithCommand: extractCmd];
			[extractCmd release];
			[cmdCtrl presentFrom: self.mainController];
			[cmdCtrl start];
			[cmdCtrl release];

		}
		
	} else {
	
		[self extractFile: [files objectAtIndex: indexPath.row]];
		
	}

	[theTableView deselectRowAtIndexPath: indexPath animated: YES];

}

@end


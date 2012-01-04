//
// MFUnknownFileController.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFUnknownFileController.h"

#define CELL_ID @"MFUFCell"

@implementation MFUnknownFileController

// self

- (id) initWithFile:(MFFile *)aFile {
	self = [super init];
	self.navigationItem.title = aFile.name;
	file = [aFile copy];
	tableView = [[UITableView alloc] initWithFrame:(UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? CGRectMake(0, 0, 320, 460) : [[UIScreen mainScreen] applicationFrame]) style:UITableViewStyleGrouped];
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	tableView.delegate = self;
	tableView.dataSource = self;
	[self.view addSubview:tableView];
	[tableView release];
	return self;
}

// super

- (void) dealloc {
	[file release];
	[super dealloc];
}

// UITableViewDelegate

- (void) tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tv deselectRowAtIndexPath:indexPath animated:YES];
	if (indexPath.section == 0) {
		// built-in file viewer
		NSString *type = nil;
		if (indexPath.row == 0) {
			type = @"html";
		} else if (indexPath.row == 1) {
			type = @"image";
		} else if (indexPath.row == 2) {
			type = @"sound";
		} else if (indexPath.row == 3) {
			type = @"video";
		} else if (indexPath.row == 4) {
			type = @"text";
		} else if (indexPath.row == 5) {
			type = @"package";
		} else if (indexPath.row == 6) {
			type = @"plist";
		} else if (indexPath.row == 7) {
			type = @"database";
		} else if (indexPath.row == 8) {
			type = @"binary";
		}
		MFFileViewerController *fvc = [[MFFileViewerController alloc] initWithFile:file type:type];
		[fvc presentFrom:self];
		[fvc release];
	} else {
		// plugin
		MFPlugin *plugin = [[MFPluginManager sharedInstance] pluginAtIndex:indexPath.row forType:[[file fullPath] pathExtension]];
		NSDictionary *envDict = [NSDictionary dictionaryWithObjectsAndKeys:self, @"MFPViewController", [file fullPath], @"MFPFile", nil];
		[[MFPluginManager sharedInstance] activatePlugin:plugin withEnvironment:envDict];
	}
}

// UITableViewDataSource

- (int) numberOfSectionsInTableView:(UITableView *)tv {
	return 2;
}

- (int) tableView:(UITableView *)tv numberOfRowsInSection:(int) section{
	int res = 0;
	if (section == 0) {
		// standard, built-in filetypes
		res = 9;
	} else {
		// 3rd-party plugins
		res = [[MFPluginManager sharedInstance] numberOfPluginsForType:[[file fullPath] pathExtension]];
	}
	return res;
}

- (NSString *) tableView:(UITableView *)tv titleForHeaderInSection:(int)section {
	NSString *res = nil;
	if (section == 0) {
		// built-in viewers
		res = MFLocalizedString(@"Default file viewers");
	} else {
		// plug-ins
		res = MFLocalizedString(@"Compatible extensions");
	}
	return res;
}

- (UITableViewCell *) tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CELL_ID];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_ID] autorelease];
	}
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	if (indexPath.section == 0) {
		// built-in viewers
		if (indexPath.row == 0) {
			cell.textLabel.text = MFLocalizedString(@"Web browser");
			cell.detailTextLabel.text = nil;
		} else if (indexPath.row == 1) {
			cell.textLabel.text = MFLocalizedString(@"Image viewer");
			cell.detailTextLabel.text = nil;
		} else if (indexPath.row == 2) {
			cell.textLabel.text = MFLocalizedString(@"Audio player");
			cell.detailTextLabel.text = nil;
		} else if (indexPath.row == 3) {
			cell.textLabel.text = MFLocalizedString(@"Movie player");
			cell.detailTextLabel.text = nil;
		} else if (indexPath.row == 4) {
			cell.textLabel.text = MFLocalizedString(@"Text editor");
			cell.detailTextLabel.text = nil;
		} else if (indexPath.row == 5) {
			cell.textLabel.text = MFLocalizedString(@"Archive manager");
			cell.detailTextLabel.text = nil;
		} else if (indexPath.row == 6) {
			cell.textLabel.text = MFLocalizedString(@"Property list viewer");
			cell.detailTextLabel.text = nil;
		} else if (indexPath.row == 7) {
			cell.textLabel.text = MFLocalizedString(@"SQL viewer");
			cell.detailTextLabel.text = nil;
		} else if (indexPath.row == 8) {
			cell.textLabel.text = MFLocalizedString(@"Hex editor");
			cell.detailTextLabel.text = nil;
		}
	} else {
		// plug-in
		MFPlugin *plugin = [[MFPluginManager sharedInstance] pluginAtIndex:indexPath.row forType:[[file fullPath] pathExtension]];
		cell.textLabel.text = [plugin name];
		cell.detailTextLabel.text = [plugin description];
	}
	return cell;
}

@end

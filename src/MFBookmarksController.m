//
// MFBookmarksController.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFBookmarksController.h"
#import "MFMainController.h"

@implementation MFBookmarksController

@synthesize mainController = mainController;

// super

- (id) init {

	self = [super init];
	
	self.title = MFLocalizedString(@"Bookmarks");
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target: self action: @selector(addBookmark)] autorelease];
	
	tableView = [[UITableView alloc] initWithFrame: CGRectMake (0, 0, 320, 460)];
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview: tableView];
	
        bookmarks = [[NSMutableArray alloc] init];
	[bookmarks addObjectsFromArray: [[NSUserDefaults standardUserDefaults] arrayForKey: @"MFBookmarks"]];
	
	return self;
	
}

- (void) dealloc {

	[tableView release];
	tableView = nil;
        [bookmarks release];
        bookmarks = nil;
	
	[super dealloc];
	
}

// self

- (void) addBookmark {

	NSString *path = [self.mainController currentDirectory];
	[bookmarks addObject: path];
	[tableView insertRowsAtIndexPaths: [NSArray arrayWithObject: [NSIndexPath indexPathForRow: [bookmarks count] - 1 inSection: 0]] withRowAnimation: UITableViewRowAnimationRight];
	[[NSUserDefaults standardUserDefaults] setObject: bookmarks forKey: @"MFBookmarks"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
}

- (void) addFile: (NSString *) path {

	[bookmarks addObject: path];
	[tableView insertRowsAtIndexPaths: [NSArray arrayWithObject: [NSIndexPath indexPathForRow: [bookmarks count] - 1 inSection: 0]] withRowAnimation: UITableViewRowAnimationRight];
	[[NSUserDefaults standardUserDefaults] setObject: bookmarks forKey: @"MFBookmarks"];
	[[NSUserDefaults standardUserDefaults] synchronize];

}

// UITableViewDelegate

- (void) tableView: (UITableView *) theTableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

	[theTableView deselectRowAtIndexPath: indexPath animated: YES];
        if ([[self.mainController fileManager] fileIsDirectory: [bookmarks objectAtIndex: indexPath.row]]) {
	        [self.mainController loadDirectory: [bookmarks objectAtIndex: indexPath.row]];
        } else {
                MFFile *tmpFile = [[[MFFile alloc] init] autorelease];
                tmpFile.path = [[bookmarks objectAtIndex: indexPath.row] stringByDeletingLastPathComponent];
                tmpFile.name = [[bookmarks objectAtIndex: indexPath.row] lastPathComponent];
                tmpFile.type = [MFFileType fileTypeForName: tmpFile.name];
                [self.mainController performSelector: @selector(showFile:) withObject: tmpFile afterDelay: 0.5];
        }

	[self close];
	
}

// UITableViewDataSource

- (int) tableView: (UITableView *) theTableView numberOfRowsInSection: (int) section {

	return [bookmarks count];
	
}

- (UITableViewCell *) tableView: (UITableView *) theTableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier: @"cell"];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: @"cell"] autorelease];
	}

	cell.textLabel.text = [[bookmarks objectAtIndex: indexPath.row] lastPathComponent];
	cell.detailTextLabel.text = [[bookmarks objectAtIndex: indexPath.row] stringByDeletingLastPathComponent];
	
	return cell;
	
}

- (void) tableView: (UITableView *) theTableView commitEditingStyle: (UITableViewCellEditingStyle) style forRowAtIndexPath: (NSIndexPath *) indexPath {

	[bookmarks removeObjectAtIndex: indexPath.row];
	[theTableView deleteRowsAtIndexPaths: [NSArray arrayWithObject: indexPath] withRowAnimation: UITableViewRowAnimationRight];
	[[NSUserDefaults standardUserDefaults] setObject: bookmarks forKey: @"MFBookmarks"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
}

@end


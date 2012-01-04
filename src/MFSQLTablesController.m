//
// MFSQLTablesController.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFSQLTablesController.h"

@implementation MFSQLTablesController

// self

- (id) initWithSQLManager: (SQLiteManager *) sqlMgr {

	self = [super init];
	
	self.title = MFLocalizedString(@"Tables in database");
	manager = [sqlMgr retain];
	tables = [[manager executeSQLQueryNoKeys: @"SELECT name FROM sqlite_master WHERE type='table';"] copy];
	tableView = [[UITableView alloc] initWithFrame: UIInterfaceOrientationIsLandscape (self.interfaceOrientation) ? [[UIScreen mainScreen] applicationFrame] : CGRectMake (0, 0, 320, 460)];
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.autoresizingMask = self.view.autoresizingMask;
	[self.view addSubview: tableView];
	
	return self;
	
}

// super

- (void) dealloc {

	[manager release];
	manager = nil;
	[tableView release];
	tableView = nil;
        [tables release]; 
        tables = nil;
	
	[super dealloc];
	
}

// UITableViewDelegate

- (void) tableView: (UITableView *) theTableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

	[theTableView deselectRowAtIndexPath: indexPath animated: YES];
	
	NSArray *tmp1 = [manager executeSQLQueryNoKeys: [NSString stringWithFormat: @"PRAGMA table_info(%@);", [[tables objectAtIndex: indexPath.row] objectAtIndex: 0]]];
	NSMutableArray *tmp2 = [[NSMutableArray alloc] init];
	for (int i = 0; i < [tmp1 count]; i++) {
		[tmp2 addObject: [[tmp1 objectAtIndex: i] objectAtIndex: 1]];
	}
	
	UIAlertView *av = [[UIAlertView alloc] init];
	av.title = MFLocalizedString(@"Columns of table");
	av.message = [tmp2 componentsJoinedByString: @"\n"];
	[tmp2 release];
	[av addButtonWithTitle: MFLocalizedString(@"Dismiss")];
	[av show];
	[av release];
	
}

// UITableViewDataSource

- (int) tableView: (UITableView *) theTableView numberOfRowsInSection: (int) section {

	return [tables count];
	
}

- (UITableViewCell *) tableView: (UITableView *) theTableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier: @"SQLTableCell"];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"SQLTableCell"] autorelease];
	}
	cell.textLabel.text = [[tables objectAtIndex: indexPath.row] objectAtIndex: 0];
	
	return cell;
	
}

@end

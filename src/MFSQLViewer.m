//
// MFSQLViewer.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFSQLViewer.h"

@implementation MFSQLViewer

@synthesize mainViewController = mainViewController;

// self

- (id) initWithFile: (MFFile *) file frame: (CGRect) theFrame {

	self = [super initWithFrame: theFrame];

	self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	database = [file retain];
	sqlManager = [[SQLiteManager alloc] initWithFile: [database fullPath]];
	result = [[NSMutableArray alloc] init];
	tablesController = [[MFSQLTablesController alloc] initWithSQLManager: sqlManager];
	sqlCommand = [[UISearchBar alloc] initWithFrame: CGRectMake (0, 0, 320, 48)];
	sqlCommand.tintColor = [UIColor colorWithRed: 0.65 green: 0.7 blue: 0.75 alpha: 1.0];
	sqlCommand.placeholder = MFLocalizedString(@"Enter SQL query here");
	sqlCommand.showsCancelButton = YES;
	sqlCommand.delegate = self;
	tableView = [[UITableView alloc] initWithFrame: theFrame];
	tableView.autoresizingMask = self.autoresizingMask;
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.tableHeaderView = sqlCommand;

	[self addSubview: tableView];

	return self;

}

- (void) showTables {

	[tablesController presentFrom: self.mainViewController];
	
}

// super

- (void) dealloc {

	tableView.tableHeaderView = nil;
	tableView.delegate = nil;
	tableView.dataSource = nil;
	sqlCommand.delegate = nil;

	[tableView release];
	tableView = nil;
	[sqlCommand release];
	sqlCommand = nil;
	[result release];
	result = nil;
	[sqlManager release];
	sqlManager = nil;
	[tablesController release];
	tablesController = nil;

	[super dealloc];

}

// UISearchBarDelegate

- (void) searchBarSearchButtonClicked: (UISearchBar *) bar {

	[bar resignFirstResponder];
	[result removeAllObjects];
	seteuid(0);
	[result addObjectsFromArray: [sqlManager executeSQLQuery: bar.text]];
	seteuid(501);
	[tableView reloadData];
	
}

- (void) searchBarCancelButtonClicked: (UISearchBar *) bar {

	[bar resignFirstResponder];

}


// UITableViewDelegate

- (void) tableView: (UITableView *) theTableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

	[theTableView deselectRowAtIndexPath: indexPath animated: YES];
	UIAlertView *av = [[UIAlertView alloc] init];
	NSString *t = [[NSString alloc] initWithFormat: MFLocalizedString(@"Record #%i"), indexPath.row];
	av.title = t;
	[t release];
	av.message = [[result objectAtIndex: indexPath.row] componentsJoinedByString: @"\n"];
	[av addButtonWithTitle: MFLocalizedString(@"Dismiss")];
	[av show];
	[av release];

}

// UITableViewDataSource

- (int) tableView: (UITableView *) theTableView numberOfRowsInSection: (int) section {

	return [result count];

}

- (UITableViewCell *) tableView: (UITableView *) theTableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier: @"cell"];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"cell"] autorelease];
	}
	cell.text = [[result objectAtIndex: indexPath.row] componentsJoinedByString: @"; "];
	
	return cell;

}

@end

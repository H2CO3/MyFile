//
// MFPlistViewer.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFPlistViewer.h"
#import "MFFileViewerController.h"

#undef MFLocalizedString
#define MFLocalizedString(x) (NSLocalizedString((x), @""))

@implementation MFPlistViewer

@synthesize mainController = mainController;

// self

- (id) initWithFile: (MFFile *) file frame: (CGRect) theFrame {

	self = [super initWithFrame: theFrame];
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	plist = [file retain];
	keys = [[NSMutableArray alloc] init];
	values = [[NSMutableArray alloc] init];
	types = [[NSMutableArray alloc] init];
	path = [[NSMutableArray alloc] init];

	root = [[NSMutableDictionary alloc] initWithContentsOfFile: [plist fullPath]];
	if (root == nil) {
		root = [[NSMutableArray alloc] initWithContentsOfFile: [plist fullPath]];
	}
	
	tableView = [[UITableView alloc] initWithFrame: theFrame];
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.autoresizingMask = self.autoresizingMask;
	[self addSubview: tableView];

	sheet = [[UIActionSheet alloc] init];
	sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	sheet.title = MFLocalizedString(@"Plist operations");
	sheet.cancelButtonIndex = 2;
	sheet.delegate = self;
	[sheet addButtonWithTitle: MFLocalizedString(@"Load previous node")];
	[sheet addButtonWithTitle: MFLocalizedString(@"Edit as text")];
	[sheet addButtonWithTitle: MFLocalizedString(@"Cancel")];

	[self loadRoot];

	return self;
	
}

- (void) showAction {

	[sheet showInView: self];

}

- (void) loadRoot {

	if ([path count] > 0) {
		[path removeLastObject];
	}

	if ([path count] == 0) {
		[self loadNode: root];
	} else {
		id tmpNode = root;
		for (int i = 0; i < [path count]; i++) {
			if ([tmpNode isKindOfClass: [NSDictionary class]]) {
				tmpNode = [tmpNode objectForKey: [[tmpNode allKeys] objectAtIndex: [[path objectAtIndex: i] row]]];
			} else {
				tmpNode = [tmpNode objectAtIndex: [[path objectAtIndex: i] row]];
			}
		}
		[self loadNode: tmpNode];
	}
	
}

- (void) loadNode: (id) node {

 	if ([node isKindOfClass: [NSDictionary class]]) {

		[self loadDictionary: node];

	} else if ([node isKindOfClass: [NSArray class]]) {

		[self loadArray: node];

	}

}

- (void) loadDictionary: (NSDictionary *) dict {

	[keys removeAllObjects];
	[values removeAllObjects];
	[types removeAllObjects];

	[keys addObjectsFromArray: [dict allKeys]];
	for (int i = 0; i < [keys count]; i++) {
		[values addObject: [dict valueForKey: [keys objectAtIndex: i]]];
		if ([[dict valueForKey: [keys objectAtIndex: i]] isKindOfClass: [NSArray class]]) {
			[types addObject: [NSNumber numberWithInt: MFPlistNodeTypeArray]];
		} else if ([[dict valueForKey: [keys objectAtIndex: i]] isKindOfClass: [NSDictionary class]]) {
			[types addObject: [NSNumber numberWithInt: MFPlistNodeTypeDictionary]];
		} else {
			[types addObject: [NSNumber numberWithInt: MFPlistNodeTypeSimple]];
		}
	}
	currentNodeType = MFPlistNodeTypeDictionary;

	[tableView reloadData];

}

- (void) loadArray: (NSArray *) array {

	[keys removeAllObjects];
	[values removeAllObjects];
	[types removeAllObjects];

	[values addObjectsFromArray: array];
	for (int i = 0; i < [values count]; i++) {
		[keys addObject: [NSString stringWithFormat: @"%i", i]];
		if ([[values objectAtIndex: i] isKindOfClass: [NSArray class]]) {
			[types addObject: [NSNumber numberWithInt: MFPlistNodeTypeArray]];
		} else if ([[values objectAtIndex: i] isKindOfClass: [NSDictionary class]]) {
			[types addObject: [NSNumber numberWithInt: MFPlistNodeTypeDictionary]];
		} else {
			[types addObject: [NSNumber numberWithInt: MFPlistNodeTypeSimple]];
		}
	}
	currentNodeType = MFPlistNodeTypeArray;

	[tableView reloadData];

}

// super

- (void) dealloc {

	[root release];
	root = nil;
	[tableView release];
	tableView = nil;
	[sheet release];
	sheet = nil;
	[keys release];
	keys = nil;
	[values release];
	values = nil;
	[types release];
	types = nil;
	[path release];
	path = nil;

	[super dealloc];

}

// UIActionSheetDelegate

- (void) actionSheet: (UIActionSheet *) actionSheet didDismissWithButtonIndex: (int) index {

	if (index == 0) {
		[self loadRoot];
	} else if (index == 1) {

		NSString *cmd = [[NSString alloc] initWithFormat: @"plutil -convert xml1 %@", [plist fullPath]];
		system ([cmd UTF8String]);
		[cmd release];
		MFFileViewerController *editor = [[MFFileViewerController alloc] initWithFile: plist type: @"text"];
		[editor presentFrom: self.mainController];
		[editor release];
	
	}

}

// UITableViewDelegate

- (void) tableView: (UITableView *) theTableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

	[theTableView deselectRowAtIndexPath: indexPath animated: YES];
	if ([[types objectAtIndex: indexPath.row] intValue] != MFPlistNodeTypeSimple) {
		NSIndexPath *tmpIdx = [indexPath copy];
		[path addObject: tmpIdx];
		[tmpIdx release];
	}

	if ([[types objectAtIndex: indexPath.row] intValue] == MFPlistNodeTypeArray) {
		[self loadArray: [values objectAtIndex: indexPath.row]];
	} else if ([[types objectAtIndex: indexPath.row] intValue] == MFPlistNodeTypeDictionary) {
		[self loadDictionary: [values objectAtIndex: indexPath.row]];
	} else {
		[[[[UIAlertView alloc] initWithTitle: [[keys objectAtIndex: indexPath.row] description] message: [[values objectAtIndex: indexPath.row] description] delegate: nil cancelButtonTitle: MFLocalizedString(@"Dismiss") otherButtonTitles: nil] autorelease] show];
	}

}

// UITableViewDataSource

- (int) tableView: (UITableView *) theTableView numberOfRowsInSection: (int) section {

	return [keys count];

}

- (UITableViewCell *) tableView: (UITableView *) theTableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier: @"PlistCell"];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"PlistCell"] autorelease];
	}
	
	NSString *node;
	NSString *key = [keys objectAtIndex: indexPath.row];
	id value = [values objectAtIndex: indexPath.row];
	MFPlistNodeType type = [[types objectAtIndex: indexPath.row] intValue];

	if (type == MFPlistNodeTypeDictionary) {
		node = [NSString stringWithFormat: (currentNodeType == MFPlistNodeTypeDictionary ? MFLocalizedString(@"'%@' = <dict>;") : MFLocalizedString(@"%@. <dict>")), key];
	} else if (type == MFPlistNodeTypeArray) {
		node = [NSString stringWithFormat: (currentNodeType == MFPlistNodeTypeDictionary ? MFLocalizedString(@"'%@' = <array>;") : MFLocalizedString(@"%@. <array>")), key];
	} else {
		NSString *desc = nil;
		if ([value isKindOfClass:[NSNumber class]]) {
			if (strcmp([value objCType], @encode(BOOL)) == 0) {
				desc = [value boolValue] ? @"true" : @"false";
			}
		} else {
			desc = [value description];
		}
		node = [NSString stringWithFormat: (currentNodeType == MFPlistNodeTypeDictionary ? MFLocalizedString(@"'%@' = '%@';") : MFLocalizedString(@"%@. %@")), key, desc];
	}
	cell.textLabel.text = node;
	cell.textLabel.font = [UIFont fontWithName: @"CourierNewPS-ItalicMT" size: 15.0];

	return cell;

}

@end


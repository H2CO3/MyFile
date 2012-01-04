//
// MFMyPodAlbumsController.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFMyPodAlbumsController.h"
#import "MFMyPodPlayerController.h"

#define CELL_ID @"MFMPAlbumsCell"

@implementation MFMyPodAlbumsController

// super

- (id) init {

	self = [super init];
	
	self.title = MFLocalizedString(@"Albums");
	self.tabBarItem = [[[UITabBarItem alloc] initWithTitle: MFLocalizedString(@"Albums") image: [UIImage imageNamed: @"Albums.png"] tag: 0] autorelease];
	
	albums = [[NSMutableDictionary alloc] init];
	
	return self;
	
}

- (void) viewWillAppear: (BOOL) animated {

	[super viewWillAppear: animated];
	[self refresh];

}

- (void) refresh {

	// pull to refresh
	[[MFMusicLibrary sharedLibrary] refreshContents];
	[albums removeAllObjects];
	
	for (int i = 0; i < [[MFMusicLibrary sharedLibrary] numberOfTracks]; i++) {
		
		NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];
		MFMusicTrack *track = [[MFMusicLibrary sharedLibrary] trackForIndex: i];
		// if the album is not yet present in the dictionary, add it
		if (![[albums allKeys] containsObject: track.album]) {
			NSMutableArray *tracks = [[NSMutableArray alloc] init];
			[albums setObject: tracks forKey: track.album];
			[tracks release];
		}
		// add the track to its corresponding album
		[[albums objectForKey: track.album] addObject: track];
		[p release];
		
	}
	
	[self.tableView reloadData];
	[self stopLoading];
	
}

- (void) dealloc {
	[albums release];
	[super dealloc];
}

// UITableViewDelegate

- (void) tableView: (UITableView *) tv didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
	// deselect the row with transition
	[tv deselectRowAtIndexPath: indexPath animated: YES];
	// now play the specified song or video
	NSString *key = [[albums allKeys] objectAtIndex: indexPath.section];
	MFMusicTrack *track = [(NSArray *)[albums objectForKey: key] objectAtIndex: indexPath.row];
	MFMyPodPlayerController *player = [[MFMyPodPlayerController alloc] initWithFileName: track.path];
	[player presentFrom: self];
	[player release];
}

// UITableViewDataSource

- (int) numberOfSectionsInTableView: (UITableView *) tv {

	return [albums count];
	
}

- (NSString *) tableView: (UITableView *) tv titleForHeaderInSection: (int) section {

	NSString *key = [[albums allKeys] objectAtIndex: section];
	return key;
	
}

- (int) tableView: (UITableView *) tv numberOfRowsInSection: (int) section {

	NSArray *keys = [albums allKeys];
	NSString *key = [keys objectAtIndex: section];
	return [(NSArray *)[albums objectForKey: key] count];
	
}

- (UITableViewCell *) tableView: (UITableView *) tv cellForRowAtIndexPath: (NSIndexPath *) indexPath {

	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier: CELL_ID];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: CELL_ID] autorelease];
	}
	
	NSArray *keys = [albums allKeys];
	NSString *key = [keys objectAtIndex: indexPath.section];
	NSArray *tracks = [albums objectForKey: key];
	MFMusicTrack *track = [tracks objectAtIndex: indexPath.row];
	cell.textLabel.text = track.title;
	cell.detailTextLabel.text = [NSString stringWithFormat: @"%@ - %@", track.artist, track.album];
	return cell;
}

@end


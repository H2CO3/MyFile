//
// MFMyPodArtistsController.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFMyPodArtistsController.h"
#import "MFMyPodPlayerController.h"

#define CELL_ID @"MFMPArtistsCell"

@implementation MFMyPodArtistsController

// super

- (id) init {

	self = [super init];
	
	self.title = MFLocalizedString(@"Artists");
	self.tabBarItem = [[[UITabBarItem alloc] initWithTitle: MFLocalizedString(@"Artists") image: [UIImage imageNamed: @"Artists.png"] tag: 1] autorelease];
	
	artists = [[NSMutableDictionary alloc] init];
	
	return self;
	
}

- (void) viewWillAppear: (BOOL) animated {

	[super viewWillAppear: animated];
	[self refresh];

}

- (void) refresh {

	// pull to refresh
	[[MFMusicLibrary sharedLibrary] refreshContents];
	[artists removeAllObjects];
	
	for (int i = 0; i < [[MFMusicLibrary sharedLibrary] numberOfTracks]; i++) {
		
		NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];
		MFMusicTrack *track = [[MFMusicLibrary sharedLibrary] trackForIndex: i];
		// if the artist is not yet present in the dictionary, add it
		if (![[artists allKeys] containsObject: track.artist]) {
			NSMutableArray *tracks = [[NSMutableArray alloc] init];
			[artists setObject: tracks forKey: track.artist];
			[tracks release];
		}
		// add the track to its corresponding artist
		[[artists objectForKey: track.artist] addObject: track];
		[p release];
		
	}
	
	[self.tableView reloadData];
	[self stopLoading];
	
}

// UITableViewDelegate

- (void) tableView: (UITableView *) tv didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
	// deselect the row with transition
	[tv deselectRowAtIndexPath: indexPath animated: YES];
	// now play the specified song or video
	NSString *key = [[artists allKeys] objectAtIndex: indexPath.section];
	MFMusicTrack *track = [(NSArray *)[artists objectForKey: key] objectAtIndex: indexPath.row];
	MFMyPodPlayerController *player = [[MFMyPodPlayerController alloc] initWithFileName: track.path];
	[player presentFrom: self];
	[player release];
}

- (void) dealloc {
	[artists release];
	[super dealloc];
}

// UITableViewDataSource

- (int) numberOfSectionsInTableView: (UITableView *) tv {

	return [artists count];
	
}

- (NSString *) tableView: (UITableView *) tv titleForHeaderInSection: (int) section {

	NSString *key = [[artists allKeys] objectAtIndex: section];
	return key;
	
}

- (int) tableView: (UITableView *) tv numberOfRowsInSection: (int) section {

	NSArray *keys = [artists allKeys];
	NSString *key = [keys objectAtIndex: section];
	return [(NSArray *)[artists objectForKey: key] count];
	
}

- (UITableViewCell *) tableView: (UITableView *) tv cellForRowAtIndexPath: (NSIndexPath *) indexPath {

	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier: CELL_ID];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: CELL_ID] autorelease];
	}
	
	NSArray *keys = [artists allKeys];
	NSString *key = [keys objectAtIndex: indexPath.section];
	NSArray *tracks = [artists objectForKey: key];
	MFMusicTrack *track = [tracks objectAtIndex: indexPath.row];
	cell.textLabel.text = track.title;
	cell.detailTextLabel.text = [NSString stringWithFormat: @"%@ - %@", track.artist, track.album];
	return cell;
}

@end


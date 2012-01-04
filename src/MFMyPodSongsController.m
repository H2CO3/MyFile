//
// MFMyPodSongsController.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFMyPodSongsController.h"
#import "MFMyPodPlayerController.h"

#define CELL_ID @"MFMPSongsCell"

@implementation MFMyPodSongsController

// super

- (id) init {

	self = [super init];
	
	self.title = MFLocalizedString(@"Songs");
	self.tabBarItem = [[[UITabBarItem alloc] initWithTitle: MFLocalizedString(@"Songs") image: [UIImage imageNamed: @"Songs.png"] tag: 3] autorelease];
	
	return self;
	
}

- (void) viewWillAppear: (BOOL) animated {

	[super viewWillAppear: animated];
	[self refresh];

}

- (void) refresh {
	// pull to refresh
	[[MFMusicLibrary sharedLibrary] refreshContents];
	[self.tableView reloadData];
	[self stopLoading];
}

// UITableViewDelegate

- (void) tableView: (UITableView *) tv didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
	// deselect the row with transition
	[tv deselectRowAtIndexPath: indexPath animated: YES];
	// now play the specified song or video
	NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];
	MFMusicTrack *trk = [[MFMusicLibrary sharedLibrary] trackForIndex: indexPath.row];
	MFMyPodPlayerController *player = [[MFMyPodPlayerController alloc] initWithFileName: trk.path];
	[player presentFrom: self];
	[player release];
	[p release];
}

- (void) tableView: (UITableView *) tv commitEditingStyle: (UITableViewCellEditingStyle) style forRowAtIndexPath: (NSIndexPath *) indexPath {
        [[MFMusicLibrary sharedLibrary] removeTrackForIndex: indexPath.row];
        [[MFMusicLibrary sharedLibrary] write];
        [tv deleteRowsAtIndexPaths: [NSArray arrayWithObject: indexPath] withRowAnimation: UITableViewRowAnimationRight];
}

// UITableViewDataSource

- (int) tableView: (UITableView *) tv numberOfRowsInSection: (int) section {
	return [[MFMusicLibrary sharedLibrary] numberOfTracks];
}

- (UITableViewCell *) tableView: (UITableView *) tv cellForRowAtIndexPath: (NSIndexPath *) indexPath {
	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier: CELL_ID];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: CELL_ID] autorelease];
	}
	NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];
	MFMusicTrack *track = [[MFMusicLibrary sharedLibrary] trackForIndex: indexPath.row];
	cell.textLabel.text = track.title;
	cell.detailTextLabel.text = [NSString stringWithFormat: @"%@ - %@", track.artist, track.album];
	[p release];
	return cell;
}

@end


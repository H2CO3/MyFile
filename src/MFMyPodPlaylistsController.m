//
// MFMyPodPlaylistsController.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFMyPodPlaylistsController.h"
#import "MFMyPodPlayerController.h"

#define CELL_ID @"MFMPPlaylistsCell"

@implementation MFMyPodPlaylistsController

// super

- (id) init {

	self = [super init];
	
	self.title = MFLocalizedString(@"Playlists");
	self.tabBarItem = [[[UITabBarItem alloc] initWithTitle: MFLocalizedString(@"Playlists") image: [UIImage imageNamed: @"Playlists.png"] tag: 2] autorelease];
	
	return self;
	
}

- (void) viewWillAppear: (BOOL) animated {

	[super viewWillAppear: animated];
	[self refresh];

}

- (void) refresh {

	[[MFMusicLibrary sharedLibrary] refreshContents];
	[self.tableView reloadData];
	[self stopLoading];

}

// UITableViewDelegate

- (void) tableView: (UITableView *) tv didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

	NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];
	NSString *playlistName = [[MFMusicLibrary sharedLibrary] playlistNameForIndex: indexPath.section];
	MFMusicTrack *track = [[MFMusicLibrary sharedLibrary] trackForIndex: indexPath.row inPlaylist: playlistName];
	MFMyPodPlayerController *player = [[MFMyPodPlayerController alloc] initWithFileName: track.path];
	[player presentFrom: self];
	[player release];
	[p release];

}

// UITableViewDataSource

- (int) numberOfSectionsInTableView: (UITableView *) tv {
	return [[MFMusicLibrary sharedLibrary] numberOfPlaylists];
}

- (int) tableView: (UITableView *) tv numberOfRowsInSection: (int) section {

	NSString *playlistName = [[MFMusicLibrary sharedLibrary] playlistNameForIndex: section];
	return [[MFMusicLibrary sharedLibrary] numberOfTracksInPlaylist: playlistName];

}

// trackForIndex:inPlaylist:

- (UITableViewCell *) tableView: (UITableView *) tv cellForRowAtIndexPath: (NSIndexPath *) indexPath {

	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier: CELL_ID];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: CELL_ID] autorelease];
	}

	NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];
	NSString *playlistName = [[MFMusicLibrary sharedLibrary] playlistNameForIndex: indexPath.section];
	MFMusicTrack *track = [[MFMusicLibrary sharedLibrary] trackForIndex: indexPath.row inPlaylist: playlistName];
	cell.textLabel.text = track.title;
	cell.detailTextLabel.text = [NSString stringWithFormat: @"%@ - %@", track.artist, track.album];
	[p release];

	return cell;

}

- (NSString *) tableView: (UITableView *) tv titleForHeaderInSection: (int) section {
	return [[MFMusicLibrary sharedLibrary] playlistNameForIndex: section];
}

@end


//
// MFMyPodPlayerController.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFMyPodPlayerController.h"

#define CELL_ID @"MFMPAudioCell"

@implementation MFMyPodPlayerController

// super

- (void) close {

	[self stop];
	
	[super close];
	
}

- (void) dealloc {
	[file release];
	[id3tag release];
	[musicControls release];
	[audioPlayer release];
	[rew release];
	[fwd release];
	[play release];
	[pause release];
	[flex release];
	[artworkCell release];
	[super dealloc];
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orientation {

	BOOL result;
	
	if (landscapeOnly) {
	
		result = UIInterfaceOrientationIsLandscape (orientation);
		
	} else if (portraitOnly) {
	
		result = UIInterfaceOrientationIsPortrait (orientation);
		
	} else {
	
		result = YES;
		
	}
	
	return result;
	
}

// self

- (id) initWithFileName: (NSString *) path {

	self = [super init];
	self.view.backgroundColor = [UIColor whiteColor];
	self.navigationItem.title = @"MyPod";

	file = [path copy];

	if ([[MFFileType fileTypeForName: file] isEqualToString: @"sound"]) {

		// configure to play the song
	
		id3tag = [[MFID3Tag alloc] initWithFileName: file];
		musicControls = [[NSMutableArray alloc] init];
		[[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: NULL];
		audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath: file] error: NULL];
		audioPlayer.delegate = self;
		audioPlayer.volume = 0.5;
		audioPlayer.numberOfLoops = 0;
		[audioPlayer play];
	
		topBar = [[UIView alloc] initWithFrame: CGRectMake (0, 0, 320, 80)];
		topBar.backgroundColor = [UIColor colorWithRed: 0.0 green: 0.0 blue: 0.0 alpha: 0.9];
		[self.view addSubview: topBar];
		[topBar release];
		bottomBar = [[UIToolbar alloc] initWithFrame: CGRectMake (0, 332, 320, 52)];
		bottomBar.barStyle = UIBarStyleBlack;
		[self.view addSubview: bottomBar];
		[bottomBar release];
		bottomView = [[UIView alloc] initWithFrame: CGRectMake (0, 384, 320, 32)];
		bottomView.backgroundColor = [UIColor blackColor];
		[self.view addSubview: bottomView];
		[bottomView release];
	
		tableView = [[UITableView alloc] initWithFrame: CGRectMake (0, 80, 320, 252)];
		tableView.delegate = self;
		tableView.dataSource = self;
		[self.view addSubview: tableView];
		[tableView release];

		timeLabel = [[UILabel alloc] initWithFrame: CGRectMake (20, 40, 80, 30)];
		timeLabel.backgroundColor = [UIColor clearColor];
		timeLabel.textColor = [UIColor whiteColor];
		timeLabel.font = [UIFont boldSystemFontOfSize: 12.0];

		timeSlider = [[UISlider alloc] initWithFrame: CGRectMake (20, 0, 280, 40)];
		timeSlider.backgroundColor = [UIColor clearColor];
		[timeSlider addTarget: self action: @selector(seekMusic) forControlEvents: UIControlEventValueChanged];
		volumeSlider = [[UISlider alloc] initWithFrame: CGRectMake (20, 0, 280, 30)];
		volumeSlider.value = 0.5;
		volumeSlider.backgroundColor = [UIColor clearColor];
		[volumeSlider addTarget: self action: @selector(changeVolume) forControlEvents: UIControlEventValueChanged];
	
		[topBar addSubview: timeLabel];
		[timeLabel release];
		[topBar addSubview: timeSlider];
		[timeSlider release];
		[bottomView addSubview: volumeSlider];
		[volumeSlider release];
	
		rew = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemRewind target: self action: @selector(rewind)];
		fwd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFastForward target: self action: @selector(forward)];
		play = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemPlay target: self action: @selector(play)];
		pause = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemPause target: self action: @selector(pause)];
		flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: NULL];
		[musicControls removeAllObjects];
		[musicControls addObjectsFromArray: [NSArray arrayWithObjects: rew, flex, pause, flex, fwd, nil]];
		[bottomBar setItems: musicControls animated: NO];

		[self changeVolume];

		timer = [NSTimer scheduledTimerWithTimeInterval: 0.05 target: self selector: @selector (updateTime) userInfo: nil repeats: YES];

		artworkCell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"MFMPArtworkCell"];
		NSData *artworkImageData = [id3tag albumArtworkImageData];
		if (artworkImageData != nil) {
			UIImage *artworkImage = [[UIImage alloc] initWithData: artworkImageData];
			if (artworkImage != nil) {
				artworkImageView = [[UIImageView alloc] initWithImage: artworkImage];
				[artworkImage release];
				float oldWidth = artworkImage.size.width;
				float oldHeight = artworkImage.size.height;
				float newWidth = 320.0;
				float newHeight = oldHeight / oldWidth * newWidth;
				if ((oldWidth != 0.0) && (oldHeight != 0.0) && (newWidth != 0.0) && (newHeight != 0.0)) {
					artworkImageView.frame = CGRectMake (0.0, 0.0, newWidth, newHeight);
					[artworkCell.contentView addSubview: artworkImageView];
				}
			}
		}
		
		landscapeOnly = NO;
		portraitOnly = YES;

	} else if ([[MFFileType fileTypeForName: file] isEqualToString: @"video"]) {

		// configure to play the video

		moviePlayer = [[[MPMoviePlayerViewController alloc] initWithContentURL: [NSURL fileURLWithPath: file]] autorelease];
                [self performSelector: @selector(presentMoviePlayerViewControllerAnimated:) withObject: moviePlayer afterDelay: 2.0];

	} else {
		// invalid media type
		self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
		[[[[UIAlertView alloc] initWithTitle: MFLocalizedString(@"Invalid media type") message: MFLocalizedString(@"This media format appears to be unsupported.") delegate: nil cancelButtonTitle: MFLocalizedString(@"Dismiss") otherButtonTitles: nil] autorelease] show];
		landscapeOnly = NO;
		portraitOnly = NO;
	}

	return self;

}

- (void) updateTime {

	if (audioPlayer.duration != 0) {
		timeSlider.value = audioPlayer.currentTime / audioPlayer.duration;
	}
	int now = (int) audioPlayer.currentTime;
	int max = (int) audioPlayer.duration;
	int nowMin = now / 60;
	int nowSec = now % 60;
	char nowLead = (nowSec < 10 ? '0' : NULL);
	int maxMin = max / 60;
	int maxSec = max % 60;
	char maxLead = (maxSec < 10 ? '0' : NULL);
	NSString *timeFormat = [[NSString alloc] initWithFormat: MFLocalizedString(@"%i:%c%i of %i:%c%i"), nowMin, nowLead, nowSec, maxMin, maxLead, maxSec];
	timeLabel.text = timeFormat;
	[timeFormat release];

}

- (void) seekMusic {

	audioPlayer.currentTime = timeSlider.value * audioPlayer.duration;

}

- (void) changeVolume {

	audioPlayer.volume = volumeSlider.value;

}

- (void) play {

	[audioPlayer play];
	[musicControls removeAllObjects];
	[musicControls addObjectsFromArray: [NSArray arrayWithObjects: rew, flex, pause, flex, fwd, nil]];
	[bottomBar setItems: musicControls animated: YES];

}

- (void) pause {

	[audioPlayer pause];
	[musicControls removeAllObjects];
	[musicControls addObjectsFromArray: [NSArray arrayWithObjects: rew, flex, play, flex, fwd, nil]];
	[bottomBar setItems: musicControls animated: YES];

}

- (void) stop {

	[audioPlayer stop];
	[timer invalidate];

}

- (void) rewind {

	audioPlayer.currentTime = 0.0;
	
}

- (void) forward {

	audioPlayer.currentTime = audioPlayer.duration;
	
}

// UITableViewDelegate

- (void) tableView: (UITableView *) theTableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

	[theTableView deselectRowAtIndexPath: indexPath animated: YES];
	
}

- (float) tableView: (UITableView *) theTableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {

	float height;

	if (indexPath.row == 8) {

		UIImage *albumArt = [[UIImage alloc] initWithData: [id3tag albumArtworkImageData]];
		height = albumArt.size.height / albumArt.size.width * 320.0;
		[albumArt release];

	} else {

		height = 44.0;

	}

	return height;

}

// UITableViewDataSource

- (int) tableView: (UITableView *) theTableView numberOfRowsInSection: (int) section {

	return [id3tag albumArtworkImageData] ? 9 : 8;
	
}

- (UITableViewCell *)  tableView: (UITableView *) theTableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier: CELL_ID];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier: CELL_ID] autorelease];
	}
	
	cell.contentView.backgroundColor = [UIColor colorWithRed: 0.0 green: 0.0 blue: 0.0 alpha: 0.667];
	cell.textLabel.backgroundColor = [UIColor clearColor];
	cell.textLabel.textColor = [UIColor whiteColor];
	cell.detailTextLabel.backgroundColor = [UIColor clearColor];
	cell.detailTextLabel.textColor = [UIColor colorWithRed: 0.0 green: 0.4 blue: 1.0 alpha: 1.0];
	
	int row = indexPath.row;
	
	if (row == 0) {
	
		cell.detailTextLabel.text = MFLocalizedString(@"Title");
		cell.textLabel.text = [id3tag songTitle];
		
	} else if (row == 1) {
	
		cell.detailTextLabel.text = MFLocalizedString(@"Artist");
		cell.textLabel.text = [id3tag artist];
		
	} else if (row == 2) {
	
		cell.detailTextLabel.text = MFLocalizedString(@"Album");
		cell.textLabel.text = [id3tag album];
	
	} else if (row == 3) {
	
		cell.detailTextLabel.text = MFLocalizedString(@"Year");
		cell.textLabel.text = [id3tag year];
	
	} else if (row == 4) {
	
		cell.detailTextLabel.text = MFLocalizedString(@"Genre");
		cell.textLabel.text = [id3tag genre];
	
	} else if (row == 5) {
	
		cell.detailTextLabel.text = MFLocalizedString(@"Lyricist");
		cell.textLabel.text = [id3tag lyricist];
	
	} else if (row == 6) {
	
		cell.detailTextLabel.text = MFLocalizedString(@"Language");
		cell.textLabel.text = [id3tag language];
	
	} else if (row == 7) {
	
		cell.detailTextLabel.text = MFLocalizedString(@"Comments");
		cell.textLabel.text = [id3tag comments];
		
	} else if (row == 8) {

		cell = artworkCell;

	}
	
	return cell;
	
}

// AVAudioPlayerDelegate

- (void) audioPlayerDidFinishPlaying: (AVAudioPlayer *) player successfully: (BOOL) successFlag {

	[self close];

}

@end


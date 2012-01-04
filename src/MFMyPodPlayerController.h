//
// MFMyPodPlayerController.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <MFMusicLibrary/MFID3Tag.h>
#import "MFModalController.h"
#import "MFFileType.h"
#import "MFLocalizedString.h"

@class MPMoviePlayerViewController;

@interface MFMyPodPlayerController: MFModalController <UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate> {
	// general
	NSString *file;
	BOOL landscapeOnly;
	BOOL portraitOnly;
	// for the audio player
	MFID3Tag *id3tag;
	AVAudioPlayer *audioPlayer;
	NSMutableArray *musicControls;
	NSTimer *timer;
	UITableViewCell *artworkCell;
	UIView *topBar;
	UIView *bottomView;
	UIToolbar *bottomBar;
	UITableView *tableView;
	UILabel *timeLabel;
	UISlider *timeSlider;
	UISlider *volumeSlider;
	UIBarButtonItem *rew;
	UIBarButtonItem *fwd;
	UIBarButtonItem *play;
	UIBarButtonItem *pause;
	UIBarButtonItem *flex;
	UIImageView *artworkImageView;
	// for the video player
	MPMoviePlayerViewController *moviePlayer;
}

- (id) initWithFileName: (NSString *) path;

// audio player methods
- (void) changeVolume;
- (void) updateTime;
- (void) seekMusic;
- (void) play;
- (void) pause;
- (void) stop;
- (void) rewind;
- (void) forward;

// video player methods

@end

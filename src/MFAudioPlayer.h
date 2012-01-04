//
// MFAudioPlayer.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <stdlib.h>
#import <time.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MFMusicLibrary/MFID3Tag.h>
#import "MFFile.h"
#import "MFLocalizedString.h"

@class MFFileViewerController;

enum MFAudioPlayerPlayMode {
	MFAudioPlayerPlayModeOnce,
	MFAudioPlayerPlayModeRepeat,
	MFAudioPlayerPlayModeContinuous,
	MFAudioPlayerPlayModeShuffle
};

typedef enum MFAudioPlayerPlayMode MFAudioPlayerPlayMode;

@interface MFAudioPlayer: UIView <AVAudioPlayerDelegate, UITableViewDataSource, UITableViewDelegate> {
	AVAudioPlayer *audioPlayer;
	NSTimer *timer;
	NSArray *playModeTitles;
	MFFile *file;
	MFID3Tag *id3tag;
	UIView *topBar;
	UIToolbar *bottomBar;
	UIView *bottomView;
	UITableView *tableView;
	UILabel *timeLabel;
	UISlider *timeSlider;
	UISlider *volumeSlider;
	UIBarButtonItem *rew;
	UIBarButtonItem *fwd;
	UIBarButtonItem *play;
	UIBarButtonItem *pause;
	UIBarButtonItem *flex;
	NSMutableArray *musicControls;
	UITableViewCell *artworkCell;
	UIImageView *artworkImageView;
	MFAudioPlayerPlayMode playMode;
	MFFileViewerController *controller;
}

@property (retain) MFID3Tag *id3tag;
@property (assign) MFFileViewerController *controller;

- (id) initWithFile: (MFFile *) aFile;
- (void) setFile: (NSString *) aFile;
- (void) changePlayMode: (UIButton *) sender;
- (void) updateTime;
- (void) seekMusic;
- (void) changeVolume;
- (void) pause;
- (void) play;
- (void) stop;
- (NSString *) nextFile;
- (NSString *) randomFile;
- (void) reloadMetadata;

@end

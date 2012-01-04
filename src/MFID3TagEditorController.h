//
// MFID3TagEditorController.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MFMusicLibrary/MFID3Tag.h>
#import "MFModalController.h"

@class MFFileViewerController;

@interface MFID3TagEditorController: MFModalController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate> {
	MFID3Tag *id3tag;
	NSData *artworkData;
	UITableView *tableView;
	UITextField *title;
	UITextField *artist;
	UITextField *album;
	UITextField *year;
	UITextField *genre;
	UITextField *lyricist;
	UITextField *language;
	UITextField *comments;
	UIButton *artwork;
	MFFileViewerController *mainController;
	BOOL changedPicture;
}

@property (assign) MFFileViewerController *mainController;

- (id) initWithTag: (MFID3Tag *) aTag;
- (UIImage *) normalizedImage: (UIImage *) image;
- (void) done;

@end

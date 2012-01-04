//
// MFFileViewerController.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MFModalController.h"
#import "MFID3TagEditorController.h"
#import "MFImageMetadataController.h"
#import "MFImageAddLabelsController.h"
#import "MFFileType.h"
#import "MFFile.h"
#import "MFArchiveViewer.h"
#import "MFAudioPlayer.h"
#import "MFHexEditor.h"
#import "MFPlistViewer.h"
#import "MFSQLViewer.h"
#import "UIImage+Editor.h"

@class UITapGestureRecognizer, UISwipeGestureRecognizer, MPMoviePlayerViewController;

@protocol MFFileViewerControllerDelegate;

typedef enum {
	MFImageTransformNone = -1,
	MFImageTransformScale,
	MFImageTransformCrop,
	MFImageTransformRotate,
	MFImageTransformRoundedCorners,
	MFImageTransformSetTransparency,
	MFImageTransformGrayscale,
	MFImageTransformAddLabels
} MFImageTransform;

@interface MFFileViewerController: MFModalController <UITextViewDelegate, UIScrollViewDelegate, UIActionSheetDelegate, UISearchBarDelegate, UIAlertViewDelegate, MFImageAddLabelsControllerDelegate> {
	NSString *type;
	MFFile *file;
	MFArchiveViewer *archiveViewer;
	MFAudioPlayer *audioPlayer;
	MFHexEditor *hexEditor;
	MFPlistViewer *plistViewer;
	MFSQLViewer *sqlViewer;
	MFImageMetadataController *imgMetadataController;
	MPMoviePlayerController *moviePlayer;
	UIWebView *webView;
	UITextView *textView;
	UIScrollView *scrollView;
	UIImageView *imageView;
	UIActionSheet *imageOps;
	UIActionSheet *effects;
	UISearchBar *searchBar;
	NSString *searchText;
	NSRange textRange;
	BOOL landscapeOnly;
	BOOL rightOnly;
	BOOL portraitOnly;
	BOOL filesystemModified;
	BOOL navBarHidden;
	MFImageTransform imageTransform;
	id <MFFileViewerControllerDelegate> delegate;
}

@property (retain) MFFile *file;
@property (assign) id <MFFileViewerControllerDelegate> delegate;
@property (retain) NSString *type;

- (id) initWithFile: (MFFile *) aFile;
- (id) initWithFile: (MFFile *) aFile type: (NSString *) theType;
- (void) setFilesystemModified;
- (void) saveText;
- (void) saveHex;
- (void) findText;
- (void) reloadAudioMetadata;
- (void) fit;
- (void) editId3Tags;
- (void) editImageMetadata;
- (void) showImageOps;
- (void) setImageFile: (NSString *) imageFile;
- (NSString *) nextImageFile;
- (NSString *) prevImageFile;
- (void) toggleNavBar;

@end

@protocol MFFileViewerControllerDelegate <NSObject>

- (void) fileViewerDidFinishViewing: (MFFileViewerController *) fileViewer;

@end


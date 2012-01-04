//
// MFID3TagEditorController.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFID3TagEditorController.h"
#import "MFFileViewerController.h"
#undef MFLocalizedString
#define MFLocalizedString(x) (NSLocalizedString((x), @""))


@implementation MFID3TagEditorController

@synthesize mainController = mainController;

// self

- (id) initWithTag: (MFID3Tag *) aTag {

	self = [super init];

	self.navigationItem.title = MFLocalizedString(@"Editing metadata");
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(done)] autorelease];
	id3tag = [aTag retain];
	changedPicture = NO;
	artworkData = [id3tag albumArtworkImageData];
	tableView = [[UITableView alloc] initWithFrame: CGRectMake (0, 0, 320, 416) style: UITableViewStyleGrouped];
	tableView.delegate = self;
	tableView.dataSource = self;
	[self.view addSubview: tableView];
	[tableView release];
	
	title = [[UITextField alloc] initWithFrame: CGRectMake (0, 0, 180, 30)];
	title.delegate = self;
	title.text = [id3tag songTitle];

	artist = [[UITextField alloc] initWithFrame: CGRectMake (0, 0, 180, 30)];
	artist.delegate = self;
	artist.text = [id3tag artist];

	album = [[UITextField alloc] initWithFrame: CGRectMake (0, 0, 180, 30)];
	album.delegate = self;
	album.text = [id3tag album];

	year = [[UITextField alloc] initWithFrame: CGRectMake (0, 0, 180, 30)];
	year.delegate = self;
	year.text = [id3tag year];

	genre = [[UITextField alloc] initWithFrame: CGRectMake (0, 0, 180, 30)];
	genre.delegate = self;
	genre.text = [id3tag genre];

	lyricist = [[UITextField alloc] initWithFrame: CGRectMake (0, 0, 180, 30)];
	lyricist.delegate = self;
	lyricist.text = [id3tag lyricist];

	language = [[UITextField alloc] initWithFrame: CGRectMake (0, 0, 180, 30)];
	language.delegate = self;
	language.text = [id3tag language];

	comments = [[UITextField alloc] initWithFrame: CGRectMake (0, 0, 180, 30)];
	comments.delegate = self;
	comments.text = [id3tag comments];

	artwork = [UIButton buttonWithType: UIButtonTypeCustom];
	artwork.frame = CGRectMake (0, 0, 180, 44);
	[artwork setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
	[artwork setTitle: MFLocalizedString(@"Tap to select image") forState: UIControlStateNormal];
	[artwork addTarget: self action: @selector(selectImage) forControlEvents: UIControlEventTouchUpInside];

	return self;

}

- (void) done {
	seteuid(0);
	[id3tag setSongTitle: title.text];
	[id3tag setArtist: artist.text];
	[id3tag setAlbum: album.text];
	[id3tag setYear: year.text];
	[id3tag setGenre: genre.text];
	[id3tag setLyricist: lyricist.text];
	[id3tag setLanguage: language.text];
	[id3tag setComments: comments.text];
	if (changedPicture) {
		[id3tag setAlbumArtworkImageData: artworkData];
	}

	[self.mainController reloadAudioMetadata];
	seteuid(501);
	[self close];

}

- (void) selectImage {

	UIImagePickerController *ctrl = [[UIImagePickerController alloc] init];
	ctrl.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	ctrl.delegate = self;
	[self presentModalViewController: ctrl animated: YES];
	[ctrl release];

}

- (UIImage *) normalizedImage: (UIImage *) image {

	float width;
	float height;
	if (image.size.width > image.size.height) {
		width = 320.0;
		height = width / image.size.width * image.size.height;
	} else {
		height = 320.0;
		width = height / image.size.height * image.size.width;
	}
	CGSize size = CGSizeMake (width, height);
	UIGraphicsBeginImageContext (size);
	[image drawInRect: CGRectMake (0, 0, size.width, size.height)];
	UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext ();
	UIGraphicsEndImageContext ();
 
	return normalizedImage;
	
}

// UITableViewDelegate

- (void) tableView: (UITableView *) theTableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

	[theTableView deselectRowAtIndexPath: indexPath animated: YES];

}

// UITableViewDataSource

- (int) tableView: (UITableView *) theTableView numberOfRowsInSection: (int) section {

	return 9;
	
}

- (UITableViewCell *) tableView: (UITableView *) theTableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier: @"ID3Cell"];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"ID3Cell"] autorelease];
	}

	int idx = indexPath.row;

	if (idx == 0) {
		cell.textLabel.text = MFLocalizedString(@"Title");
		cell.accessoryView = title;
	} else if (idx == 1) {
		cell.textLabel.text = MFLocalizedString(@"Artist");
		cell.accessoryView = artist;
	} else if (idx == 2) {
		cell.textLabel.text = MFLocalizedString(@"Album");
		cell.accessoryView = album;
	} else if (idx == 3) {
		cell.textLabel.text = MFLocalizedString(@"Year");
		cell.accessoryView = year;
	} else if (idx == 4) {
		cell.textLabel.text = MFLocalizedString(@"Genre");
		cell.accessoryView = genre;
	} else if (idx == 5) {
		cell.textLabel.text = MFLocalizedString(@"Lyricist");
		cell.accessoryView = lyricist;
	} else if (idx == 6) {
		cell.textLabel.text = MFLocalizedString(@"Language");
		cell.accessoryView = language;
	} else if (idx == 7) {
		cell.textLabel.text = MFLocalizedString(@"Comments");
		cell.accessoryView = comments;
	} else if (idx == 8) {
		cell.textLabel.text = MFLocalizedString(@"Artwork");
		cell.accessoryView = artwork;
	}

	return cell;

}

// UIImagePickerControllerDelegate

- (void) imagePickerController: (UIImagePickerController *) ctrl didFinishPickingMediaWithInfo: (NSDictionary *) info {

	[self dismissModalViewControllerAnimated: YES];
	changedPicture = YES;
	artworkData = [UIImagePNGRepresentation ([self normalizedImage: [info objectForKey: UIImagePickerControllerOriginalImage]]) copy];

}

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) ctrl {

	[self dismissModalViewControllerAnimated: YES];

}

// UITextFieldDelegate

- (BOOL) textFieldShouldReturn: (UITextField *) textField {

	[textField resignFirstResponder];

	return YES;

}

// super

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orientation {

	return UIInterfaceOrientationIsPortrait (orientation);
	
}

- (void) dealloc {

	[title release];
	title = nil;
	[artist release];
	artist = nil;
	[album release];
	album = nil;
	[year release];
	year = nil;
	[genre release];
	genre = nil;
	[lyricist release];
	lyricist = nil;
	[comments release];
	comments = nil;
	[language release];
	language = nil;
	[id3tag release];
	id3tag = nil;

	[super dealloc];

}

@end

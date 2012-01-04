//
// MFImageMetadataController.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//


#import "MFImageMetadataController.h"
#import "MFImageMetadataEntryController.h"

@implementation MFImageMetadataController

// self

- (id) initWithFileName: (NSString *) fname {

	self = [super init];
	
	self.navigationItem.title = [fname lastPathComponent];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(done)] autorelease];
	
	metadata = [[MFPictureMetadata alloc] initWithFileName: fname];
	
	tableView = [[UITableView alloc] initWithFrame: UIInterfaceOrientationIsPortrait (self.interfaceOrientation) ? CGRectMake (0, 0, 320, 460) : [[UIScreen mainScreen] applicationFrame]];
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	tableView.delegate = self;
	tableView.dataSource = self;
	[self.view addSubview: tableView];
	
	return self;
	
}

- (ExifTag) tagForIndexPath: (NSIndexPath *) indexPath {

	int idx = indexPath.row;
	ExifTag tag;
	
	if (idx == 0) {
		tag = EXIF_TAG_IMAGE_WIDTH;
	} else if (idx == 1) {
		tag = EXIF_TAG_IMAGE_LENGTH;
	} else if (idx == 2) {
		tag = EXIF_TAG_COMPRESSION;
	} else if (idx == 3) {
		tag = EXIF_TAG_DOCUMENT_NAME;
	} else if (idx == 4) {
		tag = EXIF_TAG_IMAGE_DESCRIPTION;
	} else if (idx == 5) {
		tag = EXIF_TAG_MODEL;
	} else if (idx == 6) {
		tag = EXIF_TAG_ORIENTATION;
	} else if (idx == 7) {
		tag = EXIF_TAG_X_RESOLUTION;
	} else if (idx == 8) {
		tag = EXIF_TAG_Y_RESOLUTION;
	} else if (idx == 9) {
		tag = EXIF_TAG_RESOLUTION_UNIT;
	} else if (idx == 10) {
		tag = EXIF_TAG_SOFTWARE;
	} else if (idx == 11) {
		tag = EXIF_TAG_DATE_TIME;
	} else if (idx == 12) {
		tag = EXIF_TAG_ARTIST;
	} else if (idx == 13) {
		tag = EXIF_TAG_BATTERY_LEVEL;
	} else if (idx == 14) {
		tag = EXIF_TAG_COPYRIGHT;
	} else if (idx == 15) {
		tag = EXIF_TAG_EXPOSURE_TIME;
	} else if (idx == 16) {
		tag = EXIF_TAG_IMAGE_RESOURCES;
	} else if (idx == 17) {
		tag = EXIF_TAG_EXPOSURE_PROGRAM;
	} else if (idx == 18) {
		tag = EXIF_TAG_TIME_ZONE_OFFSET;
	} else if (idx == 19) {
		tag = EXIF_TAG_DATE_TIME_ORIGINAL;
	} else if (idx == 20) {
		tag = EXIF_TAG_DATE_TIME_DIGITIZED;
	} else if (idx == 21) {
		tag = EXIF_TAG_SHUTTER_SPEED_VALUE;
	} else if (idx == 22) {
		tag = EXIF_TAG_BRIGHTNESS_VALUE;
	} else if (idx == 23) {
		tag = EXIF_TAG_SUBJECT_DISTANCE;
	} else if (idx == 24) {
		tag = EXIF_TAG_LIGHT_SOURCE;
	} else if (idx == 25) {
		tag = EXIF_TAG_FLASH;
	} else if (idx == 26) {
		tag = EXIF_TAG_FOCAL_LENGTH;
	} else if (idx == 27) {
		tag = EXIF_TAG_SUBJECT_AREA;
	} else if (idx == 28) {
		tag = EXIF_TAG_MAKER_NOTE;
	} else if (idx == 29) {
		tag = EXIF_TAG_USER_COMMENT;
	} else if (idx == 30) {
		tag = EXIF_TAG_COLOR_SPACE;
	} else if (idx == 31) {
		tag = EXIF_TAG_PIXEL_X_DIMENSION;
	} else if (idx == 32) {
		tag = EXIF_TAG_PIXEL_Y_DIMENSION;
	} else if (idx == 33) {
		tag = EXIF_TAG_RELATED_SOUND_FILE;
	} else if (idx == 34) {
		tag = EXIF_TAG_FLASH_ENERGY;
	} else if (idx == 35) {
		tag = EXIF_TAG_SUBJECT_LOCATION;
	} else if (idx == 36) {
		tag = EXIF_TAG_SENSING_METHOD;
	} else if (idx == 37) {
		tag = EXIF_TAG_SCENE_TYPE;
	} else if (idx == 38) {
		tag = EXIF_TAG_EXPOSURE_MODE;
	} else if (idx == 39) {
		tag = EXIF_TAG_WHITE_BALANCE;
	} else if (idx == 40) {
		tag = EXIF_TAG_DIGITAL_ZOOM_RATIO;
	} else if (idx == 41) {
		tag = EXIF_TAG_CONTRAST;
	} else if (idx == 42) {
		tag = EXIF_TAG_SATURATION;
	} else if (idx == 43) {
		tag = EXIF_TAG_SHARPNESS;
	} else if (idx == 44) {
		tag = EXIF_TAG_DEVICE_SETTING_DESCRIPTION;
	} else if (idx == 45) {
		tag = EXIF_TAG_IMAGE_UNIQUE_ID;
	} else if (idx == 46) {
		tag = EXIF_TAG_GAMMA;
	}

	return tag;

}

- (void) done {

	[metadata save];
	[self close];
	
}

// UITableViewDataSource

- (int) tableView: (UITableView *) tv numberOfRowsInSection: (int) section {

	return 47;
	
}

- (UITableViewCell *) tableView: (UITableView *) tv cellForRowAtIndexPath: (NSIndexPath *) indexPath {

	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier: @"MFImageCell"];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: @"MFImageCell"] autorelease];
	}

	ExifTag tag = [self tagForIndexPath: indexPath];

        NSString *dataStr = [metadata valueForTag: tag];
        NSString *rawStr = [metadata rawValueForTag: tag];
        if (([dataStr length] > 0) && ([rawStr length] > 0)) {
	        cell.textLabel.text = [NSString stringWithFormat: MFLocalizedString(@"%@ (raw: %@)"), dataStr, rawStr];
        } else {
                cell.textLabel.text = @" ";
        }
	char *title_0 = exif_tag_get_title_in_ifd (tag, EXIF_IFD_0);
	char *name_0 = exif_tag_get_name_in_ifd (tag, EXIF_IFD_0);
	char *title_exif = exif_tag_get_title_in_ifd (tag, EXIF_IFD_EXIF);
	char *name_exif = exif_tag_get_name_in_ifd (tag, EXIF_IFD_EXIF);
	char *title_gps = exif_tag_get_title_in_ifd (tag, EXIF_IFD_GPS);
	char *name_gps = exif_tag_get_name_in_ifd (tag, EXIF_IFD_GPS);
	if (title_0 != NULL) {
		cell.detailTextLabel.text = [NSString stringWithUTF8String: title_0];
	} else if (name_0 != NULL) {
		cell.detailTextLabel.text = [NSString stringWithUTF8String: name_0];
	} else if (title_exif != NULL) {
		cell.detailTextLabel.text = [NSString stringWithUTF8String: title_exif];
	} else if (name_exif != NULL) {
		cell.detailTextLabel.text = [NSString stringWithUTF8String: name_exif];
	} else if (title_gps != NULL) {
		cell.detailTextLabel.text = [NSString stringWithUTF8String: title_gps];
	} else if (name_gps != NULL) {
		cell.detailTextLabel.text = [NSString stringWithUTF8String: name_gps];
	} else {
		cell.detailTextLabel.text = [NSString stringWithFormat: MFLocalizedString(@"ID: %i"), tag];
	}
	
	return cell;
	
}

// UITableViewDelegate

- (void) tableView: (UITableView *) theTableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

	[theTableView deselectRowAtIndexPath: indexPath animated: YES];
	ExifTag tag = [self tagForIndexPath: indexPath];
	MFImageMetadataEntryController *entryController = [[MFImageMetadataEntryController alloc] initWithTag: tag value: [metadata rawValueForTag: tag]];
	entryController.delegate = self;
	[entryController presentFrom: self];
	[entryController release];
	
}

// MFImageMetadataEntryControllerDelegate

- (void) entryController: (MFImageMetadataEntryController *) entryController didDismissWithTag: (ExifTag) tag value: (NSString *) value {

	[metadata setValue: value forTag: tag];
	[tableView reloadData];
	
}

// super

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orientation {

	return (orientation != UIInterfaceOrientationLandscapeLeft);
	
}

- (void) dealloc {

	[tableView release];
	tableView = nil;
	[metadata release];
	metadata = nil;
	
	[super dealloc];
	
}

@end

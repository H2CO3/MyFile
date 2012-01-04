//
// MFPictureMetadata.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <string.h>
#import <libexif/exif-loader.h>
#import <libexif/exif-data.h>
#import <libexif/exif-content.h>
#import <libexif/exif-entry.h>
#import <libexif/exif-format.h>
#import <libexif/exif-tag.h>
#import <jpeg-data.h>
#import <Foundation/Foundation.h>

void exif_convert_utf16_to_utf8 (char *out, const unsigned short *in, int maxlen);
void exif_entry_format_value (ExifEntry *e, char *val, size_t maxlen);

@interface MFPictureMetadata: NSObject {
	NSString *file;
	ExifLoader *exif_loader;
	ExifData *exif_data;
}

- (id) initWithFileName: (NSString *) fileName;
- (NSString *) valueForTag: (ExifTag) tag;
- (NSString *) rawValueForTag: (ExifTag) tag;
- (void) setValue: (NSString *) value forTag: (ExifTag) tag;
- (void) save;

@end


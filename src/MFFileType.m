//
// MFFileType.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFFileType.h"

@implementation MFFileType

+ (NSString *) fileTypeForName: (NSString *) name {

	NSString *type;
	NSString *typeStr = [[[name componentsSeparatedByString: @"."] lastObject] lowercaseString];
	if ([typeStr isEqualToString: @"png"]) {
		type = @"image";
	} else if ([typeStr isEqualToString: @"jpg"]) {
		type = @"image";
	} else if ([typeStr isEqualToString: @"gif"]) {
		type = @"image";
	} else if ([typeStr isEqualToString: @"bmp"]) {
		type = @"image";
	} else if ([typeStr isEqualToString: @"psd"]) {
		type = @"image";
	} else if ([typeStr isEqualToString: @"svg"]) {
		type = @"image";
	} else if ([typeStr isEqualToString: @"mp3"]) {
		type = @"sound";
	} else if ([typeStr isEqualToString: @"wav"]) {
		type = @"sound";
	} else if ([typeStr isEqualToString: @"caf"]) {
		type = @"sound";
	} else if ([typeStr isEqualToString: @"wma"]) {
		type = @"sound";
	} else if ([typeStr isEqualToString: @"mid"]) {
		type = @"sound";
	} else if ([typeStr isEqualToString: @"aiff"]) {
		type = @"sound";
	} else if ([typeStr isEqualToString: @"m4a"]) {
		type = @"sound";
	} else if ([typeStr isEqualToString: @"m4r"]) {
		type = @"sound";
	} else if ([typeStr isEqualToString: @"mp4"]) {
		type = @"video";
	} else if ([typeStr isEqualToString: @"mov"]) {
		type = @"video";
	} else if ([typeStr isEqualToString: @"avi"]) {
		type = @"video";
	} else if ([typeStr isEqualToString: @"flv"]) {
		type = @"video";
	} else if ([typeStr isEqualToString: @"pdf"]) {
		type = @"pdf";
	} else if ([typeStr isEqualToString: @"xls"]) {
		type = @"xls";
	} else if ([typeStr isEqualToString: @"xlsx"]) {
		type = @"xls";
	} else if ([typeStr isEqualToString: @"doc"]) {
		type = @"doc";
	} else if ([typeStr isEqualToString: @"docx"]) {
		type = @"doc";
	} else if ([typeStr isEqualToString: @"ppt"]) {
		type = @"ppt";
	} else if ([typeStr isEqualToString: @"pptx"]) {
		type = @"ppt";
	} else if ([typeStr isEqualToString: @"html"]) {
		type = @"html";
	} else if ([typeStr isEqualToString: @"htm"]) {
		type = @"html";
	} else if ([typeStr isEqualToString: @"txt"]) {
		type = @"text";
	} else if ([typeStr isEqualToString: @"rtf"]) {
		type = @"text";
	} else if ([typeStr isEqualToString: @"css"]) {
		type = @"text";
	} else if ([typeStr isEqualToString: @"js"]) {
		type = @"text";
	} else if ([typeStr isEqualToString: @"c"]) {
		type = @"text";
	} else if ([typeStr isEqualToString: @"cpp"]) {
		type = @"text";
	} else if ([typeStr isEqualToString: @"m"]) {
		type = @"text";
	} else if ([typeStr isEqualToString: @"mm"]) {
		type = @"text";
	} else if ([typeStr isEqualToString: @"h"]) {
		type = @"text";
	} else if ([typeStr isEqualToString: @"xml"]) {
		type = @"text";
	} else if ([typeStr isEqualToString: @"plist"]) {
		type = @"plist";
	} else if ([typeStr isEqualToString: @"strings"]) {
		type = @"plist";
	} else if ([typeStr isEqualToString: @"sh"]) {
		type = @"text";
	} else if ([typeStr isEqualToString: @"log"]) {
		type = @"text";
	} else if ([typeStr isEqualToString: @"conf"]) {
		type = @"text";
	} else if ([typeStr isEqualToString: @"php"]) {
		type = @"text";
	} else if ([typeStr isEqualToString: @"tar"]) {
		type = @"package";
	} else if ([typeStr isEqualToString: @"gz"]) {
		type = @"package";
	} else if ([typeStr isEqualToString: @"tgz"]) {
		type = @"package";
	} else if ([typeStr isEqualToString: @"bz2"]) {
		type = @"package";
	} else if ([typeStr isEqualToString: @"tbz"]) {
		type = @"package";
	} else if ([typeStr isEqualToString: @"deb"]) {
		type = @"package";
	} else if ([typeStr isEqualToString: @"zip"]) {
		type = @"package";
	} else if ([typeStr isEqualToString: @"xar"]) {
		type = @"package";
	} else if ([typeStr isEqualToString: @"7z"]) {
		type = @"package";
	} else if ([typeStr isEqualToString: @"lzma"]) {
		type = @"package";
	} else if ([typeStr isEqualToString: @"rar"]) {
		type = @"package";
	} else if ([typeStr isEqualToString: @"ipa"]) {
		type = @"package";
	} else if ([typeStr isEqualToString: @"db"]) {
		type = @"database";
	} else if ([typeStr isEqualToString: @"sqlitedb"]) {
		type = @"database";
	} else if ([typeStr isEqualToString: @"sqlite"]) {
		type = @"database";
	} else if ([typeStr isEqualToString: @"itdb"]) {
		type = @"database";
	} else if ([typeStr isEqualToString: @"sql"]) {
		type = @"database";
	} else if ([typeStr isEqualToString: @"o"]) {
		type = @"binary";
	} else if ([typeStr isEqualToString: @"dylib"]) {
		type = @"binary";
	} else {
		type = @"file";
	}

	return type;

}

+ (NSString *) mimeTypeForName: (NSString *) name {

	NSString *type;
	NSString *typeStr = [[[name componentsSeparatedByString: @"."] lastObject] lowercaseString];
	if ([typeStr isEqualToString: @"png"]) {
		type = @"image/png";
	} else if ([typeStr isEqualToString: @"jpg"]) {
		type = @"image/jpeg";
	} else if ([typeStr isEqualToString: @"gif"]) {
		type = @"image/gif";
	} else if ([typeStr isEqualToString: @"bmp"]) {
		type = @"image/bmp";
	} else if ([typeStr isEqualToString: @"psd"]) {
		type = @"application/octet-stream";
	} else if ([typeStr isEqualToString: @"svg"]) {
		type = @"image/svg+xml";
	} else if ([typeStr isEqualToString: @"mp3"]) {
		type = @"audio/mpeg3";
	} else if ([typeStr isEqualToString: @"wav"]) {
		type = @"audio/wav";
	} else if ([typeStr isEqualToString: @"caf"]) {
		type = @"audio/x-caf";
	} else if ([typeStr isEqualToString: @"wma"]) {
		type = @"audio/x-ms-wma";
	} else if ([typeStr isEqualToString: @"mid"]) {
		type = @"audio/x-midi";
	} else if ([typeStr isEqualToString: @"aiff"]) {
		type = @"audio/x-aiff";
	} else if ([typeStr isEqualToString: @"m4a"]) {
		type = @"audio/aac";
	} else if ([typeStr isEqualToString: @"m4r"]) {
		type = @"audio/aac";
	} else if ([typeStr isEqualToString: @"mp4"]) {
		type = @"video/mp4";
	} else if ([typeStr isEqualToString: @"mov"]) {
		type = @"video/quicktime";
	} else if ([typeStr isEqualToString: @"avi"]) {
		type = @"video/x-msvideo";
	} else if ([typeStr isEqualToString: @"flv"]) {
		type = @"video/x-flv";
	} else if ([typeStr isEqualToString: @"pdf"]) {
		type = @"application/pdf";
	} else if ([typeStr isEqualToString: @"xls"]) {
		type = @"application/x-msexcel";
	} else if ([typeStr isEqualToString: @"xlsx"]) {
		type = @"application/x-msexcel";
	} else if ([typeStr isEqualToString: @"doc"]) {
		type = @"application/msword";
	} else if ([typeStr isEqualToString: @"docx"]) {
		type = @"application/msword";
	} else if ([typeStr isEqualToString: @"ppt"]) {
		type = @"application/x-mspowerpoint";
	} else if ([typeStr isEqualToString: @"pptx"]) {
		type = @"application/x-mspowerpoint";
	} else if ([typeStr isEqualToString: @"html"]) {
		type = @"text/html";
	} else if ([typeStr isEqualToString: @"htm"]) {
		type = @"text/html";
	} else if ([typeStr isEqualToString: @"txt"]) {
		type = @"text/plain";
	} else if ([typeStr isEqualToString: @"rtf"]) {
		type = @"text/richtext";
	} else if ([typeStr isEqualToString: @"css"]) {
		type = @"text/css";
	} else if ([typeStr isEqualToString: @"js"]) {
		type = @"application/x-javascript";
	} else if ([typeStr isEqualToString: @"c"]) {
		type = @"text/x-c";
	} else if ([typeStr isEqualToString: @"cpp"]) {
		type = @"text/plain";
	} else if ([typeStr isEqualToString: @"m"]) {
		type = @"text/x-objcsrc";
	} else if ([typeStr isEqualToString: @"mm"]) {
		type = @"text/x-objcsrc";
	} else if ([typeStr isEqualToString: @"h"]) {
		type = @"text/plain";
	} else if ([typeStr isEqualToString: @"xml"]) {
		type = @"text/xml";
	} else if ([typeStr isEqualToString: @"plist"]) {
		type = @"application/xml";
	} else if ([typeStr isEqualToString: @"strings"]) {
		type = @"application/xml";
	} else if ([typeStr isEqualToString: @"sh"]) {
		type = @"application/x-sh";
	} else if ([typeStr isEqualToString: @"log"]) {
		type = @"text/plain";
	} else if ([typeStr isEqualToString: @"conf"]) {
		type = @"text/plain";
	} else if ([typeStr isEqualToString: @"php"]) {
		type = @"text/plain";
	} else if ([typeStr isEqualToString: @"tar"]) {
		type = @"application/x-tar";
	} else if ([typeStr isEqualToString: @"gz"]) {
		type = @"application/x-gzip";
	} else if ([typeStr isEqualToString: @"tgz"]) {
		type = @"application/x-gnutar";
	} else if ([typeStr isEqualToString: @"bz2"]) {
		type = @"application/x-bzip2";
	} else if ([typeStr isEqualToString: @"tbz"]) {
		type = @"application/x-bzip2";
	} else if ([typeStr isEqualToString: @"deb"]) {
		type = @"application/x-debian-package";
	} else if ([typeStr isEqualToString: @"zip"]) {
		type = @"application/x-zip-compressed";
	} else if ([typeStr isEqualToString: @"ipa"]) {
		type = @"application/x-zip-compressed";
	} else if ([typeStr isEqualToString: @"xar"]) {
		type = @"application/octet-stream";
	} else if ([typeStr isEqualToString: @"7z"]) {
		type = @"application/x-7z-compressed";
	} else if ([typeStr isEqualToString: @"lzma"]) {
		type = @"application/x-lzma";
	} else if ([typeStr isEqualToString: @"rar"]) {
		type = @"application/x-rar-compressed";
	} else if ([typeStr isEqualToString: @"db"]) {
		type = @"application/x-sqlite3";
	} else if ([typeStr isEqualToString: @"sqlitedb"]) {
		type = @"application/x-sqlite3";
	} else if ([typeStr isEqualToString: @"sqlite"]) {
		type = @"application/x-sqlite3";
	} else if ([typeStr isEqualToString: @"itdb"]) {
		type = @"application/x-sqlite3";
	} else if ([typeStr isEqualToString: @"sql"]) {
		type = @"application/x-sqlite3";
	} else if ([typeStr isEqualToString: @"o"]) {
		type = @"application/octet-stream";
	} else if ([typeStr isEqualToString: @"dylib"]) {
		type = @"application/octet-stream";
	} else {
		type = @"application/octet-stream";
	}

	return type;
	
}


+ (UIImage *) imageForType: (NSString *) type {

	NSString *fileName = [NSString stringWithFormat: @"%@.png", type];
	UIImage *img = [UIImage imageNamed: fileName];

	return img;

}

+ (UIImage *) imageForName: (NSString *) name {

	UIImage *img = [MFFileType imageForType: [self fileTypeForName: name]];

	return img;

}

@end


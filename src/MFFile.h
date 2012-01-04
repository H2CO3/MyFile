//
// MFFile.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <sys/types.h>
#import <Foundation/Foundation.h>

@interface MFFile: NSObject <NSCopying> {
	NSString *name;
	NSString *path;
	NSString *type;
	NSString *mime;
	BOOL isDirectory;
	BOOL isSymlink;
	NSString *fsize;
	NSString *permissions;
	NSString *owner;
	NSString *group;
        NSString *atime;
        NSString *mtime;
	unsigned int bytessize;
}

@property (copy) NSString *name;
@property (copy) NSString *path;
@property (copy) NSString *type;
@property (copy) NSString *mime;
@property BOOL isDirectory;
@property BOOL isSymlink;
@property (copy) NSString *fsize;
@property (copy) NSString *permissions;
@property (copy) NSString *owner;
@property (copy) NSString *group;
@property (copy) NSString *atime;
@property (copy) NSString *mtime;
@property unsigned int bytessize;

- (NSString *) fullPath;
- (NSURL *) fileUrl;

@end

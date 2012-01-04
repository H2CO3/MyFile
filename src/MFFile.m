//
// MFFile.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFFile.h"

@implementation MFFile

@synthesize name = name;
@synthesize path = path;
@synthesize type = type;
@synthesize mime = mime;
@synthesize isDirectory = isDirectory;
@synthesize isSymlink = isSymlink;
@synthesize fsize = fsize;
@synthesize permissions = permissions;
@synthesize owner = owner;
@synthesize group = group;
@synthesize atime = atime;
@synthesize mtime = mtime;
@synthesize bytessize = bytessize;

- (NSString *) fullPath {

        return [self.path stringByAppendingPathComponent: self.name];

}

- (NSURL *) fileUrl {

        return [NSURL fileURLWithPath: [self fullPath]];

}

// NSCopying

- (id) copyWithZone: (NSZone *) zone {
	MFFile *copy = [[[self class] allocWithZone: zone] init];
	copy.name = self.name;
	copy.path = self.path;
	copy.type = self.type;
	copy.mime = self.mime;
	copy.isDirectory = self.isDirectory;
	copy.isSymlink = self.isSymlink;
	copy.fsize = self.fsize;
	copy.permissions = self.permissions;
	copy.owner = self.owner;
	copy.group = self.group;
	copy.atime = self.atime;
	copy.mtime = self.mtime;
	copy.bytessize = self.bytessize;
	return copy;
}

@end


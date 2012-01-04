//
// MFPlugin.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFPlugin.h"

@implementation MFPlugin

- (id) initWithBundle:(NSBundle *)bndl {
	self = [super init];
	bundle = [bndl retain];
	if (bundle == nil) {
		[self release];
		return nil;
	}
	info = [bundle infoDictionary];
	char *dylib = [[bundle executablePath] UTF8String];
	if (dylib == NULL) {
		[self release];
		return nil;
	}
	handle = dlopen(dylib, RTLD_NOW);
	mfp_initialize = dlsym(handle, "MFPInitialize");
	if (mfp_initialize == NULL) {
		[self release];
		return nil;
	}
	mfp_description = dlsym(handle, "MFPDescription");
	if (mfp_description == NULL) {
		[self release];
		return nil;
	}
	mfp_supported_filetypes = dlsym(handle, "MFPSupportedFileTypes");
	if (mfp_supported_filetypes == NULL) {
		[self release];
		return nil;
	}
	description = [mfp_description() copy];
	fileTypes = [mfp_supported_filetypes() copy];
	return self;
}

- (void) launchWithEnvironment:(NSDictionary *)env {
	mfp_initialize(env);
}

- (NSString *) identifier {
	return [info objectForKey:@"CFBundleIdentifier"];
}

- (NSString *) name {
	return [info objectForKey:@"CFBundleName"];
}

- (NSString *) description {
	return description;
}

- (NSArray *) supportedFileTypes {
	return fileTypes;
}

- (void) dealloc {
	dlclose(handle);
	[bundle release];
	[description release];
	[fileTypes release];
	[super dealloc];
}

@end

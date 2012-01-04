//
// MFPlugin.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <stdlib.h>
#import <unistd.h>
#import <stdio.h>
#import <string.h>
#import <dlfcn.h>
#import <Foundation/Foundation.h>

typedef void (*mfp_initfunc_t)(NSDictionary *);
typedef NSString *(*mfp_descfunc_t)();
typedef NSArray *(*mfp_suppfunc_t)();

@interface MFPlugin: NSObject {
	NSBundle *bundle;
	NSDictionary *info;
	NSString *description;
	NSArray *fileTypes;
	void *handle;
	mfp_initfunc_t mfp_initialize;
	mfp_descfunc_t mfp_description;
	mfp_suppfunc_t mfp_supported_filetypes;
}

- (id) initWithBundle:(NSBundle *)bndl;
- (void) launchWithEnvironment:(NSDictionary *)env;
- (NSString *) identifier;
- (NSString *) name;
- (NSArray *) supportedFileTypes;

@end

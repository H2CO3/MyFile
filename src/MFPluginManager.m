//
// MFPluginManager.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFPluginManager.h"

static id _sharedInstance = nil;

@implementation MFPluginManager

+ (id) sharedInstance {
	if(_sharedInstance == nil) {
		_sharedInstance = [[self alloc] init];
	}
	return _sharedInstance;
}

- (id) init {
	self = [super init];
	fileManager = [[NSFileManager alloc] init];
	pluginStrings = [[fileManager contentsOfDirectoryAtPath:@"/var/mobile/Library/MyFile/Plugins" error:NULL] mutableCopy];
	for (int i = 0; i < [pluginStrings count]; i++) {
		if ([(NSString *)[pluginStrings objectAtIndex:i] hasSuffix:@".mfplugin"] != YES) {
			[pluginStrings removeObjectAtIndex:i];
		}
	}
	plugins = [[NSMutableArray alloc] init];
	for (int i = 0; i < [pluginStrings count]; i++) {
		NSBundle *pluginBundle = [[NSBundle alloc] initWithPath:[@"/var/mobile/Library/MyFile/Plugins" stringByAppendingPathComponent:[pluginStrings objectAtIndex:i]]];
		MFPlugin *plugin = [[MFPlugin alloc] initWithBundle:pluginBundle];
		[pluginBundle release];
                if (plugin) {
		        [plugins addObject:plugin];
                }
		[plugin release];
	}
	return self;
}

- (void) activatePlugin:(MFPlugin *)plugin withEnvironment:(NSDictionary *)env {
	[plugin launchWithEnvironment:env];
}

- (uint32_t) numberOfPlugins {
	return [plugins count];
}

- (uint32_t) numberOfPluginsForType:(NSString *)type {
	uint32_t num = 0;
	for (int i = 0; i < [self numberOfPlugins]; i++) {
		if ([[[self pluginAtIndex:i] supportedFileTypes] containsObject:type] || ([[[self pluginAtIndex:i] supportedFileTypes] count] == 0)) {
			num++;
		}
	}
	return num;
}

- (MFPlugin *) pluginAtIndex:(uint32_t)idx {
	return [plugins objectAtIndex: idx];
}

- (MFPlugin *) pluginAtIndex:(uint32_t)idx forType:(NSString *)type {
	NSMutableArray *types = [[NSMutableArray alloc] init];
	for (int i = 0; i < [self numberOfPlugins]; i++) {
		if ([[[self pluginAtIndex:i] supportedFileTypes] containsObject:type] || ([[[self pluginAtIndex:i] supportedFileTypes] count] == 0)) {
			[types addObject:[self pluginAtIndex:i]];
		}
	}
	MFPlugin *pl = [[[types objectAtIndex:idx] retain] autorelease];
	[types release];
	return pl;
}

- (void) dealloc {
	[fileManager release];
	[plugins release];
	[pluginStrings release];
	[super dealloc];
}

@end

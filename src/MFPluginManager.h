//
// MFPluginManager.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <sys/types.h>
#import <Foundation/Foundation.h>
#import "MFPlugin.h"

@interface MFPluginManager: NSObject {
	NSFileManager *fileManager;
	NSMutableArray *plugins;
	NSMutableArray *pluginStrings;
}

+ (id) sharedInstance;
- (void) activatePlugin:(MFPlugin *)plugin withEnvironment:(NSDictionary *)env;
- (uint32_t) numberOfPlugins;
- (uint32_t) numberOfPluginsForType:(NSString *)type;
- (MFPlugin *) pluginAtIndex:(uint32_t)idx;
- (MFPlugin *) pluginAtIndex:(uint32_t)idx forType:(NSString *)type;

@end

//
// SQLiteManager.h
// libsqlitemanager
//
// Created by Árpád Goretity, 2011.
//

#import <sqlite3.h>
#import <Foundation/Foundation.h>

int sql_callback (void *data, int argc, char **argv, char **column_name);
int sql_callback_nokeys (void *data, int argc, char **argv, char **column_name);

@interface SQLiteManager: NSObject {
	NSString *file;
}

- (id) initWithFile: (NSString *) path;
- (NSArray *) executeSQLQuery: (NSString *) query;
- (NSArray *) executeSQLQueryNoKeys: (NSString *) query;

@end


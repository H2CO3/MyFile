//
// SQLiteManager.m
// libsqlitemanager
//
// Created by Árpád Goretity, 2011.
//

#import "SQLiteManager.h"

int sql_callback (void *data, int argc, char **argv, char **column_name) {

        NSMutableArray *row = [[NSMutableArray alloc] init];
        for (int i = 0; i < argc; i++) {

                NSString *kvp = [[NSString alloc] initWithFormat: @"%s = %s", column_name[i], argv[i]];
                [row addObject: kvp];
                [kvp release];

        }
        [(NSMutableArray *)data addObject: row];
        [row release];

        return 0;

}

int sql_callback_nokeys (void *data, int argc, char **argv, char **column_name) {

        NSMutableArray *row = [[NSMutableArray alloc] init];
        for (int i = 0; i < argc; i++) {

                NSString *kvp = [[NSString alloc] initWithFormat: @"%s", argv[i]];
                [row addObject: kvp];
                [kvp release];

        }
        [(NSMutableArray *)data addObject: row];
        [row release];

        return 0;

}

@implementation SQLiteManager

- (id) initWithFile: (NSString *) path {

	self = [super init];

	file = [path retain];

	return self;

}

- (NSArray *) executeSQLQuery: (NSString *) query {

        sqlite3 *sql_db;
        sqlite3_open ([file UTF8String], &sql_db);
        NSMutableArray *rows = [[[NSMutableArray alloc] init] autorelease];
        sqlite3_exec (sql_db, [query UTF8String], sql_callback, rows, NULL);
        sqlite3_close (sql_db);

        return rows;

}

- (NSArray *) executeSQLQueryNoKeys: (NSString *) query {

        sqlite3 *sql_db;
        sqlite3_open ([file UTF8String], &sql_db);
        NSMutableArray *rows = [[[NSMutableArray alloc] init] autorelease];
        sqlite3_exec (sql_db, [query UTF8String], sql_callback_nokeys, rows, NULL);
        sqlite3_close (sql_db);

        return rows;

}

- (void) dealloc {

        [file release];

        [super dealloc];

}

@end

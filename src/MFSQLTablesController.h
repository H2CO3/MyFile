//
// MFSQLTablesController.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MFModalController.h"
#import "SQLiteManager.h"

@interface MFSQLTablesController: MFModalController <UITableViewDelegate, UITableViewDataSource> {
	SQLiteManager *manager;
	UITableView *tableView;
	NSArray *tables;
}

- (id) initWithSQLManager: (SQLiteManager *) sqlMgr;

@end


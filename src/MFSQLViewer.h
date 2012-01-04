//
// MFSQLViewer.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SQLiteManager.h"
#import "MFFile.h"
#import "MFSQLTablesController.h"
#import "MFLocalizedString.h"

@interface MFSQLViewer: UIView <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> {
        MFFile *database;
        MFSQLTablesController *tablesController;
        SQLiteManager *sqlManager;
        UITableView *tableView;
        UISearchBar *sqlCommand;
        NSMutableArray *result;
        UIViewController *mainViewController;
}

@property (assign) UIViewController *mainViewController;

- (id) initWithFile: (MFFile *) file frame: (CGRect) theFrame;
- (void) showTables;

@end

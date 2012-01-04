//
// MMFSFTPUploadController.h
// MyFile
//
// Created by Árpád Goretit, 2011.
//

#import "MFModalController.h"

@class MFSFTPController;

@interface MFSFTPUploadController: MFModalController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
	UITableView *tableView;
	UITextField *localFile;
	UITextField *remoteFile;
	MFSFTPController *mainController;
}

@property (assign) MFSFTPController *mainController;

- (void) done;

@end


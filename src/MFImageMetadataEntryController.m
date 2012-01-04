//
// MFImageMetadataEntryController.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFImageMetadataEntryController.h"

@implementation MFImageMetadataEntryController

@synthesize delegate = delegate;

// self

- (id) initWithTag: (ExifTag) aTag value: (NSString *) aValue {

        self = [super init];

        self.navigationItem.title = MFLocalizedString(@"Enter new metadata");
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(done)] autorelease];

        tag = aTag;
        value = [aValue copy];

        val = [[UITextField alloc] initWithFrame: CGRectMake (0, 0, 160, 30)];
        val.delegate = self;
        val.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        val.placeholder = MFLocalizedString(@"Enter raw value");
        val.text = value;

        tableView = [[UITableView alloc] initWithFrame: UIInterfaceOrientationIsPortrait (self.interfaceOrientation) ? CGRectMake (0, 0, 320, 460) : [[UIScreen mainScreen] applicationFrame] style: UITableViewStyleGrouped];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview: tableView];

        return self;

}

- (void) done {

        [value release];
        value = [val.text copy];
        [delegate entryController: self didDismissWithTag: tag value: value];
        [self close];

}

// UITableViewDelegate

- (void) tableView: (UITableView *) theTableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

        [theTableView deselectRowAtIndexPath: indexPath animated: YES];

        if (indexPath.row == 2) {

                [self done];

        }

}

// UITableViewDataSource

- (int) tableView: (UITableView *) theTableView numberOfRowsInSection: (int) section {

        return 3;

}

- (float) tableView: (UITableView *) theTableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {

        float h;
        if (indexPath.row == 1) {
                h = 240.0;
        } else {
                h = 44.0;
        }

        return h;

}

- (UITableViewCell *) tableView: (UITableView *) theTableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

        UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier: @"MetaEntry"];
        if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"MetaEntry"] autorelease];
        }

        int idx = indexPath.row;

        if (idx == 0) {
                cell.textLabel.text = MFLocalizedString(@"Value");
                cell.accessoryView = val;
        } else if (idx == 1) {
                char *desc = exif_tag_get_description_in_ifd (tag, EXIF_IFD_0);
                if (desc != NULL) {
                        cell.textLabel.text = [NSString stringWithUTF8String: desc];
                } else {
                        cell.textLabel.text = [NSString stringWithFormat: MFLocalizedString(@"(No description)\nTag ID: %i"), tag];
                }
                cell.accessoryView = nil;
        } else {
                cell.textLabel.text = MFLocalizedString(@"Done, modify!");
                cell.accessoryView = nil;
        }

        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines = 0;
        return cell;

}

// UITextFieldDelegate

- (BOOL) textFieldShouldReturn: (UITextField *) textField {

        [textField resignFirstResponder];
        [value release];
        value = [textField.text copy];

        return YES;

}

// super

- (void) dealloc {

        [val release];
        val = nil;
        [value release];
        value = nil;
        [tableView release];
        tableView = nil;

        [super dealloc];

}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orientation {

        return (orientation != UIInterfaceOrientationLandscapeLeft);

}

@end

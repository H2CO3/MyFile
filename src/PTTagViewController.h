//
// PTTagViewController.h
// PwnTube
//
// Created by Árpád Goretity, 2011.
// Licensed under a CreativeCommons Attribution NonCommercial 3.0 Unported License
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MFMusicLibrary/MFMusicLibrary.h>

@interface PTTagViewController: UITableViewController <UITextFieldDelegate> {
	NSMutableArray *textFields;
	NSArray *labels;
	NSString *file;
	MFID3Tag *tag;
	UIViewController *parent;
}

- (id) initWithPath: (NSString *) path;
- (void) presentFrom: (UIViewController *) vc;
- (void) close;

@end

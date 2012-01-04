//
// MFMyPodArtistsController.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MFMusicLibrary/MFMusicLibrary.h>
#import "PullRefreshTableController.h"
#import "MFLocalizedString.h"

@interface MFMyPodArtistsController: PullRefreshTableController {
	NSMutableDictionary *artists;
}

@end


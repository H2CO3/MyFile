//
// MFPasteManager.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <Foundation/Foundation.h>

enum MFPasteManagerState {
	MFPasteManagerStateCopy,
	MFPasteManagerStateCut,
	MFPasteManagerStateSymlink
};

typedef enum MFPasteManagerState MFPasteManagerState;

@interface MFPasteManager: NSObject {
	MFPasteManagerState managerState;
}

+ (id) sharedManager;
- (MFPasteManagerState) state;
- (void) setState: (MFPasteManagerState) theState;

@end


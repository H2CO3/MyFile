//
// MFPasteManager.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFPasteManager.h"

static MFPasteManager *_sharedManager = nil;

@implementation MFPasteManager

+ (id) sharedManager {

	if (_sharedManager == nil) {
		_sharedManager = [[self alloc] init];
	}
	
	return _sharedManager;
	
}

- (MFPasteManagerState) state {

	return managerState;
	
}

- (void) setState: (MFPasteManagerState) theState {

	managerState = theState;
	
}

@end


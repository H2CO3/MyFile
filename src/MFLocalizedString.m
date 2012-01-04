//
// MFLocalizedString.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <Foundation/Foundation.h>
// #import "MFLocalizedString.h"


NSString *MFLocalizedString (NSString *str) {
	/*
	NSDictionary *prefsDict = [[NSDictionary alloc] initWithContentsOfFile: @"/var/mobile/Library/Preferences/.GlobalPreferences.plist"];
	NSString *currentLanguage = [[[[prefsDict objectForKey: @"AppleLanguages"] objectAtIndex: 0] substringToIndex: 2] stringByAppendingString: @".lproj"];
	NSString *localeFile = [[NSBundle mainBundle] pathForResource: @"Localized" ofType: @"strings" inDirectory: currentLanguage];
	NSDictionary *localeDict = [[NSDictionary alloc] initWithContentsOfFile: localeFile];
	NSString *val = [NSString stringWithString:[localeDict objectForKey: str]];
	[localeDict release];
	[prefsDict release];
	
	if (val == nil) {
		val = str;
	}
	
	return val;
	*/
	return NSLocalizedString(str, @"");
}

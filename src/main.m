//
// main.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <dlfcn.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MFApplication.h"

int main (int argc, char **argv) {

	setuid (0);
	seteuid(501);
	dlopen("/Library/MobileSubstrate/DynamicLibraries/Activator.dylib", RTLD_NOW);
	NSAutoreleasePool *mainPool = [[NSAutoreleasePool alloc] init];
	int exitCode = UIApplicationMain (argc, argv, nil, @"MFApplication");
	[mainPool release];

	return exitCode;

}

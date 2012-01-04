//
// MFFileType.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <UIKit/UIKit.h>

@interface MFFileType: NSObject {
}

+ (NSString *) fileTypeForName: (NSString *) name;
+ (NSString *) mimeTypeForName: (NSString *) name;
+ (UIImage *) imageForType: (NSString *) type;
+ (UIImage *) imageForName: (NSString *) name;

@end


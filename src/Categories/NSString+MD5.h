//
// NSString+MD5.h
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (MD5)

+ (NSString *) fileMD5: (NSString *) path;

@end


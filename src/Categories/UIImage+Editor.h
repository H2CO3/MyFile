//
// UIImage+Editor.h
// MyFile
// Created by Árpád Goretity, 2011.
//

#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"
#import "UIImage+Alpha.h"

CGFloat degreesToRadians (CGFloat degrees);

@interface UIImage (Editor)
- (UIImage *) resizedToSize: (CGSize) size;
- (UIImage *) resizedByRatio: (CGFloat) ratio;
- (UIImage *) croppedToRect: (CGRect) rect;
- (UIImage *) withBorderRadius: (CGFloat) radius;
- (UIImage *) addText: (NSString *) str atPoint: (CGPoint) point withFont: (UIFont *) font ofColor: (UIColor *) color;
- (UIImage *) grayscaled;
- (UIImage *) withAlpha: (CGFloat) alpha;
- (UIImage *) rotatedByDegrees: (CGFloat) degrees;
@end


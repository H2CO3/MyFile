//
// UIImage+Editor.m
// MyFile
// Created by Árpád Goretity, 2011.
//

#import "UIImage+Editor.h"

CGFloat degreesToRadians (CGFloat degrees) {
        return (degrees / 180.0) * M_PI;
}

@implementation UIImage (Editor)

- (UIImage *) resizedToSize: (CGSize) size {
	return [self resizedImage: size interpolationQuality: kCGInterpolationHigh];
}

- (UIImage *) resizedByRatio: (CGFloat) ratio {
	CGSize newSize = CGSizeMake (self.size.width * ratio, self.size.height * ratio);
	return [self resizedToSize: newSize];
}

- (UIImage *) croppedToRect: (CGRect) rect {
	return [self croppedImage: rect];
}

- (UIImage *) withBorderRadius: (CGFloat) radius {
	return [self roundedCornerImage: round (radius) borderSize: 0];
}

- (UIImage *) addText: (NSString *) str atPoint: (CGPoint) point withFont: (UIFont *) font ofColor: (UIColor *) color {

	int w = self.size.width;
	int h = self.size.height;

	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB ();
	CGContextRef ctx = CGBitmapContextCreate (NULL, w, h, 8, w * 4, colorSpace, kCGImageAlphaPremultipliedFirst);
	CGContextSetInterpolationQuality (ctx, kCGInterpolationHigh);
        CGAffineTransform transform = [self transformForOrientation: self.size];
        CGContextConcatCTM (ctx, transform);
        CGContextSetTextMatrix (ctx, CGAffineTransformInvert (transform));
        BOOL transposed;
        switch (self.imageOrientation) {

                case UIImageOrientationLeft:
                case UIImageOrientationLeftMirrored:
                case UIImageOrientationRight:
                case UIImageOrientationRightMirrored:
                        transposed = YES;
                        break;

                default:
                        transposed = NO;
                        break;

        }

	CGContextDrawImage (ctx, transposed ? CGRectMake (0, 0, h, w) : CGRectMake (0, 0, w, h), [self CGImage]);
	char *text = (char *)[str cStringUsingEncoding: NSASCIIStringEncoding];
	CGContextSetTextDrawingMode (ctx, kCGTextFill);
	CGFloat *comp = CGColorGetComponents ([color CGColor]);
	CGContextSetRGBFillColor (ctx, comp[0], comp[1], comp[2], comp[3]);
	CGContextSelectFont (ctx, [[font fontName] UTF8String], [font pointSize], kCGEncodingMacRoman);
	CGContextShowTextAtPoint (ctx, point.x, h - point.y, text, strlen (text));

	CGImageRef imageMasked = CGBitmapContextCreateImage (ctx);
        UIImage *img = [UIImage imageWithCGImage: imageMasked];
	CGContextRelease (ctx);
        CGImageRelease (imageMasked);
	CGColorSpaceRelease (colorSpace);

	return img;
	
}

- (UIImage *) grayscaled {

	const uint8_t ALPHA = 0;
	const uint8_t BLUE = 1;
	const uint8_t GREEN = 2;
	const uint8_t RED = 3;

	CGSize size = self.size;
	int width = size.width;
	int height = size.height;
	uint32_t *pixels = (uint32_t *) malloc (width * height * sizeof (uint32_t));
	memset(pixels, 0, width * height * sizeof (uint32_t));
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB ();
	CGContextRef context = CGBitmapContextCreate (pixels, width, height, 8, width * sizeof (uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
	CGContextDrawImage (context, CGRectMake (0, 0, width, height), [self CGImage]);
	
	for (int y = 0; y < height; y++) {
		for (int x = 0; x < width; x++) {
			uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
			// convert to grayscale using recommended weighting method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
			uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
			rgbaPixel[RED] = gray;
			rgbaPixel[GREEN] = gray;
			rgbaPixel[BLUE] = gray;
		}
	}
	
	CGImageRef image = CGBitmapContextCreateImage (context);
	CGContextRelease (context);
	CGColorSpaceRelease (colorSpace);
	free (pixels);
	UIImage *resultUIImage = [UIImage imageWithCGImage: image];
	CGImageRelease (image);

	return resultUIImage;
	
}

- (UIImage *) withAlpha: (CGFloat) alpha {

	int w = self.size.width;
	int h = self.size.height;

	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB ();
	CGContextRef ctx = CGBitmapContextCreate (NULL, w, h, 8, w * 4, colorSpace, kCGImageAlphaPremultipliedFirst);
	CGContextSetInterpolationQuality (ctx, kCGInterpolationHigh);
        CGAffineTransform transform = [self transformForOrientation: self.size];
        CGContextConcatCTM (ctx, transform);
        CGContextSetAlpha (ctx, alpha);

        BOOL transposed;
        switch (self.imageOrientation) {

                case UIImageOrientationLeft:
                case UIImageOrientationLeftMirrored:
                case UIImageOrientationRight:
                case UIImageOrientationRightMirrored:
                        transposed = YES;
                        break;

                default:
                        transposed = NO;
                        break;

        }

	CGContextDrawImage (ctx, transposed ? CGRectMake (0, 0, h, w) : CGRectMake (0, 0, w, h), [self CGImage]);
	CGImageRef imageMasked = CGBitmapContextCreateImage (ctx);
        UIImage *img = [UIImage imageWithCGImage: imageMasked];
	CGContextRelease (ctx);
        CGImageRelease (imageMasked);
	CGColorSpaceRelease (colorSpace);

	return img;

}

- (UIImage *) rotatedByDegrees: (CGFloat) degrees {   

	// calculate the size of the rotated view's containing box for our drawing space
	UIView *rotatedViewBox = [[UIView alloc] initWithFrame: CGRectMake (0, 0, self.size.width, self.size.height)];
	CGAffineTransform t = CGAffineTransformMakeRotation (degreesToRadians (degrees));
	rotatedViewBox.transform = t;
	CGSize rotatedSize = rotatedViewBox.frame.size;
	[rotatedViewBox release];
	// Create the bitmap context
	UIGraphicsBeginImageContext (rotatedSize);
	CGContextRef bitmap = UIGraphicsGetCurrentContext ();
	// Move the origin to the middle of the image so we will rotate and scale around the center.
	CGContextTranslateCTM (bitmap, rotatedSize.width / 2, rotatedSize.height / 2);
	// Rotate the image context
	CGContextRotateCTM (bitmap, degreesToRadians (degrees));
	// Now, draw the rotated/scaled image into the context
	CGContextScaleCTM (bitmap, 1.0, -1.0);
	CGContextDrawImage (bitmap, CGRectMake (-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
   	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return newImage;
   
}


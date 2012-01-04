//
// MFHexEditor.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFHexEditor.h"

@implementation MFHexEditor

@synthesize file = file;
@synthesize hexData = hexData;

// self

- (MFHexEditor *) initWithFile: (MFFile *) aFile {

	self = [super initWithFrame: CGRectMake (0, 0, 320, 480)];
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	file = [aFile retain];
	
	textView = [[UITextView alloc] initWithFrame: CGRectMake (95, 0, 255, 268)];
	textView.font = [UIFont fontWithName: @"Courier" size: 15.0];
	textView.delegate = self;
	NSData *binData = [[NSData alloc] initWithContentsOfFile: [self.file fullPath]];
	self.hexData = [binData description];
	self.hexData = [[self.hexData substringFromIndex: 1] substringToIndex: self.hexData.length - 2];
	textView.text = self.hexData;
	[self addSubview: textView];
	
	bytes = [[UITextView alloc] initWithFrame: CGRectMake (0, 0, 95, 268)];
	bytes.font = [UIFont fontWithName: @"Courier" size: 15.0];
	bytes.delegate = self;
	bytes.editable = NO;
	bytes.textColor = [UIColor blueColor];
	bytes.backgroundColor = [UIColor lightGrayColor];
	NSMutableString *str = [[NSMutableString alloc] init];
	NSMutableString *asc = [[NSMutableString alloc] init];
	unsigned int c;
	for (int i = 0; i < ([binData length] / 12 + 1); i++) {
		[str appendFormat: @"0x%06x\n", i * 12];
		for (int j = 0; j < 12; j++) {
			if ((i * 12 + j) < [binData length]) {
				[binData getBytes: &c range: NSMakeRange(i * 12 + j, 1)];
				if ((c < 32) || (c > 126)) {
					c = (unsigned int) '.';
				}
			} else {
				c = (unsigned int) ' ';
			}
			[asc appendFormat: @"%c", (unsigned char) c];
		}
		[asc appendString: @"\n"];
	}
	bytes.text = str;
	[str release];
	[self addSubview: bytes];
	
	ascii = [[UITextView alloc] initWithFrame: CGRectMake (350, 0, 130, 268)];
	ascii.font = [UIFont fontWithName: @"Courier" size: 15.0];
	ascii.delegate = self;
	ascii.editable = NO;
	ascii.backgroundColor = [UIColor yellowColor];
	ascii.textColor = [UIColor redColor];
	ascii.text = asc;
	[asc release];
	[self addSubview: ascii];
	
	[binData release];
	
	return self;
	
}

- (void) save {

	[textView resignFirstResponder];

	NSString *rawData = [[textView.text lowercaseString] stringByReplacingOccurrencesOfString: @" " withString: @""];
	NSMutableData *data = [[NSMutableData alloc] init];
	for (int i = 0; i < rawData.length / 2; i++) {
		
		char c0 = [rawData characterAtIndex: i * 2 + 0];
		char c1 = [rawData characterAtIndex: i * 2 + 1];
		int i1 = 0;
		int i0 = 0;
		if (c0 == '0') {
			i0 = 0 * 16;
		} else if (c0 == '1') {
			i0 = 1 * 16;
		} else if (c0 == '2') {
			i0 = 2 * 16;
		} else if (c0 == '3') {
			i0 = 3 * 16;
		} else if (c0 == '4') {
			i0 = 4 * 16;
		} else if (c0 == '5') {
			i0 = 5 * 16;
		} else if (c0 == '6') {
			i0 = 6 * 16;
		} else if (c0 == '7') {
			i0 = 7 * 16;
		} else if (c0 == '8') {
			i0 = 8 * 16;
		} else if (c0 == '9') {
			i0 = 9 * 16;
		} else if (c0 == 'a') {
			i0 = 10 * 16;
		} else if (c0 == 'b') {
			i0 = 11 * 16;
		} else if (c0 == 'c') {
			i0 = 12 * 16;
		} else if (c0 == 'd') {
			i0 = 13 * 16;
		} else if (c0 == 'e') {
			i0 = 14 * 16;
		} else if (c0 == 'f') {
			i0 = 15 * 16;
		}
		
		if (c1 == '0') {
			i1 = 0;
		} else if (c1 == '1') {
			i1 = 1;
		} else if (c1 == '2') {
			i1 = 2;
		} else if (c1 == '3') {
			i1 = 3;
		} else if (c1 == '4') {
			i1 = 4;
		} else if (c1 == '5') {
			i1 = 5;
		} else if (c1 == '6') {
			i1 = 6;
		} else if (c1 == '7') {
			i1 = 7;
		} else if (c1 == '8') {
			i1 = 8;
		} else if (c1 == '9') {
			i1 = 9;
		} else if (c1 == 'a') {
			i1 = 10;
		} else if (c1 == 'b') {
			i1 = 11;
		} else if (c1 == 'c') {
			i1 = 12;
		} else if (c1 == 'd') {
			i1 = 13;
		} else if (c1 == 'e') {
			i1 = 14;
		} else if (c1 == 'f') {
			i1 = 15;
		}
		
		char byte = (char)(i0 + i1);
		[data appendBytes: &byte length: 1];
		
	}
	seteuid(0);
	[data writeToFile: [self.file fullPath] atomically: YES];
	seteuid(501);
	[data release];
	
}

- (void) dealloc {

	[textView release];
	textView = nil;
	[bytes release];
	bytes = nil;
	[ascii release];
	ascii = nil;
	
	[super dealloc];
	
}

// UITextViewDelegate
// UIScrollViewDelegate

- (void) scrollViewDidScroll: (UIScrollView *) theScrollView {

	if (theScrollView == textView) {
		bytes.contentOffset = textView.contentOffset;
		ascii.contentOffset = textView.contentOffset;
	} else if (theScrollView == bytes) {
		textView.contentOffset = bytes.contentOffset;
		ascii.contentOffset = bytes.contentOffset;
	} else if (theScrollView == ascii) {
		textView.contentOffset = ascii.contentOffset;
		bytes.contentOffset = ascii.contentOffset;
	}
	
}

@end


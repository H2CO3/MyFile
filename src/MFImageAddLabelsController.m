//
// MFImageAddLabelsController.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFImageAddLabelsController.h"

@implementation MFImageAddLabelsController

@synthesize text = text;
@synthesize point = point;
@synthesize font = font;
@synthesize color = color;
@synthesize delegate = delegate;

// super

- (id) init {

	self = [super init];
	self.view.backgroundColor = [UIColor whiteColor];
	self.navigationItem.title = MFLocalizedString(@"Add labels");
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(done)] autorelease];

        allFonts = [[NSMutableArray alloc] init];
        NSArray *families = [UIFont familyNames];
        for (int i = 0; i < [families count]; i++) {
                [allFonts addObjectsFromArray: [UIFont fontNamesForFamilyName: [families objectAtIndex: i]]];
        }

	redLabel = [[UILabel alloc] initWithFrame: CGRectMake (10, 10, 60, 30)];
        redLabel.text = MFLocalizedString(@"Red:");
        [self.view addSubview: redLabel];
        [redLabel release];
        greenLabel = [[UILabel alloc] initWithFrame: CGRectMake (10, 45, 60, 30)];
        greenLabel.text = MFLocalizedString(@"Green:");
        [self.view addSubview: greenLabel];
        [greenLabel release];
        blueLabel = [[UILabel alloc] initWithFrame: CGRectMake (10, 80, 60, 30)];
        blueLabel.text = MFLocalizedString(@"Blue:");
        [self.view addSubview: blueLabel];
        [blueLabel release];
        alphaLabel = [[UILabel alloc] initWithFrame: CGRectMake (10, 115, 60, 30)];
        alphaLabel.text = MFLocalizedString (@"Alpha:");
        [self.view addSubview: alphaLabel];
        [alphaLabel release];
        redSlider = [[UISlider alloc] initWithFrame: CGRectMake (70, 10, 180, 30)];
        [redSlider addTarget: self action: @selector(colorChanged:) forControlEvents: UIControlEventValueChanged];
        [self.view addSubview: redSlider];
        [redSlider release];
        greenSlider = [[UISlider alloc] initWithFrame: CGRectMake (70, 45, 180, 30)];
        [greenSlider addTarget: self action: @selector(colorChanged:) forControlEvents: UIControlEventValueChanged];
        [self.view addSubview: greenSlider];
        [greenSlider release];
        blueSlider = [[UISlider alloc] initWithFrame: CGRectMake (70, 80, 180, 30)];
	[blueSlider addTarget: self action: @selector(colorChanged:) forControlEvents: UIControlEventValueChanged];
        [self.view addSubview: blueSlider];
        alphaSlider = [[UISlider alloc] initWithFrame: CGRectMake (70, 115, 180, 30)];
        alphaSlider.value = 1.0;
        [alphaSlider addTarget: self action: @selector(colorChanged:) forControlEvents: UIControlEventValueChanged];
        [self.view addSubview: alphaSlider];
        [alphaSlider release];
        colorView = [[UIView alloc] initWithFrame: CGRectMake (260, 10, 50, 135)];
        colorView.backgroundColor = [UIColor colorWithRed: redSlider.value green: greenSlider.value blue: blueSlider.value alpha: alphaSlider.value];
        [self.view addSubview: colorView];
        [colorView release];

        fontSize = [[UITextField alloc] initWithFrame: CGRectMake (10, 155, 145, 30)];
        fontSize.delegate = self;
        fontSize.borderStyle = UITextBorderStyleRoundedRect;
        fontSize.placeholder = MFLocalizedString(@"Font size in points");
        fontSize.text = @"12.0";
        [self.view addSubview: fontSize];
        [fontSize release];

        pointField = [[UITextField alloc] initWithFrame: CGRectMake (165, 155, 145, 30)];
        pointField.delegate = self;
        pointField.borderStyle = UITextBorderStyleRoundedRect;
        pointField.placeholder = MFLocalizedString(@"Point to draw text to");
        pointField.text = @"0, 0";
        [self.view addSubview: pointField];
        [pointField release];

        textEntry = [[UITextField alloc] initWithFrame: CGRectMake (10, 195, 300, 30)];
        textEntry.delegate = self;
        textEntry.borderStyle = UITextBorderStyleRoundedRect;
        textEntry.placeholder = MFLocalizedString(@"Write text here");
        textEntry.text = MFLocalizedString(@"Write text here");
        [self.view addSubview: textEntry];
        [textEntry release];

        fontName = [[UIPickerView alloc] initWithFrame: CGRectMake (0, 235, 320, 81)];
        fontName.frame = CGRectMake (0, 235, 320, 81);
        fontName.delegate = self;
        fontName.dataSource = self;
        fontName.showsSelectionIndicator = YES;
        [self.view addSubview: fontName];
        [fontName release];

	return self;
	
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orientation {
        return UIInterfaceOrientationIsPortrait (orientation);
}

- (void) dealloc {

        [allFonts release];

        [super dealloc];

}

// self

- (void) colorChanged: (UISlider *) slider {

        colorView.backgroundColor = [UIColor colorWithRed: redSlider.value green: greenSlider.value blue: blueSlider.value alpha: alphaSlider.value];

}

- (void) done {

        text = textEntry.text;
        NSArray *a = [[pointField.text stringByReplacingOccurrencesOfString: @" " withString: @""] componentsSeparatedByString: @","];
        point.x = [[a objectAtIndex: 0] floatValue];
        point.y = [[a objectAtIndex: 1] floatValue];
        color = colorView.backgroundColor;
        font = [UIFont fontWithName: [allFonts objectAtIndex: [fontName selectedRowInComponent: 0]] size: [fontSize.text floatValue]];
        [delegate addLabelsControllerDone: self];
	[self close];
	
}

// UITextFieldDelegate

- (BOOL) textFieldShouldReturn: (UITextField *) textField {

        [textField resignFirstResponder];

        return YES;

}

// UIPickerViewDelegate

- (void) pickerView: (UIPickerView *) pickerView didSelectRow: (int) row inComponent: (int) component {
        // Handle selection
}

- (int) pickerView: (UIPickerView *) pickerView numberOfRowsInComponent: (NSInteger) component {
        return [allFonts count];
}

- (int) numberOfComponentsInPickerView: (UIPickerView *) pickerView {
        return 1;
}

- (NSString *) pickerView: (UIPickerView *) pickerView titleForRow: (int) row forComponent: (int) component {
        return [allFonts objectAtIndex: row];
}

- (float) pickerView: (UIPickerView *) pickerView widthForComponent: (int) component {
        return 300.0;
}

@end

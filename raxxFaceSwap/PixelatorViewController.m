//
//  PixelatorViewController.m
//  raxxFaceSwap
//
//  Created by Rahim Mitha on 2014-04-30.
//  Copyright (c) 2014 Rahim Mitha. All rights reserved.
//

#import "PixelatorViewController.h"
#import "UIImage+raxxFaceDetection.h"
#import "UIView+Toast.h"

@interface PixelatorViewController ()

@property (nonatomic, assign) BOOL isPixellated;
@property (nonatomic, strong) UIImage* originalImage;

@end

@implementation PixelatorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		
		self.imageView = [[UIImageView alloc] initWithImage:nil];
		
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = @"Pixellator";
	
	self.navigationController.navigationBar.tintColor = kContrastTintColor;
	self.navigationController.navigationBar.barTintColor = kLightTintColor;
	
	self.originalImage = self.imageView.image;
	[self.view makeMultiToastBottomCentered:@"Tap to pixellate faces!" duration:2.0];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shakeNotification:)
												 name:@"UIEventSubtypeMotionShakeEnded" object:nil];
	
	[self initToolbar];
	
}

- (void)initToolbar {
	
	self.navigationController.toolbar.tintColor = kContrastTintColor;
	self.navigationController.toolbar.barTintColor = kLightTintColor;
	
	UIBarButtonItem* libraryButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"libraryButton3"] style:UIBarButtonItemStylePlain target:self action:@selector(selectImage:)];
	UIBarButtonItem* pixelateButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fantasyblack2"] style:UIBarButtonItemStylePlain target:self action:@selector(handleTap:)];
	UIBarButtonItem* cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraPressed:)];
	UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
	UIBarButtonItem* fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
	
	[self setToolbarItems:[NSArray arrayWithObjects:fixedSpace, libraryButton, flexibleSpace, pixelateButton, flexibleSpace, cameraButton, fixedSpace, nil] animated:YES];
	self.navigationController.toolbarHidden = NO;
}

- (void) shakeNotification:(id)sender {
	UIAlertView* alert;
	
	if (self.originalImage == self.imageView.image) {
		alert = [[UIAlertView alloc] initWithTitle:@"Nothing to undo!" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	} else {
		alert = [[UIAlertView alloc] initWithTitle:@"Restore original image" message:@"Are you sure you want to restore the original image?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
	}
	[alert show];
	
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)pixellateFaces:(id)sender {
	
	CIImage *image = [CIImage imageWithCGImage:[self.imageView.image CGImage]];
	CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:nil];
	NSArray* faceArray = [detector featuresInImage:image options:nil];
	if ([faceArray count] > 1) {
		[self.view makeMultiToastBottomCentered:@"Error: Too many people." duration:4.0];
	}
	
	self.originalImage = self.imageView.image;
	self.imageView.image = [self.imageView.image pixelateFaces:self.imageView.image];
}

- (void)unPixellateFaces {
	self.isPixellated = NO;
	self.imageView.image = self.originalImage;
}

- (void)handleTap:(id)sender {
	if (!self.isPixellated) {
		self.isPixellated = YES;
		[self pixellateFaces:nil];
		[self.view makeMultiToastBottomCentered:@"Shake to restore." duration:2.0];
	}
}

#pragma mark -- UIImagePicker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[super imagePickerController:picker didFinishPickingMediaWithInfo:info];
	self.originalImage = self.imageView.image;
	self.isPixellated = NO;
}

#pragma mark -- UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		[self unPixellateFaces];
	}
}

- (UIImage*)currentImage
{
	
	UIGraphicsBeginImageContext(self.view.bounds.size);
	[self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:NO];
	UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
	
	
}

- (void)sharePressed:(id)sender {
	
	UIActivityViewController* shareController = [[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObject:[self currentImage]] applicationActivities: nil];
	[self presentViewController:shareController animated:YES completion:nil];
}

@end

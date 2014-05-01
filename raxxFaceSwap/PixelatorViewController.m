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
#import <AssetsLibrary/AssetsLibrary.h>

@interface PixelatorViewController ()

@property (nonatomic, assign) BOOL isPixellated;
@property (nonatomic, strong) UIImage* originalImage;

@end

@implementation PixelatorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = @"Pixellator";
	self.originalImage = self.imageView.image;
	[self.view makeMultiToastBottomCentered:@"Tap to pixellate faces!" duration:3.0];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shakeNotification:)
												 name:@"UIEventSubtypeMotionShakeEnded" object:nil];
	
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
		[self.view makeMultiToastBottomCentered:@"Shake to restore." duration:3.0];
	}
}

- (void)sharePressed:(id)sender {

	UIGraphicsBeginImageContext(self.imageView.bounds.size);
	[self.imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	UIActivityViewController* shareController = [[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObject:image] applicationActivities: nil];
		[self presentViewController:shareController animated:YES completion:nil];
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

@end

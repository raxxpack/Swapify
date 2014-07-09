//
//  FaceSwapViewController.m
//  raxxFaceSwap
//
//  Created by Rahim Mitha on 2014-05-01.
//  Copyright (c) 2014 Rahim Mitha. All rights reserved.
//

#import "FaceSwapViewController.h"
#import "UIImage+raxxFaceSwap.h"
#import "UIView+Toast.h"

@interface FaceSwapViewController ()
{
 
    UIImageView* displayImage;
    UIImageView* maskOne;
    UIImageView* maskTwo;
    UIImageView* photoView;
    
}
@end

@implementation FaceSwapViewController

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
	
	self.title = @"Face Swap!";
    self.view.backgroundColor = [UIColor whiteColor];

    
    self.imageView.image = [UIImage imageNamed:@"faceSwapTest.jpg"];
    
    self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageView.image.size.width, self.imageView.image.size.width);

    self.scrollView.contentSize = CGSizeMake(self.imageView.image.size.width, self.imageView.image.size.height);
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)faceSwap:(id)sender {
	self.imageView.image = [self.imageView.image swapFaces];
}

- (void)handleTap:(id)sender {
    [self faceSwap:nil];
}


#pragma mark -- UIImagePickerController delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
	[super imagePickerController:picker didFinishPickingMediaWithInfo:info];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[super imagePickerControllerDidCancel:picker];
}

#pragma mark - UIGestureRecognizer Delegate Methods

- (void)handlePan:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.view];
    sender.view.center = CGPointMake(sender.view.center.x + translation.x, sender.view.center.y + translation.y);
}

- (void)handlePinch:(UIPinchGestureRecognizer*)sender {
    sender.view.transform = CGAffineTransformScale(sender.view.transform, sender.scale, sender.scale);
    sender.scale = 1;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end

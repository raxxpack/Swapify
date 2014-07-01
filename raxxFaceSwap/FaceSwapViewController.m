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
    
    photoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"faceSwapTest.jpg"]];
    photoView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, photoView.image.size.width, photoView.image.size.width);
    photoView.hidden = YES;
    
    maskOne = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [maskOne setImage:[UIImage imageNamed:@"facemask.png"]];
    maskOne.hidden = YES;
  
    maskTwo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [maskTwo setImage:[UIImage imageNamed:@"facemask.png"]];
    maskTwo.hidden = YES;
    
    displayImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panGesture.delegate = self;
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    pinchGesture.delegate = self;
    
    [maskOne addGestureRecognizer:panGesture];
    [maskTwo addGestureRecognizer:panGesture];
    [maskOne addGestureRecognizer:pinchGesture];
    [maskTwo addGestureRecognizer:pinchGesture];
    [maskOne setUserInteractionEnabled:YES];
    [maskTwo setUserInteractionEnabled:YES];
    
    [self.view addSubview:maskOne];
    [self.view addSubview:maskTwo];
    [self.view addSubview:photoView];
    
//    self.imageView.image = [UIImage imageNamed:@"faceSwapTest.jpg"];
//    
//    self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageView.image.size.width, self.imageView.image.size.width);
//
//    self.scrollView.contentSize = CGSizeMake(self.imageView.image.size.width, self.imageView.image.size.height);
    
    
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

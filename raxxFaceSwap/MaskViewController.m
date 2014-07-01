//
//  MaskViewController.m
//  raxxFaceSwap
//
//  Created by rahim on 7/1/14.
//  Copyright (c) 2014 Rahim Mitha. All rights reserved.
//

#import "MaskViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MaskViewController ()

@end

@implementation MaskViewController

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
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    isEditing = false;
    
    photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    [photoView setImage:[UIImage imageNamed:@"facemask.png"]];
    photoView.hidden = YES;
    
    maskView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    [maskView setImage:[UIImage imageNamed:@"faceSwapTest.jpg"]];
    maskView.hidden = YES;
    
    displayImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    
    [panGesture setDelegate:self];
    [pinchGesture setDelegate:self];
    
    [photoView addGestureRecognizer:panGesture];
    [photoView addGestureRecognizer:pinchGesture];
    [photoView setUserInteractionEnabled:YES];
    
    btnEdit = [[UIButton alloc] initWithFrame:CGRectMake(60, 400, 200, 50)];
    [btnEdit setBackgroundColor:[UIColor blackColor]];
    [btnEdit setTitle:@"Start Editing" forState:UIControlStateNormal];
    [btnEdit addTarget:self action:@selector(toggleEditing) forControlEvents:UIControlEventTouchUpInside];
    
    [[self view] addSubview:displayImage];
    [[self view] addSubview:photoView];
    [[self view] addSubview:maskView];
    [[self view] addSubview:btnEdit];
    
    [self updateMaskedImage];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark -
#pragma mark Update Masked Image Method
#pragma mark -

-(void)updateMaskedImage
{
    maskView.hidden = YES;
    
    UIImage *finalImage =
    [self maskImage:[self captureView:self.view]
           withMask:[UIImage imageNamed:@"mask.png"]];
    
    
    maskView.hidden = NO;
    
    //UIImage *finalImage = [self maskImage:photoView.image withMask:[UIImage imageNamed:@"mask.png"]];
    
    [displayImage setImage:finalImage];
}

- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
    
    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
    return [UIImage imageWithCGImage:masked];
    
}

#pragma mark -
#pragma mark Touches Began
#pragma mark -

// adjusts the editing flag to make dragging and drop work
-(void)toggleEditing
{
    if(!isEditing)
    {
        isEditing = true;
        
        NSLog(@"editing...");
        
        [btnEdit setTitle:@"Stop Editing" forState:UIControlStateNormal];
        
        displayImage.hidden = YES;
        photoView.hidden = NO;
        maskView.hidden = NO;
    }
    else
    {
        isEditing = false;
        
        [self updateMaskedImage];
        
        NSLog(@"stopped editting");
        
        [btnEdit setTitle:@"Start Editing" forState:UIControlStateNormal];
        
        displayImage.hidden = NO;
        photoView.hidden = YES;
        maskView.hidden = YES;
    }
}

/*
 -(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
 {
 if(isEditing)
 {
 UITouch *finger = [touches anyObject];
 CGPoint currentPosition = [finger locationInView:self.view];
 
 //[maskView setCenter:currentPosition];
 //[photoView setCenter:currentPosition];
 if([touches count] == 1)
 {
 [photoView setCenter:currentPosition];
 }
 else if([touches count] == 2)
 {
 
 }
 }
 }
 */

-(void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
}

-(void)handlePinch:(UIPinchGestureRecognizer *)recognizer
{
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark -
#pragma mark Capture Screen Function
#pragma mark -

- (UIImage*)captureView:(UIView *)yourView
{
    UIGraphicsBeginImageContextWithOptions(yourView.bounds.size, yourView.opaque, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [yourView.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark -

@end
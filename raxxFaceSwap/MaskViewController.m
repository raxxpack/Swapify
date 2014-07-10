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

@property (nonatomic, strong) UIImageView* face1ImageView;
@property (nonatomic, strong) UIImageView* face2ImageView;
@property (nonatomic, strong) UIView* tapOverView;
@property (assign) BOOL isTapOverViewShowing;

@end

@implementation MaskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.title = @"Face Swap!";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shakeNotification:)
												 name:@"UIEventSubtypeMotionShakeEnded" object:nil];
	
	self.view.backgroundColor = [UIColor whiteColor];
	self.imageView.image = [UIImage imageNamed:@"faceSwapTest.jpg"];
    
    self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageView.image.size.width, self.imageView.image.size.width);
	
    self.scrollView.contentSize = CGSizeMake(self.imageView.image.size.width, self.imageView.image.size.height+ 40);
	[self.scrollView removeGestureRecognizer:self.tapGesture];
	
	UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
	tap.delegate = self;
	UIPinchGestureRecognizer* pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinched:)];
	pinch.delegate = self;
	UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
	pan.delegate = self;
	UIRotationGestureRecognizer* rotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotated:)];
	rotate.delegate = self;
	
	UITapGestureRecognizer* tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
	tap2.delegate = self;
	UIPinchGestureRecognizer* pinch2 = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinched:)];
	pinch2.delegate = self;
	UIPanGestureRecognizer* pan2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
	pan2.delegate = self;
	UIRotationGestureRecognizer* rotate2 = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotated:)];
	rotate2.delegate = self;

	self.tapOverView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, self.scrollView.contentSize.width, self.scrollView.contentSize.height)];
	self.tapOverView.backgroundColor = [UIColor colorWithWhite:0.1	alpha:0.7 ];
	
	self.face1ImageView = [[UIImageView alloc] init];
	self.face1ImageView.userInteractionEnabled = NO;
	[self.face1ImageView addGestureRecognizer:pinch];
	[self.face1ImageView addGestureRecognizer:tap];
	[self.face1ImageView addGestureRecognizer:pan];
	[self.face1ImageView addGestureRecognizer:rotate];
	[self.scrollView addSubview:self.face1ImageView];
	
	self.face2ImageView = [[UIImageView alloc] init];
	self.face2ImageView.userInteractionEnabled = NO;
	[self.face2ImageView addGestureRecognizer:pinch2];
	[self.face2ImageView addGestureRecognizer:tap2];
	[self.face2ImageView addGestureRecognizer:pan2];
	[self.face2ImageView addGestureRecognizer:rotate2];
	[self.scrollView addSubview:self.face2ImageView];
	
}

- (void)editPressed:(id)sender {
	[super editButtonPressed];
	if (self.isEditToolbarOpen) {
		self.face1ImageView.userInteractionEnabled = YES;
		self.face2ImageView.userInteractionEnabled = YES;
		self.scrollView.scrollEnabled = NO;
	} else {
		self.face1ImageView.userInteractionEnabled = NO;
		self.face2ImageView.userInteractionEnabled = NO;
		self.scrollView.scrollEnabled = YES;
		[self.tapOverView removeFromSuperview];
		self.isTapOverViewShowing = NO;
	}
}


#pragma mark - Gesture Recognizer Methods

typedef enum {
    PinchAxisNone,
    PinchAxisHorizontal,
    PinchAxisVertical
} PinchAxis;

PinchAxis pinchGestureRecognizerAxis(UIPinchGestureRecognizer *r) {
    UIView *view = r.view;
    CGPoint touch0 = [r locationOfTouch:0 inView:view];
    CGPoint touch1 = [r locationOfTouch:1 inView:view];
    CGFloat tangent = fabsf((touch1.y - touch0.y) / (touch1.x - touch0.x));
    return
	tangent <= 0.2679491924f ? PinchAxisHorizontal // 15 degrees
	: tangent >= 3.7320508076f ? PinchAxisVertical   // 75 degrees
	: PinchAxisNone;
}

- (void)pinched:(UIPinchGestureRecognizer*)sender {
	
	if (self.isTapOverViewShowing) {
		if (pinchGestureRecognizerAxis(sender) == PinchAxisVertical) {
			sender.view.transform = CGAffineTransformScale(sender.view.transform, 1, sender.scale);
		} else if (pinchGestureRecognizerAxis(sender) == PinchAxisHorizontal) {
			sender.view.transform = CGAffineTransformScale(sender.view.transform, sender.scale, 1);
		} else {
			sender.view.transform = CGAffineTransformScale(sender.view.transform, sender.scale, sender.scale);
		}
		
		sender.scale = 1;
	}
}

- (void)tapped:(id)sender {
	UIImageView* imageView = (UIImageView*)((UITapGestureRecognizer*)sender).view;
	
	if (self.isTapOverViewShowing) {
		[self.tapOverView removeFromSuperview];
		self.isTapOverViewShowing = NO;
	} else {
		[self.scrollView addSubview:self.tapOverView];
		[self.scrollView bringSubviewToFront:imageView];
		self.isTapOverViewShowing = YES;
	}
}

- (void)panned:(UIPanGestureRecognizer*)sender {
	
	if (self.isTapOverViewShowing) {
		CGPoint translation = [sender translationInView:self.view];
		NSLog(@"%f %f", translation.x, translation.y);
		sender.view.center = CGPointMake(sender.view.center.x + translation.x, sender.view.center.y + translation.y);
		[sender setTranslation:CGPointZero inView:self.view];
	}
}

- (void)rotated:(id)sender {
	
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	return YES;
}

- (void) shakeNotification:(id)sender {
	[self getFaces];
}

#pragma mark - Face Swap Methods

- (void)getFaces {
	
	CIImage *myImage = [CIImage imageWithCGImage:[self.imageView.image CGImage]];
	NSNumber *orientation = [NSNumber numberWithInt:[self.imageView.image imageOrientation]+1];
	
	CIContext *context = [CIContext contextWithOptions:nil];
	NSDictionary *opts = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy];
	CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:context options:opts];
	
	opts = [NSDictionary dictionaryWithObject:orientation forKey:CIDetectorImageOrientation];
	NSArray *features = [detector featuresInImage:myImage options:opts];
	
    if (features.count >= 2) {
        CIFaceFeature* faceFeature1 = [features objectAtIndex:0];
        CIFaceFeature* faceFeature2 = [features objectAtIndex:1];
        
        CGRect faceRect1 = faceFeature1.bounds;
        CGRect faceRect2 = faceFeature2.bounds;
        
        CGRect temp1 = faceFeature1.bounds;
        CGRect temp2 = faceFeature2.bounds;
        
        CIImage* faceImage1 = [CIImage imageWithCGImage:[self.imageView.image CGImage]];
        faceImage1 = [faceImage1 imageByCroppingToRect:faceRect1];
        
        CIImage* faceImage2 = [CIImage imageWithCGImage:[self.imageView.image CGImage]];
        faceImage2 = [faceImage2 imageByCroppingToRect:faceRect2];
        
        //Face 1 divide by scale, Face 2 multiply by scale
        CGFloat scale = MIN(faceRect1.size.width/faceRect2.size.width, faceRect1.size.height/faceRect2.size.height);
		
        
        faceRect1.origin = CGPointMake(temp2.origin.x, self.imageView.image.size.height +40 - CGRectGetMaxY(temp2));
        UIImage* face1UIImage = [UIImage imageWithCIImage:faceImage1 scale:1/scale orientation:UIImageOrientationUp];
        
        faceRect2.origin = CGPointMake(temp1.origin.x, self.imageView.image.size.height+40 - CGRectGetMaxY(temp1));
        UIImage* face2UIImage = [UIImage imageWithCIImage:faceImage2 scale:scale orientation:UIImageOrientationUp];
        
		
        
        UIGraphicsBeginImageContextWithOptions(self.imageView.image.size, NO, 0.0);
        [self.imageView.image drawInRect:CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height)];
        
		face1UIImage = [self cropToCircle:face1UIImage andRect:faceRect1];
		face2UIImage = [self cropToCircle:face2UIImage andRect:faceRect2];
		
		self.face1ImageView.image = face1UIImage;
		self.face1ImageView.frame = faceRect1;
		
		self.face2ImageView.image = face2UIImage;
		self.face2ImageView.frame = faceRect2;
	}

}

- (UIImage*)cropToCircle:(UIImage*)face andRect:(CGRect)imageRect {
	
	imageRect = CGRectMake(0, 0, imageRect.size.width, imageRect.size.height);
	UIGraphicsBeginImageContextWithOptions(face.size, NO, 0.0);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:imageRect];
	[path addClip];
	[face drawInRect:imageRect];
	
	CGContextSetStrokeColorWithColor(ctx, [[UIColor clearColor] CGColor]);
	[path setLineWidth:2.0];
	[path stroke];
	
	UIImage* roundedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return roundedImage;
}

#pragma mark -- UIImagePickerController delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
	[super imagePickerController:picker didFinishPickingMediaWithInfo:info];
	self.tapOverView.frame = CGRectMake(0, 40, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
	self.face1ImageView.image = nil;
	self.face2ImageView.image = nil;
	[self getFaces];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[super imagePickerControllerDidCancel:picker];
}



@end
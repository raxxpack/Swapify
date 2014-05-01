//
//  MainViewController.m
//  raxxFaceSwap
//
//  Created by Rahim Mitha on 1/29/2014.
//  Copyright (c) 2014 Rahim Mitha. All rights reserved.
//

#import "MarkViewController.h"
#import "UIImage+raxxFaceDetection.h"
#import "TWTSideMenuViewController.h"
#import "UIView+Toast.h"

@interface MarkViewController ()

@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) UIView* markedAreasView;
@property (nonatomic, assign) BOOL isHighlightedState;

@end

@implementation MarkViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		
    }
    return self;
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	self.title = @"Face Detector";
	
	self.view.backgroundColor = [UIColor whiteColor];
	self.markedAreasView = [[UIView alloc] init];
	
	[self.view makeMultiToastBottomCentered:@"Tap to detect faces!" duration:3.0];
}

- (void)markFaces:(id)sender {
	
	if (!self.isHighlightedState) {
		self.markedAreasView = [self.imageView.image markFaces:self.imageView];
		[self.scrollView addSubview:self.markedAreasView];
		self.isHighlightedState = YES;
	} else {
		[self.markedAreasView removeFromSuperview];
		self.isHighlightedState = NO;
	}
}

- (void)unmarkFaces {
	if (self.isHighlightedState) {
		[self markFaces:nil];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)handleTap:(id)sender {
	if (self.isHighlightedState) {
		[self unmarkFaces];
	} else {
		[self markFaces:nil];
	}
}

#pragma mark -- UIImagePickerController delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
	[self unmarkFaces];
	[super imagePickerController:picker didFinishPickingMediaWithInfo:info];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[super imagePickerControllerDidCancel:picker];
}

@end

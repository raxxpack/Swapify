//
//  MainViewController.m
//  raxxFaceSwap
//
//  Created by Rahim Mitha on 1/29/2014.
//  Copyright (c) 2014 Rahim Mitha. All rights reserved.
//

#import "MainViewController.h"
#import "UIImage+raxxFaceDetection.h"

@interface MainViewController ()

@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) UIView* markedAreasView;
@property (nonatomic, assign) BOOL isHighlightedState;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
	self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"facedetectionpic.jpg"]];
	self.imageView.frame = (CGRect) {
		.origin = CGPointMake(self.imageView.frame.origin.x, 44),
		.size = self.imageView.image.size
	};
	[self.view addSubview:self.imageView];
	
	self.markedAreasView = [[UIView alloc] init];
	
	UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
							initWithTitle:@"Mark Faces" style:UIBarButtonItemStyleBordered target:self action:@selector(markFaces:)];
	[[self navigationItem] setRightBarButtonItem:bbi];
	UIBarButtonItem *leftButton =[[UIBarButtonItem alloc]
								  initWithTitle:@"Pick Image" style:UIBarButtonItemStyleBordered target:self action:@selector(selectImage:)];
	[[self navigationItem] setLeftBarButtonItem:leftButton];
	
	
}

- (void)markFaces:(id)sender {
	
	if (!self.isHighlightedState) {
		self.markedAreasView = [self.imageView.image markFaces:self.imageView];
		[self.view addSubview:self.markedAreasView];
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

- (void)selectImage:(id)sender {
	
	UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	imagePicker.delegate = self;
	imagePicker.allowsEditing = YES;
	[self presentViewController:imagePicker animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -- UIImagePickerController delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
	[self unmarkFaces];
	
	UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
	self.imageView.image = image;
	self.imageView.frame = (CGRect) {
		.origin = CGPointMake(self.imageView.frame.origin.x, 44),
		.size = self.imageView.image.size
	};
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self dismissViewControllerAnimated:YES completion:nil];
}


@end

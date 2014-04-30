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

@interface MarkViewController ()

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) UIView* markedAreasView;
@property (nonatomic, assign) BOOL isHighlightedState;
@property (nonatomic, strong) UITapGestureRecognizer* tapGesture;

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
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
	self.tapGesture.delegate = self;
	
	self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
	self.scrollView.delegate = self;
	[self.scrollView addGestureRecognizer:self.tapGesture];
	[self.view addSubview:self.scrollView];
	
	
	self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SteveJobs.jpg"]];
	self.imageView.frame = (CGRect) {
		.origin = CGPointMake(self.imageView.frame.origin.x, 44),
		.size = self.imageView.image.size
	};
	self.scrollView.contentSize = self.imageView.image.size;
	[self.scrollView addSubview:self.imageView];
	
	self.markedAreasView = [[UIView alloc] init];
	
	//	UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
	//							initWithTitle:@"Mark Faces" style:UIBarButtonItemStyleBordered target:self action:@selector(markFaces:)];
	//	[[self navigationItem] setRightBarButtonItem:bbi];
	UIBarButtonItem *openItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(openButtonPressed)];
    self.navigationItem.leftBarButtonItem = openItem;
	UIBarButtonItem *rightButton =[[UIBarButtonItem alloc]
								   initWithTitle:@"Pick Image" style:UIBarButtonItemStyleBordered target:self action:@selector(selectImage:)];
	[[self navigationItem] setRightBarButtonItem:rightButton];
	
	
}

- (void)openButtonPressed {
	[self.sideMenuViewController openMenuAnimated:YES completion:nil];
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

- (void)selectImage:(id)sender {
	
	UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
	
	imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera|UIImagePickerControllerSourceTypePhotoLibrary;
	}
	imagePicker.delegate = self;
	imagePicker.allowsEditing = YES;
	[self presentViewController:imagePicker animated:YES completion:nil];
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
	
	UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
	self.imageView.image = image;
	self.imageView.frame = (CGRect) {
		.origin = CGPointMake(self.imageView.frame.origin.x, 44),
		.size = self.imageView.image.size
	};
	self.scrollView.contentSize = self.imageView.frame.size;
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- UIScrollView delegate methods



@end

//
//  EditorViewController.m
//  raxxFaceSwap
//
//  Created by Rahim Mitha on 2014-04-30.
//  Copyright (c) 2014 Rahim Mitha. All rights reserved.
//

#import "EditorViewController.h"
#import "TWTSideMenuViewController.h"
#import "UIView+Toast.h"

@interface EditorViewController ()

@property (nonatomic, assign) BOOL isEditToolbarOpen;

@end

@implementation EditorViewController

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
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
	self.tapGesture.delegate = self;
	
	self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - 44.0f)];
	[self.scrollView setShowsHorizontalScrollIndicator:NO];
	[self.scrollView setShowsVerticalScrollIndicator:NO];
	self.scrollView.delegate = self;
	[self.scrollView addGestureRecognizer:self.tapGesture];
	[self.view addSubview:self.scrollView];
	
	
	self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SteveJobs.jpg"]];
	self.imageView.frame = (CGRect) {
		.origin = CGPointMake(self.imageView.frame.origin.x, 44),
		.size = self.imageView.image.size
	};
	self.scrollView.contentSize = CGSizeMake(self.imageView.image.size.width, self.imageView.image.size.height);
	[self.scrollView addSubview:self.imageView];
	
	UIBarButtonItem *openItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(openButtonPressed)];
    self.navigationItem.leftBarButtonItem = openItem;
	
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(selectImage:)];
	
	[[self navigationItem] setRightBarButtonItem:rightButton];
	
	[self initToolbar];
	
}

- (void)initToolbar {
	
	UIBarButtonItem* undoButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(undoPressed:)];
	UIBarButtonItem* shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(sharePressed:)];
	UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPressed:)];
	UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
	UIBarButtonItem* fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
	
	[self setToolbarItems:[NSArray arrayWithObjects:fixedSpace, undoButton, flexibleSpace, editButton, flexibleSpace, shareButton, fixedSpace, nil] animated:YES];
	self.navigationController.toolbarHidden = NO;
}

- (void)initEditToolbar {
	
	UIBarButtonItem* undoButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(undoPressed:)];
	UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editPressed:)];
	UIBarButtonItem* redoButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRedo target:self action:@selector(redoPressed:)];
	
	//TODO:
	//Need rotate icon
//	UIBarButtonItem* rotateButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"asdf"] style:UIBarButtonItemStylePlain target:self action:@selector(rotatePressed:)];
	UIBarButtonItem* rotateButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(rotatePressed:)];
	
	UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
	UIBarButtonItem* fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
	
	[self setToolbarItems:[NSArray arrayWithObjects:fixedSpace, undoButton, flexibleSpace, redoButton, flexibleSpace, rotateButton, flexibleSpace, fixedSpace, editButton, fixedSpace, nil] animated:YES];
}

- (void)openButtonPressed {
	[self.sideMenuViewController openMenuAnimated:YES completion:nil];
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

- (void)undoPressed:(id)sender {
	
}

- (void)redoPressed:(id)sender {
	
}

- (void)rotatePressed:(id)sender {
	
	self.imageView.image = [self imageRotated];
}

- (UIImage *)imageRotated
{
	// calculate the size of the rotated view's containing box for our drawing space
	UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.imageView.frame.size.width, self.imageView.frame.size.height)];
	CGAffineTransform t = CGAffineTransformMakeRotation(M_PI/2);
	rotatedViewBox.transform = t;
	CGSize rotatedSize = rotatedViewBox.frame.size;
	
	// Create the bitmap context
	UIGraphicsBeginImageContext(rotatedSize);
	CGContextRef bitmap = UIGraphicsGetCurrentContext();
	
	// Move the origin to the middle of the image so we will rotate and scale around the center.
	CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
	
	//   // Rotate the image context
	CGContextRotateCTM(bitmap, M_PI/2);
	
	// Now, draw the rotated/scaled image into the context
	CGContextScaleCTM(bitmap, 1.0, -1.0);
	CGContextDrawImage(bitmap, CGRectMake(-self.imageView.frame.size.width / 2, -self.imageView.frame.size.height / 2, self.imageView.frame.size.width, self.imageView.frame.size.height), [self.imageView.image CGImage]);
	
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

- (void)sharePressed:(id)sender {
	
	UIGraphicsBeginImageContext(self.imageView.bounds.size);
	[self.imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	UIActivityViewController* shareController = [[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObject:image] applicationActivities: nil];
	[self presentViewController:shareController animated:YES completion:nil];
}

- (void)editPressed:(id)sender {
	if (self.isEditToolbarOpen) {
		[self closeEditToolbar];
		[self.navigationItem.rightBarButtonItem setEnabled:YES];
	} else {
		[self openEditToolbar];
		[self.navigationItem.rightBarButtonItem setEnabled:NO];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)handleTap:(id)sender {
	
}

- (void)closeEditToolbar {
	self.isEditToolbarOpen = NO;
	[self initToolbar];
}

- (void)openEditToolbar {
	self.isEditToolbarOpen = YES;
	[self initEditToolbar];
}

#pragma mark -- UIImagePickerController delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
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

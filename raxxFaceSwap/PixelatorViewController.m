//
//  PixelatorViewController.m
//  raxxFaceSwap
//
//  Created by Rahim Mitha on 2014-04-30.
//  Copyright (c) 2014 Rahim Mitha. All rights reserved.
//

#import "PixelatorViewController.h"
#import "UIImage+raxxFaceDetection.h"

@interface PixelatorViewController ()

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
	
	self.title = @"Pixelator";
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)pixellateFaces:(id)sender {
	self.imageView.image = [self.imageView.image pixelateFaces:self.imageView.image];
}

- (void)unPixellateFaces {

}

- (void)handleTap:(id)sender {
	[self pixellateFaces:nil];
}

@end

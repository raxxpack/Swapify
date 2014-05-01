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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end

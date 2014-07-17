//
//  ImageBrowserViewController.m
//  raxxFaceSwap
//
//  Created by Rahim Mitha on 2014-07-16.
//  Copyright (c) 2014 Rahim Mitha. All rights reserved.
//

#import "ImageBrowserViewController.h"
#import "TWTSideMenuViewController.h"


@interface ImageBrowserViewController ()

@end

@implementation ImageBrowserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.view.backgroundColor = [UIColor blackColor];
	
	UIBarButtonItem *openItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(openButtonPressed)];
    self.navigationItem.leftBarButtonItem = openItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openButtonPressed {
	[self.sideMenuViewController openMenuAnimated:YES completion:nil];
}

@end

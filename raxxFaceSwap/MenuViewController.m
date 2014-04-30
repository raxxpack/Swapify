//
//  MainViewController.m
//  raxxFaceSwap
//
//  Created by Rahim Mitha on 2014-04-30.
//  Copyright (c) 2014 Rahim Mitha. All rights reserved.
//

#import "MenuViewController.h"
#import "MarkViewController.h"

@interface MenuViewController ()

@property (nonatomic, strong) UIButton* markButton;

@end

@implementation MenuViewController

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
	
	self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.9];
	
//	[self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
	[self.navigationItem setTitle:@"Face Swap"];
	
	self.markButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
	[self.markButton setTitle:@"Detection" forState:UIControlStateNormal];
	[self.markButton setBackgroundColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.9]];
	[self.markButton addTarget:self action:@selector(markButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.markButton];

}

- (void)markButtonPressed:(id)sender {
	MarkViewController* vc = [[MarkViewController alloc] init];
	[self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}


@end

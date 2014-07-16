//
//  MainViewController.m
//  raxxFaceSwap
//
//  Created by Rahim Mitha on 2014-04-30.
//  Copyright (c) 2014 Rahim Mitha. All rights reserved.
//

#import "MenuViewController.h"
#import "MarkViewController.h"
#import "TWTSideMenuViewController.h"
#import "SideMenuTableViewCell.h"
#import "PixelatorViewController.h"
#import "FaceSwapViewController.h"
#import "MaskViewController.h"


#define kNUMBER_OF_MENU_OPTIONS 5

@interface MenuViewController ()

@property (nonatomic, strong) UIImageView* backgroundImageView;
@property (nonatomic, strong) UITableView* menuTableView;

@end
@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nil"]];
    self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    CGRect imageViewRect = [[UIScreen mainScreen] bounds];
    imageViewRect.size.width += 589;
    self.backgroundImageView.frame = imageViewRect;
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.backgroundImageView];
	
    NSDictionary *viewDictionary = @{ @"imageView" : self.backgroundImageView };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]" options:0 metrics:nil views:viewDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageView]" options:0 metrics:nil views:viewDictionary]];
	
	self.menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44.0f, 200.0f, 100.0f * kNUMBER_OF_MENU_OPTIONS)];
	self.menuTableView.backgroundColor = [UIColor clearColor];
	self.menuTableView.dataSource = self;
	self.menuTableView.delegate = self;
	self.menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.view addSubview:self.menuTableView];
	
}

- (void)markFacesButtonPressed
{
	if (!([((UINavigationController*)self.sideMenuViewController.mainViewController).viewControllers[0] isKindOfClass:[MarkViewController class]])) {
		
		UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:[MarkViewController new]];
		[self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:YES];
		
	} else {
		[self.sideMenuViewController closeMenuAnimated:YES completion:nil];
	}
}

- (void)pixelatorButtonPressed {
	if (!([((UINavigationController*)self.sideMenuViewController.mainViewController).viewControllers[0] isKindOfClass:[PixelatorViewController class]])) {
		
		UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:[PixelatorViewController new]];
		[self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:YES];
		
	} else {
		[self.sideMenuViewController closeMenuAnimated:YES completion:nil];
	}
}

- (void)faceSwapButtonPressed {
	if (!([((UINavigationController*)self.sideMenuViewController.mainViewController).viewControllers[0] isKindOfClass:[FaceSwapViewController class]])) {
		
		UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:[FaceSwapViewController new]];
		[self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:YES];
		
	} else {
		[self.sideMenuViewController closeMenuAnimated:YES completion:nil];
	}
}

- (void)test {

    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:[MaskViewController new]];
	controller.navigationBar.backgroundColor = [UIColor blackColor];
	controller.navigationBar.tintColor = [UIColor blackColor];
    [self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:YES];

}

- (void)closeButtonPressed
{
	[self.sideMenuViewController closeMenuAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


#pragma mark -- TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return kNUMBER_OF_MENU_OPTIONS;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *menuCellIdentifier = @"menuCellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCellIdentifier];
	
	if (cell == nil)
	{
		cell = [[SideMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
											reuseIdentifier:menuCellIdentifier];
		cell.backgroundColor = [UIColor clearColor];
		cell.textLabel.textColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.95 alpha:0.95];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		
	}
	
	if (indexPath.row == 0) {
		cell.textLabel.text = @"Return";
	} else if (indexPath.row == 1) {
		cell.textLabel.text = @"Detector";
	} else if (indexPath.row == 2) {
		cell.textLabel.text = @"Pixelator";
	} else if (indexPath.row == 3) {
		cell.textLabel.text = @"Face Swap";
	} else if (indexPath.row == 4) {
		cell.textLabel.text = @"Test";
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		[self closeButtonPressed];
	} else if (indexPath.row == 1) {
		[self markFacesButtonPressed];
	} else if (indexPath.row == 2) {
		[self pixelatorButtonPressed];
	} else if (indexPath.row == 3) {
		[self faceSwapButtonPressed];
	} else if (indexPath.row == 4) {
		[self test];
	}
}


@end

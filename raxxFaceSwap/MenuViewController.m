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
#import "ImageBrowserViewController.h"


#define kNUMBER_OF_MENU_OPTIONS 3

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
	
	self.sideMenuViewController.shadowColor = [UIColor whiteColor];
	
    CGRect imageViewRect = [[UIScreen mainScreen] bounds];
    imageViewRect.size.width += 589;
    self.backgroundImageView.frame = imageViewRect;
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.backgroundImageView];
	
    NSDictionary *viewDictionary = @{ @"imageView" : self.backgroundImageView };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]" options:0 metrics:nil views:viewDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageView]" options:0 metrics:nil views:viewDictionary]];
	
	self.menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 130.0f, 220.0f, self.view.frame.size.height - 44)];
	self.menuTableView.backgroundColor = [UIColor clearColor];
	self.menuTableView.dataSource = self;
	self.menuTableView.delegate = self;
	self.menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.menuTableView.scrollEnabled = NO;
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

- (void)faceSwapButtonPressedwithImage:(UIImage*)image {
	if (!([((UINavigationController*)self.sideMenuViewController.mainViewController).viewControllers[0] isKindOfClass:[MaskViewController class]])) {
		
		UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:[[MaskViewController alloc] initWithImage:image]];
		[self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:YES];
		
	} else {
		[self.sideMenuViewController closeMenuAnimated:YES completion:nil];
	}
}

- (void)browserButtonPressed {
	UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:[ImageBrowserViewController new]];
	controller.navigationBar.backgroundColor = [UIColor blackColor];
	controller.navigationBar.tintColor = [UIColor blackColor];
    [self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:YES];
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
	
	SideMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCellIdentifier];
	
	if (cell == nil)
	{
		cell = [[SideMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
											reuseIdentifier:menuCellIdentifier];
		cell.backgroundColor = [UIColor clearColor];
		cell.textLabel.textColor = [UIColor blackColor];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		
	}
	
	if (indexPath.row == 0) {
		cell.leftImageView.image = [UIImage imageNamed:@"theatreblack.png"];
		cell.nameLabel.text = @"Swap";
	} else if (indexPath.row == 1) {
		cell.leftImageView.image = [UIImage imageNamed:@"fantasyblack.png"];
		cell.nameLabel.text = @"Pixelate";
	} else if (indexPath.row == 2) {
		cell.leftImageView.image = [UIImage imageNamed:@"compasblack.png"];
		cell.nameLabel.text = @"Browse";
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		[self test];
	} else if (indexPath.row == 1) {
		[self pixelatorButtonPressed];
	} else if (indexPath.row == 2) {
		[self browserButtonPressed];
	}
}


@end

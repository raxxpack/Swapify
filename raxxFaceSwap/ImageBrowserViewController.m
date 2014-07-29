//
//  ImageBrowserViewController.m
//  raxxFaceSwap
//
//  Created by Rahim Mitha on 2014-07-16.
//  Copyright (c) 2014 Rahim Mitha. All rights reserved.
//

#import "ImageBrowserViewController.h"
#import "TWTSideMenuViewController.h"
#import "ThumbnailCell.h"
#import "MenuViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+Toast.h"

@interface ImageBrowserViewController ()

@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) NSDictionary* data;
@property (nonatomic, strong) NSOperationQueue* queue;
@property (nonatomic, strong) NSMutableArray* posts;
@property (nonatomic, strong) UIRefreshControl* refreshControl;
@property (nonatomic, strong) NSString* after;
@property (nonatomic, strong) UIView* displayView;
@property (nonatomic, strong) UIImageView* displayImageView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UITextView* displayTextView;
@property (assign) NSInteger currentIndex;

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
	
	self.navigationController.navigationBar.tintColor = kContrastTintColor;
	self.navigationController.navigationBar.barTintColor = kLightTintColor;
	
	self.view.backgroundColor = [UIColor blackColor];
	self.title = @"Browse";
	
	UIBarButtonItem *openItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(openButtonPressed)];
    self.navigationItem.leftBarButtonItem = openItem;
	
	self.queue = [[NSOperationQueue alloc] init];
	self.data = [[NSDictionary alloc] init];
	self.posts = [[NSMutableArray alloc] init];
	
	UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
	layout.minimumInteritemSpacing = 5.0f;
	layout.minimumLineSpacing = 5.0f;
	self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
	[self.collectionView registerClass:[ThumbnailCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
	self.collectionView.backgroundColor = [UIColor blackColor];
	self.collectionView.delegate = self;
	self.collectionView.dataSource = self;
	[self.view addSubview:self.collectionView];
	
	self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = kLightTintColor;
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
    self.collectionView.alwaysBounceVertical = YES;
	
	[self.view addSubview:self.displayView];
	
	[self initToolbarItems];
	
	[self getData];
}

- (void)refresh {
    [self.posts removeAllObjects];
	self.after = @"";
    [self getData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView*)displayView {
	if (!_displayView) {
		_displayView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.collectionView.frame.size.width, self.collectionView.frame.size.height)];
		_displayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
		
		self.displayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 280, 280)];
		self.displayImageView.backgroundColor = [UIColor blackColor];
		[_displayView addSubview:self.displayImageView];
		
		self.displayTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 320, 280, 100)];
		self.displayTextView.backgroundColor = [UIColor clearColor];
		self.displayTextView.userInteractionEnabled = NO;
		self.displayTextView.textColor = kLightTintColor;
		[_displayView addSubview:self.displayTextView];
		
		UISwipeGestureRecognizer* swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedDown)];
		swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
		[_displayView addGestureRecognizer:swipeDown];
		
		UISwipeGestureRecognizer* swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftPressed:)];
		swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
		[_displayView addGestureRecognizer:swipeRight];
		
		UISwipeGestureRecognizer* swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightPressed:)];
		swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
		[_displayView addGestureRecognizer:swipeLeft];
	}
	
	return _displayView;
}

- (void)swipedDown {
	[self hideDisplayView];
}

- (void)openButtonPressed {
	[self.sideMenuViewController openMenuAnimated:YES completion:nil];
}

- (void)getData {
	
	[self.queue addOperationWithBlock:^{
		NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://reddit.com/r/faceswap/.json?count=%lu&after=%@", (unsigned long)self.posts.count, self.after]]];
		NSLog(@"%@", data);
		
		NSError* error;
		self.data = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
		
		NSLog(@"%@", self.data);
		
		[self.posts addObjectsFromArray: [[self.data objectForKey:@"data"] objectForKey:@"children"]];
		self.after = [[[self.posts lastObject] objectForKey:@"data"] objectForKey:@"name"];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.collectionView reloadData];
			[self.refreshControl endRefreshing];
		});
		
	}];
	
}

- (void)initToolbarItems {
	
	self.navigationController.toolbar.tintColor = kContrastTintColor;
	self.navigationController.toolbar.barTintColor = kLightTintColor;
	UIBarButtonItem* space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
	UIBarButtonItem* previous = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(leftPressed:)];
	UIBarButtonItem* next = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(rightPressed:)];
	UIBarButtonItem* faceswap = [[UIBarButtonItem alloc] initWithTitle:@"Face Swap" style:UIBarButtonItemStylePlain target:self action:@selector(faceswapPressed:)];
	self.toolbarItems = [NSArray arrayWithObjects:previous, space, faceswap, space, next, nil];
}

- (void)showDisplayView {
	
	[self.view makeMultiToastBottomCentered:@"Swipe down to return." duration:2.0];
	
	[UIView animateWithDuration:0.3 animations:^{
		self.navigationController.toolbarHidden = NO;
		self.displayView.frame = CGRectMake(0, 64, self.displayView.frame.size.width, self.displayView.frame.size.height);
	}];
}

- (void)hideDisplayView {
	[UIView animateWithDuration:0.3 animations:^{
		self.navigationController.toolbarHidden = YES;
		self.displayView.frame = CGRectMake(0, self.view.frame.size.height, self.displayView.frame.size.width, self.displayView.frame.size.height);
	}];
}

- (void)leftPressed:(id)sender {
	
	if (self.currentIndex > 0) {
		self.currentIndex--;
		
		[UIView animateWithDuration:0.3 animations:^{
			
			[self.displayImageView setFrame:CGRectMake(320, self.displayImageView.frame.origin.y, self.displayImageView.frame.size.width, self.displayImageView.frame.size.height)];
			
		} completion:^(BOOL finished) {
			[self.displayImageView setFrame:CGRectMake(20, self.displayImageView.frame.origin.y, self.displayImageView.frame.size.width, self.displayImageView.frame.size.height)];
			
			NSString* url = [[[self.posts objectAtIndex:self.currentIndex] objectForKey:@"data"] objectForKey:@"url"];
			if (!([url rangeOfString:@"http://imgur.com"].location == NSNotFound)) {
				url = [url stringByAppendingString:@".jpg"];
			}
			NSURL* newURL = [NSURL URLWithString:url];
			
			[self.displayImageView sd_setImageWithURL:newURL placeholderImage:[UIImage imageNamed:@"nil"]];
			
			NSString* title = [[[self.posts objectAtIndex:self.currentIndex] objectForKey:@"data"] objectForKey:@"title"];
			NSString* author = [[[self.posts objectAtIndex:self.currentIndex] objectForKey:@"data"] objectForKey:@"author"];
			
			NSString* epochTime = [[[self.posts objectAtIndex:self.currentIndex] objectForKey:@"data"] objectForKey:@"created"];
			NSTimeInterval seconds = [epochTime doubleValue];
			NSDate* epochDate = [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
			NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
			[formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"];
			NSString* dateString = [formatter stringFromDate:epochDate];
			
			self.displayTextView.text = [NSString stringWithFormat:@"%@ - %@ \n%@", author, dateString, title];
			self.displayTextView.textColor = kLightTintColor;
		}];
	}
}

- (void)rightPressed:(id)sender {
	
	if (self.currentIndex <= self.posts.count - 2) {
		self.currentIndex++;
		
		[UIView animateWithDuration:0.3 animations:^{
			[self.displayImageView setFrame:CGRectMake(-320, self.displayImageView.frame.origin.y, self.displayImageView.frame.size.width, self.displayImageView.frame.size.height)];
			
		} completion:^(BOOL finished) {
			[self.displayImageView setFrame:CGRectMake(20, self.displayImageView.frame.origin.y, self.displayImageView.frame.size.width, self.displayImageView.frame.size.height)];
			
			NSString* url = [[[self.posts objectAtIndex:self.currentIndex] objectForKey:@"data"] objectForKey:@"url"];
			if (!([url rangeOfString:@"http://imgur.com"].location == NSNotFound)) {
				url = [url stringByAppendingString:@".jpg"];
			}
			NSURL* newURL = [NSURL URLWithString:url];
			
			[self.displayImageView sd_setImageWithURL:newURL placeholderImage:[UIImage imageNamed:@"nil"]];

			
			NSString* title = [[[self.posts objectAtIndex:self.currentIndex] objectForKey:@"data"] objectForKey:@"title"];
			NSString* author = [[[self.posts objectAtIndex:self.currentIndex] objectForKey:@"data"] objectForKey:@"author"];
			
			NSString* epochTime = [[[self.posts objectAtIndex:self.currentIndex] objectForKey:@"data"] objectForKey:@"created"];
			NSTimeInterval seconds = [epochTime doubleValue];
			NSDate* epochDate = [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
			NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
			[formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"];
			NSString* dateString = [formatter stringFromDate:epochDate];
			
			self.displayTextView.text = [NSString stringWithFormat:@"%@ - %@ \n%@", author, dateString, title];
			self.displayTextView.textColor = kLightTintColor;
		}];
	} else {
		[self getData];
	}
}

- (void)sharePressed:(id)sender {
	
}

- (void)faceswapPressed:(id)sender {
	[((MenuViewController*)self.sideMenuViewController.menuViewController) faceSwapButtonPressedwithImage:self.displayImageView.image];
}


#pragma mark - UICollectionView Methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	ThumbnailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
	cell.backgroundColor = [UIColor grayColor];
	
	if (self.posts.count > indexPath.item) {
		[cell.imageView sd_setImageWithURL:[[[self.posts objectAtIndex:indexPath.item] objectForKey:@"data"] objectForKey:@"thumbnail"] placeholderImage:[UIImage imageNamed:@"nil"]];
	}
	
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	[self showDisplayView];
	self.currentIndex = indexPath.item;
	
	
	NSString* url = [[[self.posts objectAtIndex:indexPath.item] objectForKey:@"data"] objectForKey:@"url"];
	if (!([url rangeOfString:@"http://imgur.com"].location == NSNotFound)) {
		url = [url stringByAppendingString:@".jpg"];
	}
	NSURL* newURL = [NSURL URLWithString:url];
	
	[self.displayImageView sd_setImageWithURL:newURL placeholderImage:[UIImage imageNamed:@"nil"]];
	
	NSString* title = [[[self.posts objectAtIndex:indexPath.item] objectForKey:@"data"] objectForKey:@"title"];
	NSString* author = [[[self.posts objectAtIndex:indexPath.item] objectForKey:@"data"] objectForKey:@"author"];
	
	NSString* epochTime = [[[self.posts objectAtIndex:indexPath.item] objectForKey:@"data"] objectForKey:@"created"];
	NSTimeInterval seconds = [epochTime doubleValue];
	NSDate* epochDate = [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"];
	NSString* dateString = [formatter stringFromDate:epochDate];
	
	self.displayTextView.text = [NSString stringWithFormat:@"%@ - %@ \n%@", author, dateString, title];
	self.displayTextView.textColor = kLightTintColor;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
	return 5;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	return UIEdgeInsetsMake(5, 10, 5, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	return CGSizeMake(70, 70);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.posts.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.collectionView.contentOffset.y >= (self.collectionView.contentSize.height - self.collectionView.bounds.size.height)/3 * 2) {
        
        if (self.queue.operationCount < 1) {
            [self getData];
        }
    }
}

@end

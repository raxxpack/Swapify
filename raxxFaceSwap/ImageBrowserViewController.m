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
#import <SDWebImage/UIImageView+WebCache.h>

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
@property (assign) NSInteger* currentIndex;

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
    self.refreshControl.tintColor = [UIColor whiteColor];
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
		self.displayImageView.backgroundColor = [UIColor redColor];
		[_displayView addSubview:self.displayImageView];
	}
	
	return _displayView;
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

	self.navigationController.toolbar.tintColor = [UIColor blackColor];
	UIBarButtonItem* space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
	UIBarButtonItem* previous = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(leftPressed:)];
	UIBarButtonItem* next = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(rightPressed:)];
	UIBarButtonItem* faceswap = [[UIBarButtonItem alloc] initWithTitle:@"Face Swap" style:UIBarButtonItemStylePlain target:self action:@selector(faceswapPressed:)];
	self.toolbarItems = [NSArray arrayWithObjects:previous, space, faceswap, space, next, nil];
}

- (void)showDisplayView {
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
	
}

- (void)rightPressed:(id)sender {
	
}

- (void)sharePressed:(id)sender {
	
}

- (void)faceswapPressed:(id)sender {
	
}


#pragma mark - UICollectionView Methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

	ThumbnailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
	cell.backgroundColor = [UIColor grayColor];
	
	[cell.imageView sd_setImageWithURL:[[[self.posts objectAtIndex:indexPath.item] objectForKey:@"data"] objectForKey:@"thumbnail"] placeholderImage:nil];
	
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	[self showDisplayView];
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

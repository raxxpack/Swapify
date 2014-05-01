//
//  EditorViewController.h
//  raxxFaceSwap
//
//  Created by Rahim Mitha on 2014-04-30.
//  Copyright (c) 2014 Rahim Mitha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditorViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) UITapGestureRecognizer* tapGesture;
@property (nonatomic, strong) UIToolbar* bottomToolbar;

@end

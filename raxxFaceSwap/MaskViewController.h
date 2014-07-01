//
//  MaskViewController.h
//  raxxFaceSwap
//
//  Created by rahim on 7/1/14.
//  Copyright (c) 2014 Rahim Mitha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaskViewController : UIViewController <UIGestureRecognizerDelegate>
{
    UIButton *btnEdit;
    BOOL isEditing;
    UIImageView *displayImage;
    UIImageView *photoView;
    UIImageView *maskView;
}

@end

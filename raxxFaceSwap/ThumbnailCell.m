//
//  ThumbnailCell.m
//  raxxFaceSwap
//
//  Created by Rahim Mitha on 2014-07-21.
//  Copyright (c) 2014 Rahim Mitha. All rights reserved.
//

#import "ThumbnailCell.h"

@implementation ThumbnailCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		
		self.imageView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
		[self.contentView addSubview:self.imageView];
		
		
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

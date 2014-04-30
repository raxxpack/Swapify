//
//  SideMenuTableViewCell.m
//  raxxFaceSwap
//
//  Created by Rahim Mitha on 2014-04-30.
//  Copyright (c) 2014 Rahim Mitha. All rights reserved.
//

#import "SideMenuTableViewCell.h"

@implementation SideMenuTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib
{

}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
	
	[super setHighlighted:highlighted animated:animated];
	if (highlighted) {
		[self.textLabel setTextColor:[UIColor colorWithRed:0.65 green:0.65 blue:0.75 alpha:0.8]];
	} else {
		[self.textLabel setTextColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.95 alpha:0.9]];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	
	if (selected) {
		[self.textLabel setTextColor:[UIColor colorWithRed:0.65 green:0.65 blue:0.75 alpha:0.8]];
	} else {
		[self.textLabel setTextColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.95 alpha:0.9]];
	}
}

- (void)setSelected:(BOOL)selected {
	[super setSelected:selected];
	[self.textLabel setTextColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.95 alpha:1]];
}

@end

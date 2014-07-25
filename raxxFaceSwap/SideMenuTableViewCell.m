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
		
		[self.textLabel setTextColor:[UIColor blackColor]];
		
		self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
		[self.contentView addSubview:self.leftImageView];
		
		self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 40, 100, 20)];
		self.nameLabel.textColor = [UIColor blackColor];
		self.nameLabel.font = [UIFont boldSystemFontOfSize:20.0f];
		[self.contentView addSubview:self.nameLabel];
		
    }
    return self;
}

- (void)awakeFromNib
{

}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
	
	[super setHighlighted:highlighted animated:animated];
	if (highlighted) {
		[self.nameLabel setTextColor:[UIColor colorWithRed:0.65 green:0.65 blue:0.75 alpha:0.8]];
	} else {
		self.nameLabel.textColor = [UIColor blackColor];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	
	if (selected) {
		[self.nameLabel setTextColor:[UIColor colorWithRed:0.65 green:0.65 blue:0.75 alpha:0.8]];
	} else {
		self.nameLabel.textColor = [UIColor blackColor];
	}
}

- (void)setSelected:(BOOL)selected {
	[super setSelected:selected];
	self.nameLabel.textColor = [UIColor blackColor];
}

@end

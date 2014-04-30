//
//  raxxWindow.m
//  raxxFaceSwap
//
//  Created by Rahim Mitha on 2014-04-30.
//  Copyright (c) 2014 Rahim Mitha. All rights reserved.
//

#import "raxxWindow.h"

@implementation raxxWindow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.type == UIEventSubtypeMotionShake)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UIEventSubtypeMotionShakeEnded" object:nil];
}

@end

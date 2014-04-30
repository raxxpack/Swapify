//
//  UIImage+raxxFaceDetection.h
//  raxxFaceDetector
//
//  Created by Rahim Mitha on 1/29/2014.
//  Copyright (c) 2014 Rahim Mitha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (raxxFaceDetection)


/**
 * Marks the faces in a UIImageView with a border and highlights eyes and mouth
 */
- (UIView*)markFaces:(UIImageView *)image; 
- (UIImage*) pixelateFaces:(UIImage*)fromImage;

@end

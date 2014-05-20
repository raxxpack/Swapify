//
//  UIImage+raxxFaceSwap.m
//  raxxFaceSwap
//
//  Created by Rahim Mitha on 2014-04-30.
//  Copyright (c) 2014 Rahim Mitha. All rights reserved.
//

#import "UIImage+raxxFaceSwap.h"

static const NSString* kLEFT_EYE_POSITION = @"LEFT_EYE_POSITION";
static const NSString* kRIGHT_EYE_POSITION = @"RIGHT_EYE_POSITION";
static const NSString* kMOUTH_POSITION = @"MOUTH_POSITION";
static const NSString* kANGLE = @"FACE_ANGLE";

@implementation UIImage (raxxFaceSwap)

- (UIImage*)swapFaces {

	CIImage *myImage = [CIImage imageWithCGImage:[self CGImage]];
	NSNumber *orientation = [NSNumber numberWithInt:[self imageOrientation]+1];
	
	CIContext *context = [CIContext contextWithOptions:nil];
	NSDictionary *opts = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy];
	CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:context options:opts];
	
	opts = [NSDictionary dictionaryWithObject:orientation forKey:CIDetectorImageOrientation];
	NSArray *features = [detector featuresInImage:myImage options:opts];
	
    if (features.count >= 2) {
        CIFaceFeature* faceFeature1 = [features objectAtIndex:0];
        CIFaceFeature* faceFeature2 = [features objectAtIndex:1];
        
        CGRect faceRect1 = faceFeature1.bounds;
        CGRect faceRect2 = faceFeature2.bounds;
        
        CGRect temp1 = faceFeature1.bounds;
        CGRect temp2 = faceFeature2.bounds;
        
        CIImage* faceImage1 = [CIImage imageWithCGImage:[self CGImage]];
        faceImage1 = [faceImage1 imageByCroppingToRect:faceRect1];
        
        CIImage* faceImage2 = [CIImage imageWithCGImage:[self CGImage]];
        faceImage2 = [faceImage2 imageByCroppingToRect:faceRect2];
        
        //Face 1 divide by scale, Face 2 multiply by scale
        CGFloat scale = MIN(faceRect1.size.width/faceRect2.size.width, faceRect1.size.height/faceRect2.size.height);

        faceRect1.origin = CGPointMake(temp2.origin.x, self.size.height - CGRectGetMaxY(temp2));
        UIImage* face1UIImage = [UIImage imageWithCIImage:faceImage1 scale:1/scale orientation:UIImageOrientationUp];
        
        faceRect2.origin = CGPointMake(temp1.origin.x, self.size.height - CGRectGetMaxY(temp1));
        UIImage* face2UIImage = [UIImage imageWithCIImage:faceImage2 scale:scale orientation:UIImageOrientationUp];
        
        
        //TODO: Circular mask -> clear out background
        
        
        UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
        [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
        [face1UIImage drawInRect:faceRect1];
        [face2UIImage drawInRect:faceRect2];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        return newImage;
    }
    return nil;
}

- (CGRect)getRectForFace:(CIFaceFeature*)face {
    
    CGFloat minX = MIN(MIN(face.leftEyePosition.x, face.rightEyePosition.x), face.mouthPosition.x);
    CGFloat minY = MIN(MIN(face.leftEyePosition.y, face.rightEyePosition.y), face.mouthPosition.y);
    CGFloat maxX = MAX(MAX(face.leftEyePosition.x, face.rightEyePosition.x), face.mouthPosition.x);
    CGFloat maxY = MAX(MAX(face.leftEyePosition.y, face.rightEyePosition.y), face.mouthPosition.y);
    
    return CGRectMake(minX, minY, maxX - minX, maxY - minY);
}

@end
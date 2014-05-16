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

- (NSArray*)swapFacesforImage:(UIImage*)image {

	CIImage *myImage = [CIImage imageWithCGImage:[image CGImage]];
	NSNumber *orientation = [NSNumber numberWithInt:[image imageOrientation]+1];
	
	CIContext *context = [CIContext contextWithOptions:nil];
	NSDictionary *opts = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy];
	CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:context options:opts];
	
	opts = [NSDictionary dictionaryWithObject:orientation forKey:CIDetectorImageOrientation];
	NSArray *features = [detector featuresInImage:myImage options:opts];
	
    if (features.count >= 2) {
        CIFaceFeature* faceFeature1 = [features objectAtIndex:0];
        CIFaceFeature* faceFeature2 = [features objectAtIndex:1];
        
        CGRect faceRect1 = [self getRectForFace:faceFeature1];
        CGRect faceRect2 = [self getRectForFace:faceFeature2];
        
        CIImage* faceImage1 = [CIImage imageWithCGImage:[image CGImage]];
        faceImage1 = [faceImage1 imageByCroppingToRect:faceRect1];
        
        CIImage* faceImage2 = [CIImage imageWithCGImage:[image CGImage]];
        faceImage2 = [faceImage2 imageByCroppingToRect:faceRect2];
        
        
    }
    
    
    
    
	NSMutableArray* facesArray = [[NSMutableArray alloc] init];
	
	for (CIFaceFeature* faceFeature in features) {
		
		NSMutableDictionary* face = [[NSMutableDictionary alloc] init];
		
		if (faceFeature.hasLeftEyePosition) {
			[face setObject: [NSValue valueWithCGPoint: faceFeature.leftEyePosition] forKey:kLEFT_EYE_POSITION];
		}
		if (faceFeature.hasRightEyePosition) {
			[face setObject:[NSValue valueWithCGPoint:faceFeature.rightEyePosition] forKey:kRIGHT_EYE_POSITION];
		}
		if (faceFeature.hasMouthPosition) {
			[face setObject:[NSValue valueWithCGPoint:faceFeature.mouthPosition] forKey:kMOUTH_POSITION];
		}
        if (faceFeature.hasFaceAngle) {
            [face setObject: [NSNumber numberWithFloat:faceFeature.faceAngle] forKey:kANGLE];
        }
		
        
		[facesArray addObject:face];
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
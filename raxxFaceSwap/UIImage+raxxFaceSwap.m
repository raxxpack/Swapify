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

@implementation UIImage (raxxFaceSwap)

- (UIImage*)faceSwap:(NSArray*)faces forImage:(UIImage*)image {
	
	//Detect Faces
	CIImage *myImage = [CIImage imageWithCGImage:[image CGImage]];
	NSNumber *orientation = [NSNumber numberWithInt:[image imageOrientation]+1];
	
	CIContext *context = [CIContext contextWithOptions:nil];
	NSDictionary *opts = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy];
	CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:context options:opts];
	
	opts = [NSDictionary dictionaryWithObject:orientation forKey:CIDetectorImageOrientation];
	NSArray *features = [detector featuresInImage:myImage options:opts];
	
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
		
		[facesArray addObject:face];
	}
	
	//TODO:
	//At this point we have all of the faces and their features in facesArray
	//Need to get the contours (somehow)
	
	return nil;
}

@end
//
//  UIImage+raxxFaceDetection.m
//  raxxFaceDetector
//
//  Created by Rahim Mitha on 1/29/2014.
//  Copyright (c) 2014 Rahim Mitha. All rights reserved.
//

#import "UIImage+raxxFaceDetection.h"

@implementation UIImage (raxxFaceDetection)

- (UIView*)markFaces:(UIImageView *)image {
	
	
    CIImage *myImage = [CIImage imageWithCGImage:[[image image] CGImage]];
    NSNumber *orientation = [NSNumber numberWithInt:[[image image] imageOrientation]+1];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    NSDictionary *opts = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:context options:opts];
    
    opts = [NSDictionary dictionaryWithObject:orientation forKey:CIDetectorImageOrientation];
    NSArray *features = [detector featuresInImage:myImage options:opts];
    
    UIView *foundFaces = [[UIView alloc] initWithFrame:[image frame]];
    for(CIFaceFeature* faceFeature in features) {
		
        UIView* faceView = [[UIView alloc] initWithFrame:faceFeature.bounds];
		
        faceView.layer.borderWidth = 1;
        faceView.layer.borderColor = [[UIColor redColor] CGColor];
		
		
		CGFloat faceWidth = faceView.frame.size.width;
		
		if(faceFeature.hasLeftEyePosition)
        {
            UIView* leftEyeView = [[UIView alloc] initWithFrame:CGRectMake(faceFeature.leftEyePosition.x-faceWidth*0.15, faceFeature.leftEyePosition.y-faceWidth*0.15, faceWidth*0.3, faceWidth*0.3)];
            [leftEyeView setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
            [leftEyeView setCenter:faceFeature.leftEyePosition];
			leftEyeView.layer.cornerRadius = faceWidth*0.15;
            [foundFaces addSubview:leftEyeView];
        }
        
        if(faceFeature.hasRightEyePosition)
        {
            UIView* leftEye = [[UIView alloc] initWithFrame:CGRectMake(faceFeature.rightEyePosition.x-faceWidth*0.15, faceFeature.rightEyePosition.y-faceWidth*0.15, faceWidth*0.3, faceWidth*0.3)];
            [leftEye setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
            [leftEye setCenter:faceFeature.rightEyePosition];
            leftEye.layer.cornerRadius = faceWidth*0.15;
            [foundFaces addSubview:leftEye];
        }
        
        if(faceFeature.hasMouthPosition)
        {
            UIView* mouth = [[UIView alloc] initWithFrame:CGRectMake(faceFeature.mouthPosition.x-faceWidth*0.2, faceFeature.mouthPosition.y-faceWidth*0.2, faceWidth*0.4, faceWidth*0.4)];
            [mouth setBackgroundColor:[[UIColor yellowColor] colorWithAlphaComponent:0.3]];
            [mouth setCenter:faceFeature.mouthPosition];
            mouth.layer.cornerRadius = faceWidth*0.2;
            [foundFaces addSubview:mouth];
        }
		
		
        [foundFaces addSubview:faceView];
    }
    [foundFaces setTransform:CGAffineTransformMakeScale(1, -1)];
    
	return foundFaces;
}


@end

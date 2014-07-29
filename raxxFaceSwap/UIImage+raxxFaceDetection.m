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
            [foundFaces addSubview:mouth];
        }
		
		
        [foundFaces addSubview:faceView];
    }
    [foundFaces setTransform:CGAffineTransformMakeScale(1, -1)];
    
	return foundFaces;
}

- (UIImage*) pixelateFaces:(UIImage*)fromImage
{
    CIFilter *filter= [CIFilter filterWithName:@"CIPixellate"];
	
    CIImage *inputImage = [[CIImage alloc] initWithImage:fromImage];
	CGFloat inputScale = MAX(fromImage.size.width, fromImage.size.height)/60;
    [filter setValue:[NSNumber numberWithDouble:inputScale] forKey:@"inputScale"];
    [filter setValue:inputImage forKey:@"inputImage"];
	CIImage *pixellatedImage = [filter outputImage];
	
	CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:nil];
	NSArray* faceArray = [detector featuresInImage:inputImage options:nil];
	
	CIImage* maskImage = nil;
	
	for (CIFeature *f in faceArray) {
		maskImage = nil;
		
		NSLog(@"%f , %f", f.bounds.origin.x, f.bounds.origin.y);
		
		CGFloat centerX = f.bounds.origin.x + f.bounds.size.width / 2.0f;
		CGFloat centerY = f.bounds.origin.y + f.bounds.size.height / 2.0f;
		CGFloat radius = MIN(f.bounds.size.width, f.bounds.size.height) / 1.5f;
		CIFilter *radialGradient = [CIFilter filterWithName:@"CIRadialGradient" keysAndValues:
		@"inputRadius0", @(radius),
		@"inputRadius1", @(radius + 1.0f),
		@"inputColor0", [CIColor colorWithRed:0 green:1 blue:0 alpha:1],
		@"inputColor1", [CIColor colorWithRed:0 green:0 blue:0 alpha:1],
		kCIInputCenterKey, [CIVector vectorWithX:centerX Y:centerY],
		nil];
		
		CIImage *circleImage = [radialGradient valueForKey:kCIOutputImageKey];
		if (maskImage == nil) {
			maskImage = circleImage;
		} else {
			maskImage = [[CIFilter filterWithName:@"CISourceOverCompositing" keysAndValues:kCIInputImageKey, circleImage, kCIInputBackgroundImageKey, maskImage, nil] valueForKey:kCIOutputImageKey];
		}
	}
	
	CIFilter *blendFilter = [CIFilter filterWithName:@"CIBlendWithMask"];
	[blendFilter setValue:pixellatedImage forKey:@"inputImage"];
	[blendFilter setValue:inputImage forKey:@"inputBackgroundImage"];
	[blendFilter setValue:maskImage forKey:@"inputMaskImage"];
	CIImage *outputImage = [blendFilter outputImage];
	
	return [UIImage imageWithCIImage:outputImage];
	
}

- (UIImage*) pixelateFaces:(UIImage*)fromImage withPoint:(CGPoint)point
{
    CIFilter *filter= [CIFilter filterWithName:@"CIPixellate"];
	
    CIImage *inputImage = [[CIImage alloc] initWithImage:fromImage];
	CGFloat inputScale = MAX(fromImage.size.width, fromImage.size.height)/60;
    [filter setValue:[NSNumber numberWithDouble:inputScale] forKey:@"inputScale"];
    [filter setValue:inputImage forKey:@"inputImage"];
	CIImage *pixellatedImage = [filter outputImage];
	
	CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:nil];
	NSArray* faceArray = [detector featuresInImage:inputImage options:nil];
	
	CIImage* maskImage = nil;
	
	int difference = 0;
	
	CGFloat centerX;
	CGFloat centerY;
	CGFloat radius;
	
	for (CIFeature *f in faceArray) {
		
		CGPoint origin = f.bounds.origin;
		
		if (sqrt(pow((origin.x - point.x), 2) + pow((origin.y - point.y), 2)) < difference) {
			difference = sqrt(pow((origin.x - point.x), 2) + pow((origin.y - point.y), 2));
			
			centerX = f.bounds.origin.x + f.bounds.size.width / 2.0f;
			centerY = f.bounds.origin.y + f.bounds.size.height / 2.0f;
			radius = MIN(f.bounds.size.width, f.bounds.size.height) / 1.5f;
		}
	}
	
	CIFilter *radialGradient = [CIFilter filterWithName:@"CIRadialGradient" keysAndValues:
								@"inputRadius0", @(radius),
								@"inputRadius1", @(radius + 1.0f),
								@"inputColor0", [CIColor colorWithRed:0 green:1 blue:0 alpha:1],
								@"inputColor1", [CIColor colorWithRed:0 green:0 blue:0 alpha:1],
								kCIInputCenterKey, [CIVector vectorWithX:centerX Y:centerY],
								nil];
	
	CIImage *circleImage = [radialGradient valueForKey:kCIOutputImageKey];
	if (maskImage == nil) {
		maskImage = circleImage;
	} else {
		maskImage = [[CIFilter filterWithName:@"CISourceOverCompositing" keysAndValues:kCIInputImageKey, circleImage, kCIInputBackgroundImageKey, maskImage, nil] valueForKey:kCIOutputImageKey];
	}
	
	CIFilter *blendFilter = [CIFilter filterWithName:@"CIBlendWithMask"];
	[blendFilter setValue:pixellatedImage forKey:@"inputImage"];
	[blendFilter setValue:inputImage forKey:@"inputBackgroundImage"];
	[blendFilter setValue:maskImage forKey:@"inputMaskImage"];
	CIImage *outputImage = [blendFilter outputImage];
	
	return [UIImage imageWithCIImage:outputImage];
	
}

@end

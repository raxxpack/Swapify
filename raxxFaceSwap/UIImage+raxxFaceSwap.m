//
//  UIImage+raxxFaceSwap.m
//  raxxFaceSwap
//
//  Created by Rahim Mitha on 2014-04-30.
//  Copyright (c) 2014 Rahim Mitha. All rights reserved.
//

#import "UIImage+raxxFaceSwap.h"
#import <QuartzCore/QuartzCore.h>


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
//        faceImage1 = [self getMaskImage:faceFeature1];
        
        CIImage* faceImage2 = [CIImage imageWithCGImage:[self CGImage]];
        faceImage2 = [faceImage2 imageByCroppingToRect:faceRect2];
//        faceImage2 = [self getMaskImage:faceFeature2];
        
        //Face 1 divide by scale, Face 2 multiply by scale
        CGFloat scale = MIN(faceRect1.size.width/faceRect2.size.width, faceRect1.size.height/faceRect2.size.height);
    
        
        faceRect1.origin = CGPointMake(temp2.origin.x, self.size.height - CGRectGetMaxY(temp2));
        UIImage* face1UIImage = [UIImage imageWithCIImage:faceImage1 scale:1/scale orientation:UIImageOrientationUp];
        
        faceRect2.origin = CGPointMake(temp1.origin.x, self.size.height - CGRectGetMaxY(temp1));
        UIImage* face2UIImage = [UIImage imageWithCIImage:faceImage2 scale:scale orientation:UIImageOrientationUp];
        

        
        UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
        [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
        
//        //TODO: Circular mask -> clear out background
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
//        CGContextSaveGState(contextRef);
//        
//        CGFloat imageCenterX = faceRect1.size.width/2;
//        CGFloat imageCenterY = faceRect1.size.height/2;
//        CGContextBeginPath(contextRef);
//        CGContextAddArc(contextRef, imageCenterX, imageCenterY, faceRect1.size.width/2, 0, 2*M_PI, 0);
//        CGContextClosePath(contextRef);
//        CGContextClip(contextRef);
//
//        CGContextRestoreGState(contextRef);
        
        CGContextSaveGState(contextRef);
        CGContextSetBlendMode(contextRef,kCGBlendModeDestinationIn);
        CGContextFillEllipseInRect(contextRef,faceRect1);
        
        [face1UIImage drawInRect:faceRect1];
        [face2UIImage drawInRect:faceRect2];
        
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        
                CGContextRestoreGState(contextRef);
        
        return newImage;
    }
    return nil;
}

- (CIImage*)getMaskImage:(CIFaceFeature*)f{
    
	CIImage* maskImage = nil;
    
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
    
    CIImage *inputImage = [[CIImage alloc] initWithImage:self];
    inputImage = [inputImage imageByCroppingToRect:f.bounds];
    
    CIFilter *blendFilter = [CIFilter filterWithName:@"CIBlendWithMask"];
	[blendFilter setValue:inputImage forKey:@"inputBackgroundImage"];
	[blendFilter setValue:maskImage forKey:@"inputMaskImage"];
	CIImage *outputImage = [blendFilter outputImage];
    
    
    return outputImage;
}

- (CGRect)getRectForFace:(CIFaceFeature*)face {
    
    CGFloat minX = MIN(MIN(face.leftEyePosition.x, face.rightEyePosition.x), face.mouthPosition.x);
    CGFloat minY = MIN(MIN(face.leftEyePosition.y, face.rightEyePosition.y), face.mouthPosition.y);
    CGFloat maxX = MAX(MAX(face.leftEyePosition.x, face.rightEyePosition.x), face.mouthPosition.x);
    CGFloat maxY = MAX(MAX(face.leftEyePosition.y, face.rightEyePosition.y), face.mouthPosition.y);
    
    return CGRectMake(minX, minY, maxX - minX, maxY - minY);
}


@end
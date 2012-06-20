//
//  UIImage+AMHighlightedImage.m
//  AMSpringboard
//
//  Created by Andy Mroczkowski on 4/1/11.
//  Copyright 2011 Andy Mroczkowski. All rights reserved.
//

#import "UIImage+AMHighlightedImage.h"


//MAKE_CATEGORIES_LOADABLE(UIImage_AMShadedImage)


@implementation UIImage (AMShadedImage)


- (UIImage*) copyShadedImage
{
    return [self copyImageWithShading:kAMShadedImageDefaultShading];
}


- (UIImage*) copyImageWithShading:(CGFloat)shading
{
    CGImageRef cgImage = self.CGImage;
    
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 CGImageGetWidth(cgImage),
                                                 CGImageGetHeight(cgImage),
                                                 CGImageGetBitsPerComponent(cgImage),
                                                 CGImageGetBytesPerRow(cgImage),
                                                 CGColorSpaceCreateDeviceRGB(),                  
                                                 kCGImageAlphaPremultipliedLast);
    
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextClipToMask(context, rect, cgImage);
    
    CGContextDrawImage(context, rect, cgImage);
    
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, shading);  
    CGContextFillRect(context, rect);
    
    CGImageRef cgImageHighlight = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    UIImage* highlightImage = [[UIImage alloc] initWithCGImage:cgImageHighlight];
    CGImageRelease(cgImageHighlight);

    return highlightImage;
}


@end

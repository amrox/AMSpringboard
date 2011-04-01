//
//  UIImage+AMHighlightedImage.h
//  AMSpringboard
//
//  Created by Andy Mroczkowski on 4/1/11.
//  Copyright 2011 Andy Mroczkowski. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (AMShadedImage)

#define kAMShadedImageDefaultShading (0.4)

- (UIImage*) copyShadedImage;
- (UIImage*) copyImageWithShading:(CGFloat)shading;

@end

//
//  AMAdjustingImageView.m
//  AMSpringboardView
//
//  Created by Andy Mroczkowski on 3/22/11.
//  Copyright 2011 MindSnacks. All rights reserved.
//

#import "AMAdjustingImageView.h"


@implementation AMAdjustingImageView

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

//    [super drawRect:rect];
    
    [self.image drawAtPoint:CGPointZero];
    
    CGContextSetBlendMode (context, kCGBlendModeMultiply);
    UIColor* color = [UIColor colorWithWhite:1.0 alpha:0.1];
    CGContextSetFillColor(context, CGColorGetComponents(color.CGColor));      
    CGContextFillRect (context, rect);
    CGContextRestoreGState(context);

}

- (void) drawRect2:(CGRect)rect
{
    return;
    
    //    [[UIColor colorWithWhite:0.0 alpha:0.5] setFill];
    //    UIRectFillUsingBlendMode( rect , kCGBlendModeMultiply );
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    //    CGContextSetBlendMode (context, kCGBlendModeClear);
    UIColor* color = [UIColor colorWithWhite:1.0 alpha:0.1];
    CGContextSetFillColor(context, CGColorGetComponents(color.CGColor));      
    //    CGContextFillRect (context, self.bounds);
    CGContextRestoreGState(context);
}

@end

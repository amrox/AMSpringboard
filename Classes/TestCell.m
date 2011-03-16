//
//  TestCell.m
//  AMSpringboardView
//
//  Created by Andy Mroczkowski on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestCell.h"


@implementation TestCell


- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(ctx);
    
    [[UIColor redColor] set];
    UIBezierPath* path = [UIBezierPath bezierPathWithRect:self.bounds];
    [path stroke];
    
    UIGraphicsPopContext();
}

@end

//
//  UIColor+AMHexString.h
//  AMStuff
//
//  Created by Andy Mroczkowski on 3/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIColor (AMHexString)

+ (UIColor*) am_colorWithHexString:(NSString *)string alpha:(CGFloat)alpha;

@end

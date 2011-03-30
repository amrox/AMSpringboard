//
//  UIColor+AMHexString.m
//  AMStuff
//
//  Created by Andy Mroczkowski on 3/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIColor+AMHexString.h"

#import "NSString+AMHexString.h"

@implementation UIColor (AMHexString)

+ (UIColor*) am_colorWithHexString:(NSString *)string alpha:(CGFloat)alpha
{
	NSInteger startIndex = 0;
	CGFloat color[3] = { 0x0, 0x0, 0x0 };
	
	if( ([string length] == 7) && [string hasPrefix:@"#"] )
	{
		startIndex = 1;
	}
	
	if( ([string length]-startIndex) == 6 )
	{
		NSString *redString = [string substringWithRange:NSMakeRange(0+startIndex, 2)];
		NSString *greenString = [string substringWithRange:NSMakeRange(2+startIndex, 2)];
		NSString *blueString = [string substringWithRange:NSMakeRange(4+startIndex, 2)];
		
		color[0] = [redString am_hexValue];
		color[1] = [greenString am_hexValue];
		color[2] = [blueString am_hexValue];
	}
	return [UIColor colorWithRed:color[0]/0xff
						   green:color[1]/0xff
							blue:color[2]/0xff
						   alpha:alpha];
}

@end

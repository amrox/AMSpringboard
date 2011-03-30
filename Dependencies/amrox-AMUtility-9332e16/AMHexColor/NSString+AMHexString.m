//
//  NSString+AMHexString.m
//  VocabDownloadTest
//
//  Created by Andy Mroczkowski on 3/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSString+AMHexString.h"


@implementation NSString (AMHexString)

- (NSUInteger)am_hexValue
{
	NSUInteger start = 0;
	
	// -- strip leading #
	if( [self hasPrefix:@"#"] )
		start++;
	
	NSUInteger hex = 0x0;
	NSInteger x;
	NSString *s;
	for( NSUInteger i=start; i<[self length]; i++ )
	{
		s = [self substringWithRange:NSMakeRange( i, 1 )];
		x = [s integerValue];
        
		NSAssert( x < 0xa, @"Something is wrong, should always be less than 10" );
		
		if( x == 0 )
		{
			unichar c = [[s lowercaseString] characterAtIndex:0];
			switch (c)
			{
				case '0':
					x = 0;
					break;
				case 'a':
					x = 0xa;
					break;
				case 'b':
					x = 0xb;
					break;					
				case 'c':
					x = 0xc;
					break;
				case 'd':
					x = 0xd;
					break;
				case 'e':
					x = 0xe;
					break;
				case 'f':
					x = 0xf;
					break;
				default:
					return 0x0;
			}
		}
		hex += x << 4*([self length]-i-1);
	}
	return hex;
}

@end

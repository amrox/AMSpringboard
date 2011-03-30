//
//  AMExtensions.m
//  AMSpringboardView
//
//  Created by Andy Mroczkowski on 3/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AMExtensions.h"


@implementation NSArray (AMExtensions)

- (id) am_firstObject
{
    if( [self count] > 0 )
        return [self objectAtIndex:0];
    return nil;
}

@end

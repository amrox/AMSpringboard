//
//  NSIndexPath+AMSpringboardView.m
//  AMSpringboardView
//
//  Created by Andy Mroczkowski on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSIndexPath+AMSpringboardView.h"


@implementation NSIndexPath (AMSpringboardView)

+ (NSIndexPath*) indexPathForPage:(NSUInteger)page row:(NSUInteger)row column:(NSUInteger)column
{
    NSUInteger idx[3] = {page, row, column};
    return [NSIndexPath indexPathWithIndexes:idx length:3];
}

- (NSUInteger) springboardPage
{
    return [self indexAtPosition:0];
}


- (NSUInteger) springboardRow
{
    return [self indexAtPosition:1];
}


- (NSUInteger) springboardColumn
{
    return [self indexAtPosition:2];
}


@end

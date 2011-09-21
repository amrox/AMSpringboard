//
//  NSIndexPath+AMSpringboardView.m
//  AMSpringboardView
//
//  Created by Andy Mroczkowski on 3/6/11.
//  Copyright 2011 Andy Mroczkowski. All rights reserved.
//

#import "NSIndexPath+AMSpringboard.h"
#import "LoadableCategory.h"


MAKE_CATEGORIES_LOADABLE(NSIndexPath_AMSpringboard)


@implementation NSIndexPath (AMSpringboard)


+ (NSIndexPath*) indexPathForSpringboardPage:(NSUInteger)page column:(NSUInteger)column row:(NSUInteger)row;
{
    NSUInteger idx[3] = {page, column, row};
    return [NSIndexPath indexPathWithIndexes:idx length:3];
}


+ (NSIndexPath*) indexPathForSpringboardPage:(NSUInteger)page column:(NSUInteger)column
{
    return [self indexPathForSpringboardPage:page column:column row:kAMSpringboardViewAllRows];
}


- (NSUInteger) springboardPage
{
    return [self indexAtPosition:0];
}


- (NSUInteger) springboardColumn
{
    return [self indexAtPosition:1];
}


- (NSUInteger) springboardRow
{
    return [self indexAtPosition:2];
}


@end


//
//  AMSpringboardItemSpecifier.m
//  AMSpringboardView
//
//  Created by Andy Mroczkowski on 3/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AMSpringboardItemSpecifier.h"

NSString* const kAMSpringboardBoardItemIdentifier = @"identifier";
NSString* const kAMSpringboardBoardItemTitle = @"title";
NSString* const kAMSpringboardBoardItemImageName = @"image";


@implementation AMSpringboardItemSpecifier

- (id) initWithDictionary:(NSDictionary*)dict
{
	self = [super init];
	if (self != nil)
	{
        _dict = [dict retain];
	}
	return self;
}


- (id) init
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:NSStringFromClass([self class]) forKey:kAMSpringboardBoardItemIdentifier];
    id s = [self initWithDictionary:dict];
    [dict release];
    return s;
}


- (void) dealloc
{
	[_dict release];
	[super dealloc];
}


- (NSDictionary*) dictionaryRepresentation
{
    return [[_dict copy] autorelease];;
}


- (id) objectForKey:(NSString*)key
{
	return [_dict objectForKey:key];
}


- (void) setObject:(id)object forKey:(NSString*)key
{
	[_dict setObject:object forKey:key];
}


#pragma NSCoding

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self != nil)
    {
        _dict = [aDecoder decodeObjectForKey:@"dict"];
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder;
{
    [aCoder encodeObject:_dict forKey:@"dict"];
}


@end



@implementation AMSpringboardItemSpecifier (Convenience)

+ (id) itemSpecifierWithTitle:(NSString*)title imageName:(NSString*)imageName
{
    AMSpringboardItemSpecifier* item = [[AMSpringboardItemSpecifier alloc] init];
    if( title != nil )
        [item setObject:title forKey:kAMSpringboardBoardItemTitle];
    if( imageName != nil )
        [item setObject:imageName forKey:kAMSpringboardBoardItemImageName];
    return [item autorelease];
}

@end


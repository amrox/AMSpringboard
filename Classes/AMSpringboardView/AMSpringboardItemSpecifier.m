//
//  AMSpringboardItemSpecifier.m
//  AMSpringboardView
//
//  Created by Andy Mroczkowski on 3/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AMSpringboardItemSpecifier.h"


@implementation AMSpringboardItemSpecifier

- (id) init
{
	self = [super init];
	if (self != nil)
	{
		_dict = [[NSMutableDictionary alloc] init];
	}
	return self;
}


- (void) dealloc
{
	[_dict release];
	[super dealloc];
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

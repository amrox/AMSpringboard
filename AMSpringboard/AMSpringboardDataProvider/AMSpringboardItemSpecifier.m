//
//  AMSpringboardItemSpecifier.m
//  AMSpringboardView
//
//  Created by Andy Mroczkowski on 3/1/11.
//  Copyright 2011 Andy Mroczkowski. All rights reserved.
//

#import "AMSpringboardItemSpecifier.h"

NSString* const kAMSpringboardBoardItemIdentifier = @"identifier";
NSString* const kAMSpringboardBoardItemTitle = @"title";
NSString* const kAMSpringboardBoardItemImageName = @"image";
NSString* const kAMSpringboardBoardItemIdentifierNull = @"Null";


@interface AMSpringboardItemSpecifier ()
@property (nonatomic, retain) NSMutableDictionary* dict;
@end

@implementation AMSpringboardItemSpecifier

@synthesize dict = _dict;

- (id) initWithDictionary:(NSDictionary*)dict
{
	self = [super init];
	if (self != nil)
	{
        _dict = [dict mutableCopy];
        if( [_dict objectForKey:kAMSpringboardBoardItemIdentifier] == nil )
        {
            [_dict setObject:NSStringFromClass([self class]) forKey:kAMSpringboardBoardItemIdentifier];
        }
	}
	return self;
}


- (id) init
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:NSStringFromClass([self class]) 
             forKey:kAMSpringboardBoardItemIdentifier];
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
    return [[self.dict copy] autorelease];;
}


- (id) objectForKey:(NSString*)key
{
	return [self.dict objectForKey:key];
}


- (void) setObject:(id)object forKey:(NSString*)key
{
	[self.dict setObject:object forKey:key];
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
    [aCoder encodeObject:self.dict forKey:@"dict"];
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


static AMSpringboardNullItem* __sharedNullItem = nil;

@implementation AMSpringboardNullItem

+ (AMSpringboardItemSpecifier*) nullItem
{
    @synchronized(@"AMSpringboardNullItem_Lock")
    {
        if( __sharedNullItem == nil )
        {
            __sharedNullItem = [[AMSpringboardNullItem alloc] init];
            [__sharedNullItem.dict setObject:kAMSpringboardBoardItemIdentifierNull forKey:kAMSpringboardBoardItemIdentifier];
        }
    }
    return __sharedNullItem;
}


- (void) setObject:(id)object forKey:(NSString*)key;
{
    NSAssert(true, @"can't set keys on AMSpringboardNullItem");
}

@end

//
//  AMSpringboardItemSpecifier.h
//  AMSpringboardView
//
//  Created by Andy Mroczkowski on 3/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const kAMSpringboardBoardItemIdentifier; // defaults to name of this class (AMSpringboardItemSpecifier)
extern NSString* const kAMSpringboardBoardItemTitle;
extern NSString* const kAMSpringboardBoardItemImageName;

extern NSString* const kAMSpringboardBoardItemIdentifierNull;


@interface AMSpringboardItemSpecifier : NSObject <NSCoding>
{
	NSMutableDictionary* _dict;
}

- (id) initWithDictionary:(NSDictionary*)dict;
- (id) init;

- (NSDictionary*) dictionaryRepresentation;
- (id) objectForKey:(NSString*)key;
- (void) setObject:(id)object forKey:(NSString*)key;

@end



@interface AMSpringboardItemSpecifier (Convenience)

+ (id) itemSpecifierWithTitle:(NSString*)title imageName:(NSString*)imageName;

@end



@interface AMSpringboardNullItem : AMSpringboardItemSpecifier

+ (AMSpringboardItemSpecifier*) nullItem;

@end
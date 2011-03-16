//
//  AMSpringboardItemSpecifier.h
//  AMSpringboardView
//
//  Created by Andy Mroczkowski on 3/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AMSpringboardItemSpecifier : NSObject <NSCoding>
{
	NSMutableDictionary* _dict;
}

- (id) objectForKey:(NSString*)key;
- (void) setObject:(id)object forKey:(NSString*)key;

@end

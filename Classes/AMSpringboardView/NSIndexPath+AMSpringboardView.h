//
//  NSIndexPath+AMSpringboardView.h
//  AMSpringboardView
//
//  Created by Andy Mroczkowski on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NSIndexPath (AMSpringboardView)

+ (NSIndexPath*) indexPathForPage:(NSUInteger)page row:(NSUInteger)row column:(NSUInteger)column;

- (NSUInteger) springboardPage;
- (NSUInteger) springboardRow;
- (NSUInteger) springboardColumn;

@end

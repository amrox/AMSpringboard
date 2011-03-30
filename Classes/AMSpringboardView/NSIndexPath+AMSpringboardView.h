//
//  NSIndexPath+AMSpringboardView.h
//  AMSpringboardView
//
//  Created by Andy Mroczkowski on 3/6/11.
//  Copyright 2011 Andy Mroczkowski. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAMSpringboardViewAllRows NSUIntegerMax

@interface NSIndexPath (AMSpringboardView)

+ (NSIndexPath*) indexPathForSpringboardPage:(NSUInteger)page column:(NSUInteger)column row:(NSUInteger)row;

+ (NSIndexPath*) indexPathForSpringboardPage:(NSUInteger)page column:(NSUInteger)column;

- (NSUInteger) springboardPage;
- (NSUInteger) springboardColumn;
- (NSUInteger) springboardRow;

@end

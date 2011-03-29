//
//  AMSpringboardController.h
//  AMSpringboardView
//
//  Created by Andy Mroczkowski on 3/25/11.
//  Copyright 2011 MindSnacks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AMSpringboardView.h"

@interface AMSpringboardDataProvider : NSObject <AMSpringboardViewDataSource>
{    
    AMSpringboardView* _springboardView;
    NSArray*           _pages;
    NSInteger          _columnCount;
    NSInteger          _rowCount;
}

@property (nonatomic, retain) AMSpringboardView* springboardView;
@property (nonatomic, retain) NSArray* pages;

@property (nonatomic, assign) NSInteger columnCount;
@property (nonatomic, assign) NSInteger rowCount;

@end


@interface AMSpringboardDataProvider (Subclass)

- (AMSpringboardViewCell*) makeCellWithIdentifier:(NSString*)identifier;
- (void) configureCell:(AMSpringboardViewCell*)cell withItemSpecifier:(AMSpringboardItemSpecifier*)itemSpecifier;

@end
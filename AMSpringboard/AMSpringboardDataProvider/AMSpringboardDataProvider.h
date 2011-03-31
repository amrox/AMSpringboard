//
//  AMSpringboardController.h
//  AMSpringboardView
//
//  Created by Andy Mroczkowski on 3/25/11.
//  Copyright 2011 Andy Mroczkowski. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AMSpringboardView.h"

@interface AMSpringboardDataProvider : NSObject <AMSpringboardViewDataSource>
{    
    AMSpringboardView* _springboardView;
    NSMutableArray*    _pages;
    NSInteger          _columnCount;
    NSInteger          _rowCount;
}

- (id) init;
+ (id) dataProvider;
+ (id) dataProviderFromDictionary:(NSDictionary*)dict error:(NSError**)outError;
+ (id) dataProviderFromPlistWithPath:(NSString*)path error:(NSError**)outError;

@property (nonatomic, retain) AMSpringboardView* springboardView;

@property (nonatomic, retain) NSMutableArray* pages; // A mutable array of mutable arrays. Must call [springboardView reloadData] after changes.
@property (nonatomic, assign) NSInteger columnCount; // Must call [springboardView reloadData] after changes.
@property (nonatomic, assign) NSInteger rowCount;    // Must call [springboardView reloadData] after changes.

- (AMSpringboardItemSpecifier*) itemSpecifierForPosition:(NSIndexPath*)position

@end




@interface AMSpringboardDataProvider (Subclass)

- (AMSpringboardViewCell*) makeCellWithIdentifier:(NSString*)identifier;
- (void) configureCell:(AMSpringboardViewCell*)cell withItemSpecifier:(AMSpringboardItemSpecifier*)itemSpecifier;

@end

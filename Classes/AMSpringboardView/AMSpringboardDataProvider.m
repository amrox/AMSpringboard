//
//  AMSpringboardController.m
//  AMSpringboardView
//
//  Created by Andy Mroczkowski on 3/25/11.
//  Copyright 2011 MindSnacks. All rights reserved.
//

#import "AMSpringboardDataProvider.h"


@implementation AMSpringboardDataProvider

@synthesize springboardView = _springboardView;
@synthesize pages = _pages;
@synthesize columnCount = _columnCount;
@synthesize rowCount = _rowCount;


- (void)dealloc
{
    [_springboardView release];
    [_pages release];
    [super dealloc];
}


- (void) setSpringboardView:(AMSpringboardView *)springboardView
{
    [springboardView retain];
    [_springboardView release];
    _springboardView = springboardView;
    
    _springboardView.dataSource = self;
}


- (AMSpringboardItemSpecifier*) itemSpecifierForPosition:(NSIndexPath*)position
{
    NSArray* items = [self.pages objectAtIndex:[position springboardPage]];
    NSUInteger index = [position springboardColumn]*self.rowCount + [position springboardRow];
    LOG_DEBUG( @"%@: %d", position, index );
    
    if( index >= [items count] )
        return nil;
    
    id item = [items objectAtIndex:index];
    if(item == [NSNull null])
        return nil;
    
    return item;
}




#pragma mark AMSpringboardViewDataSource

- (NSInteger) numberOfPagesInSpringboardView:(AMSpringboardView*)springboardView
{
    return [self.pages count];
}


- (NSInteger) numberOfRowsInSpringboardView:(AMSpringboardView*)springboardView
{
    return self.rowCount;
}


- (NSInteger) numberOfColumnsInSpringboardView:(AMSpringboardView*)springboardView
{
    return self.columnCount;
}


- (AMSpringboardViewCell*) springboardView:(AMSpringboardView*)springboardView cellForPositionWithIndexPath:(NSIndexPath*)indexPath
{
    AMSpringboardViewCell* cell = nil;

    AMSpringboardItemSpecifier* item = [self itemSpecifierForPosition:indexPath];
    if( item != nil )
    {
        NSString* identifier = [item objectForKey:kAMSpringboardBoardItemIdentifier];
        cell = [springboardView dequeueReusableCellWithIdentifier:identifier];
        if( cell == nil )
        {
            cell = [self makeCellWithIdentifier:identifier];
        }
        [self configureCell:cell withItemSpecifier:item];
    }
    return cell;
}


@end




@implementation AMSpringboardDataProvider (Subclass)


- (AMSpringboardViewCell*) makeCellWithIdentifier:(NSString*)identifier
{
    AMSpringboardViewCell* cell = [[[AMSpringboardViewCell alloc] initWithStyle:AMSpringboardViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    return cell;
}


- (void) configureCell:(AMSpringboardViewCell*)cell withItemSpecifier:(AMSpringboardItemSpecifier*)itemSpecifier
{
    cell.image = [UIImage imageNamed:[itemSpecifier objectForKey:kAMSpringboardBoardItemImageName]];
    cell.textLabel.text = [itemSpecifier objectForKey:kAMSpringboardBoardItemTitle];
}

@end

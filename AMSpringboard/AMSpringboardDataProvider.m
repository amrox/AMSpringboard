//
//  AMSpringboardController.m
//  AMSpringboardView
//
//  Created by Andy Mroczkowski on 3/25/11.
//  Copyright 2011 Andy Mroczkowski. All rights reserved.
//

#import "AMSpringboardDataProvider.h"

#import "AMSpringboard.h"

@interface AMSpringboardDataProvider ()

@end


@implementation AMSpringboardDataProvider

@synthesize pages = _pages;
@synthesize columnCount = _columnCount;
@synthesize rowCount = _rowCount;


- (id)init
{
    self = [super init];
    if (self) { }
    return self;
}


+ (id) dataProvider
{
    return [[[self alloc] init] autorelease];
}


+ (id) dataProviderFromDictionary_v1:(NSDictionary*)dict error:(NSError**)outError
{
    AMSpringboardDataProvider* dataProvider = [self dataProvider];
    
    dataProvider.columnCount = [[dict objectForKey:@"columnCount"] integerValue];
    dataProvider.rowCount = [[dict objectForKey:@"rowCount"] integerValue];
    
    NSArray* rawPages = [dict objectForKey:@"pages"];
    
    NSMutableArray* pages = [[[NSMutableArray alloc] initWithCapacity:[rawPages count]] autorelease];
    
    for( int i=0; i<[rawPages count]; i++ )
    {
        NSArray* rawPage = [rawPages objectAtIndex:i];
        NSMutableArray* page = [NSMutableArray arrayWithCapacity:[rawPage count]];
        [pages addObject:page]; 
        
        for( int j=0; j<[rawPage count]; j++ )
        {
            NSDictionary* dict = [rawPage objectAtIndex:j];
            if( [[dict objectForKey:kAMSpringboardBoardItemIdentifier] isEqualToString:kAMSpringboardBoardItemIdentifierNull] )
            {
                [page addObject:[AMSpringboardNullItem nullItem]];
            }
            else
            {
                AMSpringboardItemSpecifier* item = [[AMSpringboardItemSpecifier alloc] initWithDictionary:dict];
                [page addObject:item];
                [item release];
            }
        }
    }
    
    dataProvider.pages = pages;

    return dataProvider;
}


+ (id) dataProviderFromDictionary:(NSDictionary*)dict error:(NSError**)outError
{
    NSString* version = [dict objectForKey:@"version"];
    if( [version isEqualToString:@"1"] )
    {
        return [self dataProviderFromDictionary_v1:dict error:outError];
    }
    
    if( outError != NULL )
    {
        *outError = [NSError errorWithDomain:AMSpringboardErrorDomain
                                        code:AMSpringboardUnkownPlistFormatError
                                    userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                              @"Unknown Plist format", NSLocalizedDescriptionKey, 
                                              nil]];
    }
    
    return nil;
}


+ (id) dataProviderFromPlistWithPath:(NSString*)path error:(NSError**)outError
{
    NSData* data = [NSData dataWithContentsOfFile:path options:0 error:outError];
    if( data == nil )
        return nil;
    
    NSDictionary* plistDict = [NSPropertyListSerialization propertyListWithData:data options:0 format:nil error:outError];
    if( plistDict == nil )
        return nil;
    
    return [self dataProviderFromDictionary:plistDict error:outError];
}


- (void)dealloc
{
    [_pages release];
    [super dealloc];
}


- (AMSpringboardItemSpecifier*) itemSpecifierForPosition:(NSIndexPath*)position
{
    NSArray* items = [self.pages objectAtIndex:[position springboardPage]];
    NSUInteger index = [position springboardColumn] + [position springboardRow]*self.columnCount;
    
    if( index >= [items count] )
        return nil;
    
    AMSpringboardItemSpecifier* item = [items objectAtIndex:index];
    if( item == [AMSpringboardNullItem nullItem] )
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

//
//  AMSpringboardController.m
//  AMSpringboardView
//
//  Created by Andy Mroczkowski on 3/25/11.
//  Copyright 2011 Andy Mroczkowski. All rights reserved.
//

#import "AMSpringboardDataProvider.h"

#import "AMSpringboardViewCell.h"
#import "AMSpringboardItemSpecifier.h"
#import "NSIndexPath+AMSpringboard.h"
#import "AMSpringboardErrors.h"

@implementation AMSpringboardDataProvider

+ (id) dataProvider
{
    return [[[self alloc] init] autorelease];
}


+ (id) dataProviderFromDictionary_v1:(NSDictionary*)dict error:(NSError**)outError
{
    AMSpringboardDataProvider* dataProvider = [self dataProvider];
    
    dataProvider.columnCount = [[dict objectForKey:@"columnCount"] unsignedIntegerValue];
    dataProvider.rowCount = [[dict objectForKey:@"rowCount"] unsignedIntegerValue];
    
    NSArray* rawPages = [dict objectForKey:@"pages"];
    
    NSMutableArray* pages = [[[NSMutableArray alloc] initWithCapacity:[rawPages count]] autorelease];
    
    for( NSUInteger i=0; i<[rawPages count]; i++ )
    {
        NSArray* rawPage = [rawPages objectAtIndex:i];
        NSMutableArray* page = [NSMutableArray arrayWithCapacity:[rawPage count]];
        [pages addObject:page]; 
        
        for( NSUInteger j=0; j<[rawPage count]; j++ )
        {
            NSDictionary* pageDict = [rawPage objectAtIndex:j];
            if( [[pageDict objectForKey:kAMSpringboardBoardItemIdentifier] isEqualToString:kAMSpringboardBoardItemIdentifierNull] )
            {
                [page addObject:[AMSpringboardNullItem nullItem]];
            }
            else
            {
                AMSpringboardItemSpecifier* item = [[AMSpringboardItemSpecifier alloc] initWithDictionary:pageDict];
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

- (NSUInteger) numberOfPagesInSpringboardView:(AMSpringboardView*)springboardView
{
    return [self.pages count];
}


- (NSUInteger) numberOfRowsInSpringboardView:(AMSpringboardView*)springboardView
{
    return self.rowCount;
}


- (NSUInteger) numberOfColumnsInSpringboardView:(AMSpringboardView*)springboardView
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

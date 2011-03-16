//
//  AMSpringboardView.h
//  AMSpringboardView
//
//  Created by Andy Mroczkowski on 2/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AMSpringboardViewCell.h"
#import "NSIndexPath+AMSpringboardView.h"
#import "AMSpringboardItemSpecifier.h"

@protocol AMSpringboardViewDataSource;
@protocol AMSpringboardViewDelegate;


@interface AMSpringboardView : UIView <UIScrollViewDelegate>
{
    id<AMSpringboardViewDelegate>   _delegate;
	id<AMSpringboardViewDataSource> _dataSource;
    
	UIPageControl*                  _pageControl;
	UIScrollView*                   _scrollView;
    UIView*                         _contentView;
    
    NSMutableDictionary*            _cells;
    NSMutableArray*                 _unusedCells;
}


@property (nonatomic, assign) IBOutlet id<AMSpringboardViewDelegate> delegate;
@property (nonatomic, assign) IBOutlet id<AMSpringboardViewDataSource> dataSource;

- (AMSpringboardViewCell*) dequeueReusableCellWithIdentifier:(NSString*)identifier;

- (void) reloadData;

@property (nonatomic, assign) NSInteger currentPage;

//- (NSRange) visibleColumnRange;


//@property (nonatomic, assign) CGFloat rowSpacing;    // defaults to 12
//@property (nonatomic, assign) CGFloat columnSpacing; // defaults to 12

@end


#pragma mark -
@protocol AMSpringboardViewDataSource <NSObject>

@required
- (NSInteger) numberOfPagesInSpringboardView:(AMSpringboardView*)springboardView;
- (NSInteger) numberOfRowsInSpringboardView:(AMSpringboardView*)springboardView;
- (NSInteger) numberOfColumnsInSpringboardView:(AMSpringboardView*)springboardView;

@end


#pragma mark -
@protocol AMSpringboardViewDelegate <NSObject>

@required
- (AMSpringboardViewCell*) springboardView:(AMSpringboardView*)springboardView cellForPositionWithIndexPath:(NSIndexPath*)indexPath;

@end


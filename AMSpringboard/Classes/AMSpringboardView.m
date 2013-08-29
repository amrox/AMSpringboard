//
//  AMSpringboardView.m
//  AMSpringboardView
//
//  Created by Andy Mroczkowski on 2/19/11.
//  Copyright 2011 Andy Mroczkowski. All rights reserved.
//

#import "AMSpringboardView.h"

#import <AMFoundation/AMGeometry.h>

#import "AMSpringboardViewCell.h"
#import "AMSpringboardItemSpecifier.h"
#import "NSIndexPath+AMSpringboard.h"

#define kDefaultColumnPadding (1)
#define VALID_SPRINBOARD_CELL(obj) (obj != nil && (id)obj != [NSNull null])

@class AMSpringboardContentView;

@interface AMSpringboardView ()
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) AMSpringboardContentView *contentView;
@property (nonatomic, retain) NSMutableDictionary *cells;
@property (nonatomic, retain) NSMutableArray *unusedCells;
@property (nonatomic, assign) NSUInteger columnPadding;
@property (nonatomic, retain) NSIndexPath *selectedPosition;
@property (nonatomic, retain) NSIndexPath *positionBeingSelectedAfterDelay;
- (NSUInteger) pageCount;
- (NSUInteger) rowCount;
- (NSUInteger) columnCount;
- (CGRect) activeRect;
- (NSArray*) positionsIntersectingRect:(CGRect)rect;
- (void) addCellToView:(AMSpringboardViewCell*)cell position:(NSIndexPath*)position;
- (void) setFrameForCell:(AMSpringboardViewCell*)cell position:(NSIndexPath*)position;
@end


@interface AMSpringboardContentView : UIView
@property (nonatomic, assign) AMSpringboardView* springboardView;
@end


@implementation AMSpringboardView

- (void) updatePageControlFrame
{
	CGRect pageControlFrame = CGRectZero;
	pageControlFrame.size = [_pageControl sizeForNumberOfPages:(NSInteger)[self pageCount]];
	pageControlFrame.origin.x = (self.bounds.size.width - pageControlFrame.size.width) / 2.f;
	pageControlFrame.origin.y = self.bounds.size.height - pageControlFrame.size.height;
	_pageControl.frame = pageControlFrame;
	_pageControl.numberOfPages = (NSInteger)[self pageCount];
}


// call after updatePageControlFrame
- (void) updateScrollViewFrame
{
    CGRect scrollViewFrame = self.bounds;
    if( !self.pageControl.hidden )
    {
        scrollViewFrame.size.height -= self.pageControl.frame.size.height;
    }
	
	// see: http://stackoverflow.com/questions/2653785/uiscrollview-doesnt-bounce/3231675#3231675
	if( !CGRectEqualToRect(self.scrollView.frame, scrollViewFrame) )
	{
		self.scrollView.frame = scrollViewFrame;
	}
    
    [self.contentView setFrame:CGRectMake(0, 0,
                                          self.scrollView.bounds.size.width * [self pageCount],
                                          self.scrollView.bounds.size.height)];
    
    self.scrollView.contentSize = self.contentView.bounds.size;
}


- (void) _init
{
    _cells = [[NSMutableDictionary alloc] init];
    _unusedCells = [[NSMutableArray alloc] init];
    _columnPadding = kDefaultColumnPadding;
    _cellSelectionDelay = kAMSpringboarViewCellSeletionDelayDefault;
    
	_pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
	_pageControl.hidesForSinglePage = YES;
	_pageControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    _pageControl.backgroundColor = [UIColor clearColor];
	[self addSubview:_pageControl];
	
    //    AMSpringboardScrollView* springboardScroll = [[AMSpringboardScrollView alloc] initWithFrame:CGRectZero];
    //    springboardScroll.springboardView = self;
    UIScrollView* springboardScroll = [[UIScrollView alloc] initWithFrame:CGRectZero];    
    
	_scrollView = springboardScroll;
	_scrollView.delegate = self;
	_scrollView.pagingEnabled = YES;
    _scrollView.bounces = YES;
    _scrollView.alwaysBounceHorizontal = YES;
    _scrollView.delaysContentTouches = NO;
    _scrollView.directionalLockEnabled = YES;
	_scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentOffset = CGPointZero;
    [self addSubview:_scrollView];
    
    AMSpringboardContentView* contentView = [[AMSpringboardContentView alloc] initWithFrame:CGRectZero];
    contentView.springboardView = self;
    [_scrollView addSubview:contentView];
    self.contentView = contentView;
    self.contentView.backgroundColor = [UIColor clearColor];
    [contentView release];
}


- (id) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self != nil)
	{
		[self _init];
	}
	return self;
}


- (id) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self != nil)
	{
		[self _init];
	}
	return self;
}


- (void) dealloc
{
	[_pageControl release];
	[_scrollView release];
    [_contentView release];
    [_unusedCells release];
    [_cells release];
    [_positionBeingSelectedAfterDelay release];
	[super dealloc];
}


- (void) addUnusedCell:(AMSpringboardViewCell*)cell
{
    // -- only save a columns worth of cells
    if( [self.unusedCells count] < [self columnCount] )
    {
        [self.unusedCells addObject:cell];
    }
}


- (NSUInteger) pageCount
{
	return [self.dataSource numberOfPagesInSpringboardView:self];
}


- (NSUInteger) rowCount
{
	return [self.dataSource numberOfRowsInSpringboardView:self];
}


- (NSUInteger) columnCount
{
	return [self.dataSource numberOfColumnsInSpringboardView:self];
}


- (NSInteger) currentPage
{
    BOOL scrollViewFrameIsSet = !CGRectIsEmpty(self.scrollView.frame);
    
    // until the scroll view frame is set, it will always start on page 0.
    return scrollViewFrameIsSet ? lround(self.scrollView.contentOffset.x / self.scrollView.bounds.size.width) : 0;
}

- (void) setCurrentPage:(NSInteger)currentPage
{
    CGPoint offset = CGPointZero;
    offset.x = self.scrollView.bounds.size.width * currentPage;
    self.scrollView.contentOffset = offset;
}


- (CGRect) zoneRectForCellWithPosition:(NSIndexPath*)position
{
    if( !([self columnCount] > 0 && [self rowCount] > 0) )
        return CGRectZero;
    
    CGSize pageSize = self.scrollView.bounds.size;
    CGFloat zoneWidth = (((CGFloat)pageSize.width) / [self columnCount]);
    CGFloat zoneHeight = (((CGFloat)pageSize.height) / [self rowCount]);
    
    CGRect rect = CGRectZero;
    rect.origin.x = [position springboardPage] * pageSize.width;
    rect.origin.x += zoneWidth * [position springboardColumn];
    rect.origin.y =  zoneHeight * [position springboardRow];
    rect.size.width = zoneWidth;
    rect.size.height = zoneHeight;
    
    return CGRectIntegral(rect);
}


- (CGPoint) centerForCellWithPosition:(NSIndexPath*)position
{
    return AMRectCenter([self zoneRectForCellWithPosition:position]);
}


- (AMSpringboardViewCell *)cellForPositionWithIndexPath:(NSIndexPath *)indexPath
{
    AMSpringboardViewCell *cell = [self.cells objectForKey:indexPath];
    if( cell == nil )
    {
        cell = [self.dataSource springboardView:self cellForPositionWithIndexPath:indexPath];
        
        if( cell != nil )
        {
            [self.cells setObject:cell forKey:indexPath];
        }
        else
        {
            [self.cells setObject:[NSNull null] forKey:indexPath];
        }
    }
    return cell;
}

- (NSIndexPath *)indexPathForCell:(AMSpringboardViewCell *)cell
{
    return [[self.cells keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
        if (obj == cell)
        {
            *stop = YES;
            return YES;
        }

        return NO;
    }] anyObject];
}

- (void)updateCellsForPositions:(NSArray *)positions
{
    for (NSIndexPath *position in positions)
    {
        [self updateCellForPosition:position];
    }
}

- (void)updateCellForPosition:(NSIndexPath *)position
{
    id cell = [self cellForPositionWithIndexPath:position];
    if( VALID_SPRINBOARD_CELL(cell) )
    {
        if( [cell superview] == nil )
        {
            [self addCellToView:cell position:position];
        }
        else
        {
            [self setFrameForCell:cell position:position];
        }
        [cell setNeedsDisplay];
    }
}

- (void) layoutSubviews
{
    [self updatePageControlFrame];
    [self updateScrollViewFrame];
    
    NSArray* positions = [self positionsIntersectingRect:[self activeRect]];
    [self updateCellsForPositions:positions];
}


- (void) reloadData
{
    NSUInteger pageCount = [self pageCount];
    
	self.pageControl.numberOfPages = (NSInteger)pageCount;
    
    for( id cell in [self.cells allValues] )
    {
        if( [cell respondsToSelector:@selector(removeFromSuperview)] )
            [cell removeFromSuperview];
    }
    
    [self.cells removeAllObjects];
    [self.unusedCells removeAllObjects];
    
    NSArray* positions = [self positionsIntersectingRect:[self activeRect]];
    [self updateCellsForPositions:positions];
    
    [self setNeedsLayout];
    
    self.scrollView.scrollEnabled = (pageCount > 1);
}

- (void)reloadCellAtPosition:(NSIndexPath *)position
{
    id cell = [self.cells objectForKey:position];

    if (cell != nil)
    {
        if ([cell respondsToSelector:@selector(removeFromSuperview)])
            [cell removeFromSuperview];

        [self.cells removeObjectForKey:position];

        [self updateCellForPosition:position];
    }
}

- (AMSpringboardViewCell*) dequeueReusableCellWithIdentifier:(NSString*)identifier
{
    AMSpringboardViewCell* dequeuedCell = nil;
    
    for( AMSpringboardViewCell* cell in self.unusedCells )
    {
        if( [cell.reuseIdentifier isEqualToString:identifier] )
        {
            dequeuedCell = cell;
            break;
        }
    }
    
    if( dequeuedCell != nil )
    {
        [[dequeuedCell retain] autorelease]; // make sure it doesn't get dealloc'd
        [self.unusedCells removeObject:dequeuedCell];
    }
    
    [dequeuedCell prepareForReuse];
    
    return dequeuedCell;
}

- (void) setFrameForCell:(AMSpringboardViewCell*)cell position:(NSIndexPath*)position
{
    cell.center = [self centerForCellWithPosition:position];
    cell.frame = CGRectIntegral(cell.frame);
}


- (void) addCellToView:(AMSpringboardViewCell*)cell position:(NSIndexPath*)position
{
    //NSLog( @"adding: %@", cell );
    [self setFrameForCell:cell position:position];
    [self.contentView addSubview:cell];
    [cell setNeedsDisplay];
}


- (void) loadCellsForPage:(NSUInteger)page column:(NSUInteger)column
{
    if( page >= [self pageCount] )
        return;
    
    if( column >= [self columnCount] )
        return;
    
    for( NSUInteger row=0; row<[self rowCount]; row++ )
    {
        NSIndexPath* position = [NSIndexPath indexPathForSpringboardPage:page column:column row:row];
        AMSpringboardViewCell* cell = [self cellForPositionWithIndexPath:position];
        if( cell != nil )
        {
            [self addCellToView:cell position:position];
        }
    }
}


- (CGFloat) pageWidth
{
    return self.scrollView.bounds.size.width;
}


- (NSIndexPath *)positionForPoint:(CGPoint)point
{
    if( !([self columnCount] > 0 && [self rowCount] > 0) )
        return nil;
        
    CGSize pageSize = self.scrollView.bounds.size;
    if( pageSize.width == 0 || pageSize.height == 0 )
        return nil;
    
    point = AMPointClampedToRect(point, self.contentView.bounds);
    
    NSUInteger page = (NSUInteger)floor(point.x / pageSize.width);
    
    NSUInteger col = (NSUInteger)floor((point.x - (page * pageSize.width))
                           / (pageSize.width / [self columnCount]));
    col = MIN([self columnCount]-1, col);
    
    NSUInteger row = (NSUInteger)floor(point.y / (pageSize.height / [self rowCount]));
    row = MIN([self rowCount]-1, row);
    
    return [NSIndexPath indexPathForSpringboardPage:page column:col row:row];
}

- (NSIndexPath *)positionForTouch:(UITouch *)touch
{
    CGPoint p = [touch locationInView:self.contentView];
    return [self positionForPoint:p];
}

- (NSArray *)indexPathsForVisibleRows
{
    NSInteger  page = self.currentPage;
    NSUInteger rows = self.rowCount,
               cols = self.columnCount;
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:rows * cols];
    
    NSUInteger row = 0,
               col = 0;
    
    for (row = 0; row < rows; row++)
    {
        for (col = 0; col < cols; col++)
            [result addObject:[NSIndexPath indexPathForSpringboardPage:(NSUInteger)page column:col row:row]];
    }
    
    return [NSArray arrayWithArray:result];
}

- (NSArray *)visibleCells
{
    NSArray *visibleIndexPaths = [self indexPathsForVisibleRows];
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[visibleIndexPaths count]];
    
    for (NSIndexPath *indexPath in visibleIndexPaths)
    {
        AMSpringboardViewCell *cell = [self cellForPositionWithIndexPath:indexPath];
        
        if (VALID_SPRINBOARD_CELL(cell))
            [result addObject:cell];
    }
    
    return [NSArray arrayWithArray:result];
}


- (NSArray*) positionsIntersectingRect:(CGRect)rect
{
    NSMutableArray* positions = [NSMutableArray array];
    
    NSIndexPath* topLeft = [self positionForPoint:
                            CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect))];
    NSIndexPath* botRight = [self positionForPoint:
                             CGPointMake(CGRectGetMaxX(rect)-1, CGRectGetMaxY(rect)-1)];
    
    NSIndexPath* cur = topLeft;
    while(1)
    {
        for( NSUInteger row=[topLeft springboardRow]; row<=[botRight springboardRow]; row++ )
        {
            [positions addObject:[NSIndexPath indexPathForSpringboardPage:[cur springboardPage]
                                                                   column:[cur springboardColumn]
                                                                      row:row]];
        }
        
        if( ([cur springboardPage] == [botRight springboardPage] && 
             [cur springboardColumn] == [botRight springboardColumn]) )
            break;
        
        NSUInteger nextPage = [cur springboardPage];
        NSUInteger nextCol = ([cur springboardColumn]+1) % [self columnCount];
        if( nextCol < [cur springboardColumn] ) nextPage++;
        cur = [NSIndexPath indexPathForSpringboardPage:nextPage
                                                column:nextCol
                                                   row:[topLeft springboardRow]];
        
        if( [cur springboardPage] == [self pageCount] )
            break;
    }
    
    return positions;
}


- (CGRect) activeRect
{
    // make sure there is at least 1 column
    NSUInteger columnCount = [self columnCount];
    if( columnCount <= 0 )
        return CGRectZero;
    
    CGRect rect;    
    CGFloat widthPad = ([self pageWidth] / columnCount) * self.columnPadding;
    rect.origin.x = self.scrollView.contentOffset.x - widthPad;
    rect.origin.y = self.scrollView.contentOffset.y;
    rect.size.width = self.scrollView.bounds.size.width + (widthPad*2); // double to accomodate the left width
    rect.size.height = self.scrollView.bounds.size.height;
    //NSLog(@"activeRect:%@", NSStringFromCGRect(rect));
    return rect;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{    
    CGRect visibleFrame = [self activeRect];
    
    for( NSIndexPath* pos in [[[self.cells allKeys] copy] autorelease] )
    {
        id cell = [self.cells objectForKey:pos];
        if( cell != nil )
        {
            CGRect zone = [self zoneRectForCellWithPosition:pos];
            if( !CGRectIntersectsRect(zone, visibleFrame) )
            {
                //NSLog( @"pruning: %@", pos );
                if( cell != [NSNull null] )
                {
                    [self addUnusedCell:cell];
                    [cell removeFromSuperview];
                }
                [self.cells removeObjectForKey:pos];
            }
        }
    }
    
    //NSLog(@"visible rect: %@", NSStringFromCGRect(visibleFrame));
    NSArray* positions = [self positionsIntersectingRect:visibleFrame];
    [self updateCellsForPositions:positions];
    
    // -- recalculate page control    
    self.pageControl.currentPage = self.currentPage;
}

- (void)deselectCellWithPosition:(NSIndexPath *)position
{
    id cell = [self cellForPositionWithIndexPath:position];
    if( VALID_SPRINBOARD_CELL(cell) )
    {
        [cell setHighlighted:NO];
    }
    self.selectedPosition = nil;
}

- (void)deselectSelectedCell
{
    if (self.selectedPosition)
    {
        [self deselectCellWithPosition:self.selectedPosition];
    }
}

- (void)selectCellWithPosition:(NSIndexPath *)position
{
    [self cancelExistingDelayedSelectionOfCell];

    if (self.selectedPosition != nil)
    {
        [self deselectCellWithPosition:position];
    }

    id cell = [self cellForPositionWithIndexPath:position];
    if (VALID_SPRINBOARD_CELL(cell))
    {
        if (!self.shouldSelectCellsOnTouchDown)
            [cell setHighlighted:YES];
        self.selectedPosition = position;
    }
}

- (void)selectCellWithPosition:(NSIndexPath *)position afterDelay:(NSTimeInterval)delay
{
    self.positionBeingSelectedAfterDelay = position;
    [self performSelector:@selector(selectCellWithPosition:) withObject:position afterDelay:delay];
}

- (void)delayedSelectionOfCellWithPosition:(NSIndexPath *)position
{
    [self selectCellWithPosition:position afterDelay:self.cellSelectionDelay];
}

- (void)cancelDelayedSelectionOfCellWithPosition:(NSIndexPath *)position
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(selectCellWithPosition:) object:position];
}

- (void)cancelExistingDelayedSelectionOfCell
{
    if (self.positionBeingSelectedAfterDelay != nil)
    {
        [self cancelDelayedSelectionOfCellWithPosition:self.positionBeingSelectedAfterDelay];
        self.positionBeingSelectedAfterDelay = nil;
    }
}

- (void)informDelegateOfSelectedCellPosition
{
    if (self.selectedPosition != nil)
    {
        [self.delegate springboardView:self
             didSelectCellWithPosition:self.selectedPosition];
        [self performSelector:@selector(deselectSelectedCell) withObject:nil afterDelay:0.0];
    }
}

- (BOOL)isValidPosition:(NSIndexPath *)position
{
    if( [position springboardPage] >= [self pageCount] ) // unsigned so don't have to check for negative
        return NO;
    
    if( [position springboardColumn] >= [self columnCount] ) // unsigned so don't have to check for negative
        return NO;
    
    if( [position springboardRow] >= [self rowCount] ) // unsigned so don't have to check for negative
        return NO;

    return YES;
}

@end


// -----------------------------------------------------------------------------------
#pragma mark -
@implementation AMSpringboardContentView

- (void)notifyTouch:(UITouch *)touch
{
    [self.springboardView informDelegateOfSelectedCellPosition];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSIndexPath* position = [self.springboardView positionForTouch:[touches anyObject]];

    if (self.springboardView.shouldSelectCellsOnTouchDown)
    {
        [self.springboardView selectCellWithPosition:position];
        [self.springboardView informDelegateOfSelectedCellPosition];
    }
    else
    {
        [self.springboardView delayedSelectionOfCellWithPosition:position];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.springboardView cancelExistingDelayedSelectionOfCell];

    [self.springboardView deselectSelectedCell];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.springboardView cancelExistingDelayedSelectionOfCell];
    
    [self.springboardView informDelegateOfSelectedCellPosition];
}

@end

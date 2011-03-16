//
//  AMSpringboardView.m
//  AMSpringboardView
//
//  Created by Andy Mroczkowski on 2/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AMSpringboardView.h"

#import "AMExtensions.h"
#import "AMGeometry.h"

@interface AMSpringboardView ()
@property (nonatomic, retain) UIScrollView* scrollView;
@property (nonatomic, retain) UIPageControl* pageControl;
@property (nonatomic, retain) UIView* contentView;
@property (nonatomic, retain) NSMutableDictionary* cells;
@property (nonatomic, retain) NSMutableArray* unusedCells;
- (NSInteger) pageCount;
- (NSInteger) rowCount;
- (NSInteger) columnCount;
@end


@implementation AMSpringboardView

@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize contentView = _contentView;
//@synthesize rowSpacing = _rowSpacing;
//@synthesize columnSpacing = _columnSpacing;
@synthesize cells = _cells;
@synthesize unusedCells = _unusedCells;


- (void) updatePageControlFrame
{
	CGRect pageControlFrame = CGRectZero;
	pageControlFrame.size = [_pageControl sizeForNumberOfPages:[self pageCount]];
	pageControlFrame.origin.x = (self.bounds.size.width - pageControlFrame.size.width) / 2.;
	pageControlFrame.origin.y = self.bounds.size.height - pageControlFrame.size.height;
	_pageControl.frame = pageControlFrame;
	_pageControl.numberOfPages = [self pageCount];
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
    
    //    UIView* contentView = [[self.scrollView subviews] am_firstObject];
    [self.contentView setFrame:CGRectMake(self.scrollView.bounds.origin.x,
                                          self.scrollView.bounds.origin.y,
                                          self.scrollView.bounds.size.width * [self pageCount],
                                          self.scrollView.bounds.size.height)];
    
    self.scrollView.contentSize = self.contentView.bounds.size;
}


- (void) _init
{
//    _rowSpacing = 12;
//    _columnSpacing = 12;
    
    _cells = [[NSMutableDictionary alloc] init];
    _unusedCells = [[NSMutableArray alloc] init];
    
	_pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
	_pageControl.hidesForSinglePage = YES;
	_pageControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    _pageControl.backgroundColor = [UIColor clearColor];
	[self addSubview:_pageControl];
	
	_scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
	_scrollView.delegate = self;
	_scrollView.pagingEnabled = YES;
    _scrollView.bounces = YES;
    _scrollView.directionalLockEnabled = YES;
	_scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentOffset = CGPointZero;
    [self addSubview:_scrollView];
    
    UIView* contentView = [[UIView alloc] initWithFrame:CGRectZero];
    [_scrollView addSubview:contentView];
    self.contentView = contentView;
    self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [contentView release];
    
    //contentView.backgroundColor = [UIColor clearColor];
    contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
	
    [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.0];
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


//- (void)layoutSubviews
//{
//	[super layoutSubviews];
//	
//    // !!!: things break if I updateScrollViewFrame in this method
//    
////    [self updatePageControlFrame];
////    [self updateScrollViewFrame];
//	
//	CGRect visibleFrame;
//	visibleFrame.origin = self.scrollView.contentOffset;
//	visibleFrame.size = self.scrollView.contentSize;
//
//	// -- remove any unseen cells
//
//	for( AMSpringboardViewCell* cell in [self.cells allValues] )
//	{
//		if( !CGRectIntersectsRect(cell.frame, visibleFrame) )
//		{
//			[self addUnusedCell:cell];
//			[cell removeFromSuperview];
//		}
//	}
//    
//	// -- request new cells
//	
//	// (if the right edge is past the center 
//	
//}


- (NSInteger) pageCount
{
	return [self.dataSource numberOfPagesInSpringboardView:self];
}


- (NSInteger) rowCount
{
	return [self.dataSource numberOfRowsInSpringboardView:self];
}


- (NSInteger) columnCount
{
	return [self.dataSource numberOfColumnsInSpringboardView:self];
}


- (NSInteger) currentPage
{
    return lround(self.scrollView.contentOffset.x / self.scrollView.bounds.size.width);
}


- (void) setCurrentPage:(NSInteger)currentPage
{
    [self willChangeValueForKey:@"currentPage"];
    CGPoint offset = CGPointZero;
    offset.x = self.scrollView.bounds.size.width * currentPage;
    self.scrollView.contentOffset = offset;
    [self didChangeValueForKey:@"currentPage"];
}


- (CGRect) zoneRectForCellWithPosition:(NSIndexPath*)position
{
    CGSize pageSize = self.scrollView.bounds.size;
    CGFloat zoneWidth = (((CGFloat)pageSize.width) / [self columnCount]);
    CGFloat zoneHeight = (((CGFloat)pageSize.height) / [self rowCount]);

    CGRect rect;
    rect.origin.x += [position springboardPage] * pageSize.width;
    
    rect.origin.x = [position springboardPage] * pageSize.width;
    rect.origin.x += zoneWidth * [position springboardColumn];
    rect.origin.y =  zoneHeight * [position springboardRow];
    rect.size.width = zoneWidth;
    rect.size.height = zoneHeight;

    return rect;
}


- (CGPoint) centerForCellWithPosition:(NSIndexPath*)position
{
    return AMRectCenter([self zoneRectForCellWithPosition:position]);
}


- (AMSpringboardViewCell*) getCellForPosition:(NSIndexPath*)position
{
    AMSpringboardViewCell* cell = nil;
    cell = [self.cells objectForKey:position];
    if( cell == nil )
    {
        cell = [self.delegate springboardView:self cellForPositionWithIndexPath:position];
        if( cell != nil )
        {
            [self.cells setObject:cell forKey:position];
        }
    }
    return cell;
}


- (void) reloadData
{
	self.pageControl.numberOfPages = [self pageCount];
    
//    [self setNeedsLayout];
//    [self layoutIfNeeded];
    
//    [self layoutSubviews];
    
    [self updatePageControlFrame];
    [self updateScrollViewFrame];
	
    // remove all existing cells
    [[self.cells allValues] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSUInteger page = self.currentPage;
    
    for( NSUInteger row=0; row<[self rowCount]; row++ )
    {
        for( NSUInteger col=0; col<[self columnCount]; col++ )
        {
            NSIndexPath* position = [NSIndexPath indexPathForPage:page row:row column:col];
            AMSpringboardViewCell* cell = [self getCellForPosition:position];
            CGPoint center = [self centerForCellWithPosition:position];
            CGRect frame = AMRectMakeWithCenterAndSize( center, cell.bounds.size );
            cell.frame = frame;
            [self.contentView addSubview:cell];
        }
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
        [self.unusedCells removeObject:dequeuedCell];
        //LOG_DEBUG( @"dequeued!" );
    }
    
    return dequeuedCell;
}


- (CGRect) getScrollViewVisibleFrame
{
    // TODO: port to a category or utility?
    return CGRectMake(self.scrollView.contentOffset.x,
                      self.scrollView.contentOffset.y,
                      self.scrollView.contentSize.width,
                      self.scrollView.contentSize.height);
}


- (void) addCellToView:(AMSpringboardViewCell*)cell position:(NSIndexPath*)position
{
    CGPoint center = [self centerForCellWithPosition:position];
    CGRect frame = AMRectMakeWithCenterAndSize( center, cell.bounds.size );
    cell.frame = frame;
    [self.contentView addSubview:cell];
}


- (void) loadCellsForPage:(NSInteger)page column:(NSInteger)column
{
    if( page < 0 || page >= [self pageCount] )
        return;

    if( column < 0 || column >= [self columnCount] )
        return;

    for( NSInteger row=0; row<[self rowCount]; row++ )
    {
        NSIndexPath* position = [NSIndexPath indexPathForPage:page row:row column:column];
        AMSpringboardViewCell* cell = [self getCellForPosition:position];
        [self addCellToView:cell position:position];
    }
}


- (CGFloat) pageWidth
{
    return self.scrollView.bounds.size.width;
}


- (NSInteger) pageForOffset:(CGFloat)offset
{
    CGSize pageSize = self.scrollView.bounds.size;
    return floor(offset / pageSize.width);
}


- (NSInteger) columnForOffset:(CGFloat)offset
{
    CGSize pageSize = self.scrollView.bounds.size;
    NSInteger page = [self pageForOffset:offset];
    return floor((offset - (page * pageSize.width))
                 / (pageSize.width / [self columnCount]));  
}


#pragma UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger minPage = [self pageForOffset:self.scrollView.contentOffset.x];
    NSInteger minCol =  [self columnForOffset:self.scrollView.contentOffset.x];
    //LOG_DEBUG( @"minPage: %d    minColumn: %d", minPage, minCol );
    
    // -- The -1 prevents it from going to the next column/page when the view is "at rest"
    NSInteger maxPage = [self pageForOffset:self.scrollView.contentOffset.x + [self pageWidth]-1];
    NSInteger maxCol = [self columnForOffset:self.scrollView.contentOffset.x + [self pageWidth]-1];
    //LOG_DEBUG( @"maxPage: %d    maxColumn: %d", maxPage, maxCol );

    [self loadCellsForPage:minPage column:minCol];        
    [self loadCellsForPage:maxPage column:maxCol];
    
    CGRect visibleFrame;
	visibleFrame.origin = self.scrollView.contentOffset;
	visibleFrame.size = self.scrollView.contentSize;
    
    // -- remove any unseen cells (asynchronously)
    dispatch_async(dispatch_get_main_queue(), ^{
        
        for( AMSpringboardViewCell* cell in [self.cells allValues] )
        {
            if( !CGRectIntersectsRect(cell.frame, visibleFrame) )
            {
                [self addUnusedCell:cell];
                [cell removeFromSuperview];
            }
        }    
    });
    
    // -- recalculate page control    
    self.pageControl.currentPage = self.currentPage;
}

@end
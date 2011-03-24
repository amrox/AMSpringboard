//
//  AMSpringboardView.m
//  AMSpringboardView
//
//  Created by Andy Mroczkowski on 2/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AMSpringboardView.h"

#import "AMGeometry.h"
#import "NSIndexPath+AMSpringboardView.h"

#define kDefaultColumnPadding (2)
static const NSString*  kvo_TapGestureState = @"kvo_TapGestureState";

@interface AMSpringboardView ()
@property (nonatomic, retain) UIScrollView* scrollView;
@property (nonatomic, retain) UIPageControl* pageControl;
@property (nonatomic, retain) UIView* contentView;
@property (nonatomic, retain) NSMutableDictionary* cells;
@property (nonatomic, retain) NSMutableArray* unusedCells;
@property (nonatomic, assign) NSUInteger columnPadding;
- (NSInteger) pageCount;
- (NSInteger) rowCount;
- (NSInteger) columnCount;
@end


@interface AMSprinboardScrollView : UIScrollView
@property (nonatomic, assign) AMSpringboardView* springboardView;
@end


@implementation AMSpringboardView

@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize contentView = _contentView;
@synthesize cells = _cells;
@synthesize unusedCells = _unusedCells;
@synthesize columnPadding = _columnPadding;


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
    
    [self.contentView setFrame:CGRectMake(self.scrollView.bounds.origin.x,
                                          self.scrollView.bounds.origin.y,
                                          self.scrollView.bounds.size.width * [self pageCount],
                                          self.scrollView.bounds.size.height)];
    
    self.scrollView.contentSize = self.contentView.bounds.size;
}


- (void) _init
{
    _cells = [[NSMutableDictionary alloc] init];
    _unusedCells = [[NSMutableArray alloc] init];
    _columnPadding = kDefaultColumnPadding;
    
	_pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
	_pageControl.hidesForSinglePage = YES;
	_pageControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    _pageControl.backgroundColor = [UIColor clearColor];
	[self addSubview:_pageControl];
	
    AMSprinboardScrollView* springboardScroll = [[AMSprinboardScrollView alloc] initWithFrame:CGRectZero];
    springboardScroll.springboardView = self;
	_scrollView = springboardScroll;
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
    //self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    [contentView release];
    
    UIGestureRecognizer* tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentTap:)];
    tapGest.delegate = self;
//    [contentView addGestureRecognizer:tapGest];
    [tapGest release];
    
//    [tapGest addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:&kvo_TapGestureState];

    [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.0];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    LOG_TRACE();
    
    CGPoint point = [gestureRecognizer locationInView:self.contentView];    
    NSIndexPath* pos = [self positionForPoint:point];
    id cell = [self.cells objectForKey:pos];
    if( cell != nil && cell != [NSNull null] )
    {
        [cell setHighlighted:YES];
    }

    return YES;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    LOG_TRACE();
    return YES;
}


- (void) contentTap:(UIGestureRecognizer*)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:self.contentView];    
    NSIndexPath* pos = [self positionForPoint:point];

    LOG_DEBUG( @"tapped (p:%d r:%d c:%d)",
              [pos springboardPage], [pos springboardRow], [pos springboardColumn] );
    
    id cell = [self.cells objectForKey:pos];
    if( cell != nil && cell != [NSNull null] )
    {
        [self.delegate springboardView:self didSelectCellWithPosition:pos];
        [cell setHighlighted:NO];
    }
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
    
//    LOG_DEBUG( @"unused: %@", self.unusedCells );
}


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
    AMSpringboardViewCell* cell = [self.cells objectForKey:position];
    if( cell == nil )
    {
        //LOG_DEBUG(@"getting: %@", position);
        cell = [self.delegate springboardView:self cellForPositionWithIndexPath:position];
        if( cell != nil )
        {
            [self.cells setObject:cell forKey:position];
        }
        else
        {
            [self.cells setObject:[NSNull null] forKey:position];
        }
    }
    return cell;
}


- (void) reloadData
{
	self.pageControl.numberOfPages = [self pageCount];
        
    [self updatePageControlFrame];
    [self updateScrollViewFrame];
	
    // remove all existing cells
    [[self.cells allValues] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.cells removeAllObjects];
    [self.unusedCells removeAllObjects];
    
    NSUInteger page = self.currentPage;
    
    for( NSUInteger row=0; row<[self rowCount]; row++ )
    {
        for( NSUInteger col=0; col<[self columnCount]; col++ )
        {
            NSIndexPath* position = [NSIndexPath indexPathForSpringboardPage:page column:col row:row];
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
        [[dequeuedCell retain] autorelease]; // make sure it doesn't get dealloc'd
        [self.unusedCells removeObject:dequeuedCell];
        //LOG_DEBUG( @"dequeued!" );
    }
    
    return dequeuedCell;
}


- (void) addCellToView:(AMSpringboardViewCell*)cell position:(NSIndexPath*)position
{
    //LOG_DEBUG( @"adding: %@", cell );
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
        NSIndexPath* position = [NSIndexPath indexPathForSpringboardPage:page column:column row:row];
        AMSpringboardViewCell* cell = [self getCellForPosition:position];
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


- (NSIndexPath*) positionForPoint:(CGPoint)point
{
    point = AMPointClampedToRect(point, self.contentView.bounds);
    
    CGSize pageSize = self.scrollView.bounds.size;
    
    NSInteger page =  floor(point.x / pageSize.width);
    
    NSInteger col =  floor((point.x - (page * pageSize.width))
                           / (pageSize.width / [self columnCount]));
    col = MIN([self columnCount]-1, col);
 
    NSInteger row = floor(point.y / (pageSize.height / [self rowCount]));
    row = MIN([self rowCount]-1, row);
    
    return [NSIndexPath indexPathForSpringboardPage:page column:col row:row];
}


- (NSArray*) positionsIntersectingRect:(CGRect)rect
{
    NSMutableArray* positions = [NSMutableArray array];
    
    NSIndexPath* topLeft = [self positionForPoint:
                            CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect))];
    NSIndexPath* botRight = [self positionForPoint:
                             CGPointMake(CGRectGetMaxX(rect)-1, CGRectGetMaxY(rect)-1)];
    
    //LOG_DEBUG(@"top left: %@", topLeft );
    //LOG_DEBUG(@"bot right: %@", botRight );
    
    NSIndexPath* cur = topLeft;
    while(1)
    {
        for( NSInteger row=[topLeft springboardRow]; row<=[botRight springboardRow]; row++ )
        {
            [positions addObject:[NSIndexPath indexPathForSpringboardPage:[cur springboardPage]
                                                                   column:[cur springboardColumn]
                                                                      row:row]];
        }
        
        if( ([cur springboardPage] == [botRight springboardPage] && 
             [cur springboardColumn] == [botRight springboardColumn]) )
            break;
                
        NSInteger nextPage = [cur springboardPage];
        NSInteger nextCol = ([cur springboardColumn]+1) % [self rowCount];
        if( nextCol < [cur springboardColumn] ) nextPage++;
        cur = [NSIndexPath indexPathForSpringboardPage:nextPage
                                                column:nextCol
                                                   row:[topLeft springboardRow]];
        
        if( [cur springboardPage] == [self pageCount] )
            break;
    }
    
    return positions;
}


#pragma UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{    
    CGRect visibleFrame;    
    CGFloat widthPad = [self pageWidth] / [self columnCount] * self.columnPadding;
    visibleFrame.origin.x = self.scrollView.contentOffset.x - widthPad;
    visibleFrame.origin.y = self.scrollView.contentOffset.y;
    visibleFrame.size.width = self.scrollView.bounds.size.width + (widthPad*2); // double to accomodate the left width
    visibleFrame.size.height = self.scrollView.bounds.size.height;
    
    for( NSIndexPath* pos in [[[self.cells allKeys] copy] autorelease] )
    {
        id cell = [self.cells objectForKey:pos];
        if( cell != nil )
        {
            CGRect zone = [self zoneRectForCellWithPosition:pos];
            if( !CGRectIntersectsRect(zone, visibleFrame) )
            {
                //LOG_DEBUG( @"pruning: %@", pos );
                if( cell != [NSNull null] )
                {
                    [self addUnusedCell:cell];
                    [cell removeFromSuperview];
                }
                [self.cells removeObjectForKey:pos];
             }
        }
    }
    
    //LOG_DEBUG(@"visible rect: %@", NSStringFromCGRect(visibleFrame));
    NSArray* positions = [self positionsIntersectingRect:visibleFrame];
    //LOG_DEBUG( @"positions: %@\n", positions );
    for( NSIndexPath* position in positions )
    {
        id cell = [self getCellForPosition:position];
        if( cell != nil && cell != [NSNull null] )
        {
            //LOG_DEBUG( @"adding: %@", position );
            [self addCellToView:cell position:position];
        }
    }
    
    // -- recalculate page control    
    self.pageControl.currentPage = self.currentPage;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == &kvo_TapGestureState) {
        
        LOG_TRACE();
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end


@implementation AMSprinboardScrollView

@synthesize springboardView = _springboardView;

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    LOG_TRACE();
    return YES;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    LOG_TRACE();
    return [super touchesShouldCancelInContentView:view];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    LOG_TRACE();
//    LOG_DEBUG(@"touches: %@", touches);
//    LOG_DEBUG(@"event: %@", event);
    
    UITouch* touch = [touches anyObject]; // TODO: !!!:
    CGPoint p = [touch locationInView:self.springboardView.contentView];
    
//    LOG_DEBUG(@"p:%@", NSStringFromCGPoint(p));
    
    NSIndexPath* position = [self.springboardView positionForPoint:p];
    AMSpringboardViewCell* cell = [self.springboardView getCellForPosition:position];
    cell.highlighted = YES;
}


- (void)touchesEnded:(NSSet *)touches withEvents:(UIEvent *)event
{
    LOG_TRACE();
    
    UITouch* touch = [touches anyObject]; // TODO: !!!:
    CGPoint p = [touch locationInView:self.springboardView.contentView];
    
    //    LOG_DEBUG(@"p:%@", NSStringFromCGPoint(p));
    
    NSIndexPath* position = [self.springboardView positionForPoint:p];
    AMSpringboardViewCell* cell = [self.springboardView getCellForPosition:position];
    cell.highlighted = NO;
}

@end
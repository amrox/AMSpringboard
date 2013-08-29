//
//  AMSpringboardView.h
//  AMSpringboardView
//
//  Created by Andy Mroczkowski on 2/19/11.
//  Copyright 2011 Andy Mroczkowski. All rights reserved.
//

#import <UIKit/UIKit.h>


@class AMSpringboardViewCell;

@protocol AMSpringboardViewDataSource;
@protocol AMSpringboardViewDelegate;

#define kAMSpringboarViewCellSelectionDelayNone    (0.0f)
#define kAMSpringboarViewCellSelectionDelayDefault (0.1f)

@interface AMSpringboardView : UIView <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, assign) IBOutlet id<AMSpringboardViewDelegate> delegate;
@property (nonatomic, assign) IBOutlet id<AMSpringboardViewDataSource> dataSource;

- (AMSpringboardViewCell *)dequeueReusableCellWithIdentifier:(NSString*)identifier;

- (void)reloadData;
- (void)reloadCellAtPosition:(NSIndexPath *)position;

@property (nonatomic, assign) NSInteger currentPage;

- (NSArray *)indexPathsForVisibleRows;
- (NSArray *)visibleCells;
- (AMSpringboardViewCell *)cellForPositionWithIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForCell:(AMSpringboardViewCell *)cell; /* Returns an index path representing of a given cell. */

- (NSIndexPath *)positionForPoint:(CGPoint)point;

/**
 * @default NO
 * @discussion if YES, it will notify the delegate after
 * a touch down event, as opposed to touch up.
 */
@property (nonatomic, assign) BOOL shouldSelectCellsOnTouchDown;

@property (nonatomic, assign) NSTimeInterval cellSelectionDelay;

@end


#pragma mark -
@protocol AMSpringboardViewDataSource <NSObject>

@required
- (NSUInteger)numberOfPagesInSpringboardView:(AMSpringboardView *)springboardView;
- (NSUInteger)numberOfRowsInSpringboardView:(AMSpringboardView *)springboardView;
- (NSUInteger)numberOfColumnsInSpringboardView:(AMSpringboardView *)springboardView;
- (AMSpringboardViewCell *)springboardView:(AMSpringboardView *)springboardView cellForPositionWithIndexPath:(NSIndexPath *)indexPath;

@end


#pragma mark -
@protocol AMSpringboardViewDelegate <NSObject>

@required
- (void) springboardView:(AMSpringboardView*)springboardView didSelectCellWithPosition:(NSIndexPath*)position;

@end


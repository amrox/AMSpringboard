//
//  AMSpringboardViewCell.m
//  AMSpringboardView
//
//  Created by Andy Mroczkowski on 2/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AMSpringboardViewCell.h"

#import <QuartzCore/QuartzCore.h>

#define DEFAULT_WIDTH 80
#define DEFAULT_HEIGHT 80

#define LABEL_HEIGHT 21



@interface AMSpringboardViewCell ()

@property (nonatomic,readwrite,copy) NSString* reuseIdentifier;
@property (nonatomic,readwrite,retain) UIImageView* imageView;
@property (nonatomic,readwrite,retain) UILabel* textLabel; // default is nil.  label will be created if necessary.

@end


#pragma mark -
@implementation AMSpringboardViewCell

@synthesize reuseIdentifier = _reuseIdentifier;
@synthesize imageView = _imageView;
@synthesize textLabel = _textLabel;

//- (void) _init
//{
//	
//}
//
//- (id) initWithFrame:(CGRect)frame
//{
//	self = [super initWithFrame:frame];
//	if (self != nil)
//	{
//		[self _init];
//	}
//	return self;
//}
//
//
//- (id) initWithCoder:(NSCoder *)aDecoder
//{
//	self = [super initWithCoder:aDecoder];
//	if (self != nil) 
//	{
//		[self _init];
//	}
//	return self;
//}


- (void) setupViewForStyle:(AMSpringboardViewCellStyle)style
{
	if( style == AMSpringboardViewCellStyleDefault )
	{
		[self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-LABEL_HEIGHT,
                                                                    self.bounds.size.width, LABEL_HEIGHT)] release];
        self.textLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:self.textLabel];
	}
    
    self.layer.cornerRadius = 8;
}


- (id) initWithStyle:(AMSpringboardViewCellStyle)style reuseIdentifier:(NSString*)identifier
{
	self = [self initWithFrame:CGRectMake(0, 0, DEFAULT_WIDTH, DEFAULT_HEIGHT)];
	if (self != nil)
	{
        _reuseIdentifier = [identifier copy];
        [self setupViewForStyle:style];
	}
	return self;
}


- (void) dealloc
{
    [_reuseIdentifier release];
	[_imageView release];
	[_textLabel release];
	[super dealloc];
}


// default implementation does nothing
- (void) prepareForReuse {}




@end

//
//  AMSpringboardViewCell.m
//  AMSpringboardView
//
//  Created by Andy Mroczkowski on 2/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AMSpringboardViewCell.h"

#import <QuartzCore/QuartzCore.h>
//#import <Quartz/Quartz.h>

#import "AMGeometry.h"
#import "AMAdjustingImageView.h"

#define DEFAULT_WIDTH 80
#define DEFAULT_HEIGHT 80

#define LABEL_HEIGHT 21



@interface AMSpringboardViewCell ()

@property (nonatomic,readwrite,copy) NSString* reuseIdentifier;
//@property (nonatomic,readwrite,retain) UIImageView* imageView;
@property (nonatomic,readwrite,retain) UILabel* textLabel; // default is nil.  label will be created if necessary.

@end


#pragma mark -
@implementation AMSpringboardViewCell

@synthesize reuseIdentifier = _reuseIdentifier;
//@synthesize imageView = _imageView;
@synthesize image = _image;
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
        self.opaque = NO;
        
		[self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-LABEL_HEIGHT,
                                                                    self.bounds.size.width, LABEL_HEIGHT)] release];
        self.textLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:self.textLabel];

//        CGRect imageViewFrame = self.bounds;
//        imageViewFrame.size.height -= LABEL_HEIGHT;
//        imageViewFrame = AMRectInsetWithAspectRatio(imageViewFrame, 1);
//        [self.imageView = [[AMAdjustingImageView alloc] initWithFrame:imageViewFrame] release];
//        [self addSubview:self.imageView];
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
//	[_imageView release];
    [_image release];
	[_textLabel release];
	[super dealloc];
}


- (void) drawRect:(CGRect)rect
{
    CGRect imageFrame = self.bounds;
    imageFrame.size.height -= LABEL_HEIGHT;
    imageFrame = AMRectInsetWithAspectRatio(imageFrame, 1);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    
    [[UIColor redColor] set];
    [[UIBezierPath bezierPathWithRect:imageFrame] stroke];

    CGContextSaveGState(context);
//    CGContextScaleCTM(context, 1.0, -1.0);
    
//    CGRectApplyAffineTransform(imageFrame, CGAffineTransformMakeScale(1.0, -1.0));
  

//    CGContextClipToMask(context, imageFrame, self.image.CGImage);
//    CGContextClipToRect(context, rect);

    CGContextDrawImage(context, imageFrame, self.image.CGImage);
    CGContextRestoreGState(context);
    
    UIColor* color = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
    CGContextSetFillColor(context, CGColorGetComponents(color.CGColor));      
    CGContextFillRect (context, rect);
    
    CGContextRestoreGState(context);
}


// default implementation does nothing
- (void) prepareForReuse {}




@end

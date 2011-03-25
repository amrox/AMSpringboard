//
//  AMSpringboardViewCell.m
//  AMSpringboardView
//
//  Created by Andy Mroczkowski on 2/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AMSpringboardViewCell.h"

#import <QuartzCore/QuartzCore.h>

#import "AMGeometry.h"
#import "AMAdjustingImageView.h"

#define DEFAULT_WIDTH 80
#define DEFAULT_HEIGHT 80

#define LABEL_HEIGHT 21


@interface AMSpringboardViewCell ()

@property (nonatomic,readwrite,copy) NSString* reuseIdentifier;
@property (nonatomic,readwrite,retain) UILabel* textLabel; // default is nil.  label will be created if necessary.
@property (nonatomic, retain) UIButton* button;
           
@end


#pragma mark -
@implementation AMSpringboardViewCell

@synthesize reuseIdentifier = _reuseIdentifier;
@synthesize image = _image;
@synthesize textLabel = _textLabel;
@synthesize button = _button;
@synthesize highlighted = _highlighted;


- (void) setupViewForStyle:(AMSpringboardViewCellStyle)style
{
	if( style == AMSpringboardViewCellStyleDefault )
	{
        self.opaque = NO;
        
		[self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-LABEL_HEIGHT,
                                                                    self.bounds.size.width, LABEL_HEIGHT)] release];
        self.textLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:self.textLabel];
        
//        CGRect buttonFrame = self.bounds;
//        buttonFrame.size.height -= LABEL_HEIGHT;
//        buttonFrame = AMRectInsetWithAspectRatio(buttonFrame, 1);
//        
//        [self.button = [[UIButton alloc] initWithFrame:buttonFrame] release];
//        [self.button setImage:self.image forState:UIControlStateNormal];
//        [self addSubview:self.button];
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
    [_image release];
	[_textLabel release];
    [_button release];
	[super dealloc];
}


- (void) drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGRect imageFrame = self.bounds;
    imageFrame.size.height -= LABEL_HEIGHT;
    imageFrame = AMRectInsetWithAspectRatio(imageFrame, 1);
    
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0.0, -imageFrame.size.height);
    
    CGContextClipToRect(context, rect);
    CGContextClipToMask(context, imageFrame, self.image.CGImage);
    
    CGContextDrawImage(context, imageFrame, self.image.CGImage);
    
    if( self.highlighted )
    {
        UIColor* color = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
        CGContextSetFillColor(context, CGColorGetComponents(color.CGColor));      
        CGContextFillRect (context, rect);
    }
    
    CGContextRestoreGState(context);
}


- (void) setHighlighted:(BOOL)highlighted
{
    if( highlighted != _highlighted )
    {
        _highlighted = highlighted;
        [self setNeedsDisplay];
    }
}


- (void) setImage:(UIImage *)image
{
    if( image != _image )
    {
        [image retain];
        [_image release];
        _image = image;
     
        [self.button setImage:image forState:UIControlStateNormal];
        
    }
}

// default implementation does nothing
- (void) prepareForReuse {}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
////    LOG_TRACE();
////    //    LOG_DEBUG(@"touches: %@", touches);
////    //    LOG_DEBUG(@"event: %@", event);
////    
////    UITouch* touch = [touches anyObject]; // TODO: !!!:
////    CGPoint p = [touch locationInView:self.contentView];
////    
////    //    LOG_DEBUG(@"p:%@", NSStringFromCGPoint(p));
////    
////    NSIndexPath* position = [self positionForPoint:p];
////    id cell = [self getCellForPosition:position];
////    if( cell != nil && cell != [NSNull null] )
////        [cell setHighlighted:YES];
//    
//    [self becomeFirstResponder];
//    self.highlighted = YES;
//}
//
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    LOG_TRACE();
//    self.highlighted = NO;
//}
//
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    LOG_TRACE();
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvents:(UIEvent *)event
//{
//    LOG_TRACE();
//    
////    UITouch* touch = [touches anyObject]; // TODO: !!!:
////    CGPoint p = [touch locationInView:self.contentView];
////    
////    //    LOG_DEBUG(@"p:%@", NSStringFromCGPoint(p));
////    
////    NSIndexPath* position = [self positionForPoint:p];
////    AMSpringboardViewCell* cell = [self getCellForPosition:position];
////    cell.highlighted = NO;
//    
//    self.highlighted = NO;
//}

@end

//
//  AMSpringboardViewCell.m
//  AMSpringboardView
//
//  Created by Andy Mroczkowski on 2/19/11.
//  Copyright 2011 Andy Mroczkowski. All rights reserved.
//

#import "AMSpringboardViewCell.h"

#import <QuartzCore/QuartzCore.h>

#import "AMGeometry.h"

#define DEFAULT_WIDTH 80
#define DEFAULT_HEIGHT 80

#define LABEL_HEIGHT 21


@interface AMSpringboardViewCell ()

@property (nonatomic,readwrite,copy) NSString* reuseIdentifier;
@property (nonatomic,readwrite,retain) UILabel* textLabel;
           
@end


#pragma mark -
@implementation AMSpringboardViewCell

@synthesize reuseIdentifier = _reuseIdentifier;
@synthesize image = _image;
@synthesize textLabel = _textLabel;
@synthesize highlighted = _highlighted;


- (void) setupViewForStyle:(AMSpringboardViewCellStyle)style
{
	if( style == AMSpringboardViewCellStyleDefault )
	{
        self.opaque = NO;
        
		[self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-LABEL_HEIGHT,
                                                                    self.bounds.size.width, LABEL_HEIGHT)] release];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textAlignment = UITextAlignmentCenter;
        self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
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
    [_image release];
	[_textLabel release];
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
        UIColor* color = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:kAMSpringboardViewCellShading];
        CGContextSetFillColor(context, CGColorGetComponents(color.CGColor));      
        CGContextFillRect (context, rect);
    }
    
    CGContextRestoreGState(context);
}


- (CGSize) size
{
    return self.frame.size;
}


- (void) setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
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
    }
}


// default implementation does nothing
- (void) prepareForReuse {}


@end

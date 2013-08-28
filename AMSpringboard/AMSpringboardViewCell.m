//
//  AMSpringboardViewCell.m
//  AMSpringboardView
//
//  Created by Andy Mroczkowski on 2/19/11.
//  Copyright 2011 Andy Mroczkowski. All rights reserved.
//

#import "AMSpringboardViewCell.h"

#import <QuartzCore/QuartzCore.h>

#import <AMFoundation/AMGeometry.h>

#define DEFAULT_WIDTH 101
#define DEFAULT_HEIGHT 101

#define LABEL_HEIGHT 21


@interface AMSpringboardCellHighlightView : UIView
@property (nonatomic, assign) AMSpringboardViewCell* cell; // WEAK ref
@end

@interface AMSpringboardViewCell ()

@property (nonatomic,readwrite,copy) NSString* reuseIdentifier;
@property (nonatomic,readwrite,retain) UILabel* textLabel;
@property (nonatomic,readwrite,retain) UIImageView* imageView;
@property (nonatomic,readwrite,retain) AMSpringboardCellHighlightView* highlightView;

- (CGRect) imageFrame;
- (void)adjustTextLabelSize;
           
@end


#pragma mark -
@implementation AMSpringboardViewCell

@synthesize reuseIdentifier = _reuseIdentifier;
@synthesize image = _image;
@synthesize textLabel = _textLabel;
@synthesize imageView = _imageView;
@synthesize highlightView = _highlightView;
@synthesize highlighted = _highlighted;


- (void) setupViewForStyle:(AMSpringboardViewCellStyle)style
{
    
	if( style == AMSpringboardViewCellStyleDefault || style == AMSpringboardViewCellStyleMultiline)
    {
        self.opaque = NO;
        
        self.imageView = [[[UIImageView alloc] initWithFrame:[self imageFrame]] autorelease];
        [self addSubview:self.imageView];
        self.highlightView = [[[AMSpringboardCellHighlightView alloc] initWithFrame:[self imageFrame]] autorelease];
        self.highlightView.cell = self;
        [self addSubview:self.highlightView];
        
        if( style == AMSpringboardViewCellStyleDefault )
        {
            
            self.textLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-LABEL_HEIGHT,
                                                                        self.bounds.size.width, LABEL_HEIGHT)] autorelease];
            
            self.textLabel.clipsToBounds = NO;
            self.textLabel.backgroundColor = [UIColor clearColor];
            self.textLabel.textAlignment = UITextAlignmentCenter;
            self.textLabel.font = [UIFont systemFontOfSize:14];
        
            [self addSubview:self.textLabel];
        } 
        else if (style == AMSpringboardViewCellStyleMultiline)
        {
            
            self.textLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-LABEL_HEIGHT,
                                                                        self.bounds.size.width, 0)] autorelease];
            
            self.textLabel.clipsToBounds = NO;
            self.textLabel.numberOfLines = 2;
            self.textLabel.lineBreakMode = UILineBreakModeWordWrap;
            self.textLabel.backgroundColor = [UIColor clearColor];
            self.textLabel.textAlignment = UITextAlignmentCenter;
            [self addSubview:self.textLabel];
        }
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
    [_highlightView release];
	[_textLabel release];
	[super dealloc];
}

- (CGRect) imageFrame
{
    CGRect imageFrame = self.bounds;
    imageFrame.size.height -= LABEL_HEIGHT;
    imageFrame = AMRectInsetWithAspectRatio(imageFrame, 1);
    return imageFrame;
}

//- (void) drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSaveGState(context);
//    
//    CGRect imageFrame = [self imageFrame];
//    
//    if( CGRectIntersectsRect(imageFrame, rect) )
//    {
//        CGContextSetBlendMode(context, kCGBlendModeMultiply);
//        
//        CGContextScaleCTM(context, 1.0, -1.0);
//        CGContextTranslateCTM(context, 0.0, -imageFrame.size.height);
//        
//        CGContextClipToRect(context, rect);
//        CGContextClipToMask(context, imageFrame, self.image.CGImage);
//        
//        CGContextDrawImage(context, imageFrame, self.image.CGImage);
//        
//        if( self.highlighted )
//        {
//            UIColor* color = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
//            CGContextSetFillColor(context, CGColorGetComponents(color.CGColor));      
//            CGContextFillRect (context, rect);
//        }
//    }
//    
//    CGContextRestoreGState(context);
//    
//    // TODO: this is not the best way to put this...
//    [self adjustTextLabelSize];
//}

- (void) layoutSubviews
{
    [self adjustTextLabelSize];
    self.imageView.frame = [self imageFrame];
    self.highlightView.frame = [self imageFrame];
}

- (void)adjustTextLabelSize
{
    CGSize maximumSize = CGSizeMake(self.bounds.size.width, 9999);
    CGSize stringSize = [self.textLabel.text sizeWithFont:self.textLabel.font
                                        constrainedToSize:maximumSize 
                                            lineBreakMode:self.textLabel.lineBreakMode];
    self.textLabel.frame =  CGRectMake(self.textLabel.frame.origin.x, self.textLabel.frame.origin.y, self.frame.size.width, stringSize.height);
}


- (void) setHighlighted:(BOOL)highlighted
{
    if( highlighted != _highlighted )
    {
        _highlighted = highlighted;
        [self.highlightView setNeedsDisplay];
    }
}


- (void) setImage:(UIImage *)image
{
    if( image != _image )
    {
        [image retain];
        [_image release];
        _image = image;
        
        self.imageView.image = image;
    }
}


// default implementation does nothing
- (void) prepareForReuse {}


@end


@implementation AMSpringboardCellHighlightView : UIView

@synthesize cell = _cell;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void) drawRect:(CGRect)rect
{
    if( self.cell.highlighted )
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        
        CGRect bounds = self.bounds;
        
        CGContextSetBlendMode(context, kCGBlendModeMultiply);
        
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextTranslateCTM(context, 0.0, -bounds.size.height);
        
        CGContextClipToRect(context, rect);
        CGContextClipToMask(context, bounds, self.cell.image.CGImage);
        
        UIColor* color = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
        CGContextSetFillColor(context, CGColorGetComponents(color.CGColor));      
        CGContextFillRect (context, rect);
        
        CGContextRestoreGState(context);
    }
}


@end

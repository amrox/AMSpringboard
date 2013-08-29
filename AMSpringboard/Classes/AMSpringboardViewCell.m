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


// Copied from Macros.h. Need a better place to make this stuff accessible from everywhere.
#define UICOLOR_RGB_BYTE(R,G,B,A) [UIColor colorWithRed:(CGFloat)(R)/255 green:(CGFloat)(G)/255 blue:(CGFloat)(B)/255 alpha:(CGFloat)(A)/255]

#define UI_USER_INTERFACE_IDIOM() ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)] ? [[UIDevice currentDevice] userInterfaceIdiom] : UIUserInterfaceIdiomPhone)
#define DEVICE_IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define DEVICE_IS_IPAD (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)

#define DEFAULT_WIDTH 105
#define DEFAULT_HEIGHT 100

#define LABEL_HEIGHT 30

#define FONT_SIZE_IPHONE 13
#define FONT_SIZE_IPAD 26

@interface AMSpringboardCellHighlightView : UIView
@property (nonatomic, assign) AMSpringboardViewCell* cell; // WEAK ref
@end

@interface AMSpringboardViewCell ()

@property (nonatomic,readwrite,copy) NSString* reuseIdentifier;
@property (nonatomic,readwrite,retain) UILabel* textLabel;
@property (nonatomic,readwrite,retain) UIImageView* imageView;
@property (nonatomic,readwrite,retain) AMSpringboardCellHighlightView* highlightView;

@end


#pragma mark -
@implementation AMSpringboardViewCell

@synthesize reuseIdentifier = _reuseIdentifier;
@synthesize image = _image;
@synthesize textLabel = _textLabel;
@synthesize imageView = _imageView;
@synthesize highlightView = _highlightView;
@synthesize highlighted = _highlighted;
@synthesize labelFontSize = _labelFontSize;


- (void)setupViewForStyle:(AMSpringboardViewCellStyle)style fontName:(NSString *)fontName
{
	if (style == AMSpringboardViewCellStyleDefault || style == AMSpringboardViewCellStyleMultiline)
    {
        self.opaque = NO;
        
        self.imageView = [[[UIImageView alloc] init] autorelease];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self addSubview:self.imageView];
        self.highlightView = [[[AMSpringboardCellHighlightView alloc] init] autorelease];
        self.highlightView.cell = self;
        [self addSubview:self.highlightView];
        
        if (style == AMSpringboardViewCellStyleDefault)
        {
            [self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-LABEL_HEIGHT,
                                                                        self.bounds.size.width, LABEL_HEIGHT)] release];
            
            self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
//            self.textLabel.backgroundColor = [UIColor clearColor];
            self.textLabel.font = fontName ? [UIFont fontWithName:fontName size:self.labelFontSize] :
                                             [UIFont systemFontOfSize:self.labelFontSize];
            self.textLabel.textColor = UICOLOR_RGB_BYTE(91, 73, 120, 255);
            self.textLabel.adjustsFontSizeToFitWidth = YES;
            self.textLabel.minimumFontSize = 8;
            self.textLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:self.textLabel];
        }
        else if (style == AMSpringboardViewCellStyleMultiline)
        {
            [self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-LABEL_HEIGHT,
                                                                        self.bounds.size.width, 0)] release];
            
            self.textLabel.clipsToBounds = NO;
            self.textLabel.numberOfLines = 2;
            self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.textLabel.backgroundColor = [UIColor clearColor];
            self.textLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:self.textLabel];
        }
        
        self.highlightView.frame = self.imageView.frame = [self imageFrame];
    }
}


- (id)initWithStyle:(AMSpringboardViewCellStyle)style reuseIdentifier:(NSString *)identifier
{
    return [self initWithStyle:style reuseIdentifier:identifier size:CGSizeMake(DEFAULT_WIDTH, DEFAULT_HEIGHT)];
}

- (id)initWithStyle:(AMSpringboardViewCellStyle)style reuseIdentifier:(NSString *)identifier size:(CGSize)size
{
    
    return [self initWithStyle:style
               reuseIdentifier:identifier
                          size:size
                      fontName:nil];
}

- (id) initWithStyle:(AMSpringboardViewCellStyle)style
     reuseIdentifier:(NSString*)identifier
                size:(CGSize)size
            fontName:(NSString *)fontName
{
    if ((self = [self initWithFrame:CGRectMake(0, 0, size.width, size.height)]))
    {
        self.reuseIdentifier = identifier;
        [self setupViewForStyle:style fontName:fontName];
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

- (CGRect)imageFrame
{
    CGRect imageFrame = self.bounds;
    imageFrame.size.height -= LABEL_HEIGHT;
    imageFrame = AMRectInsetWithAspectRatio(imageFrame, 1);
    return imageFrame;
}

- (CGFloat)labelFontSize
{
    if (!_labelFontSize)
    {
        @synchronized(self)
        {
            if (!_labelFontSize)
            {
                if (DEVICE_IS_IPAD)
                    _labelFontSize = FONT_SIZE_IPAD;
                else
                    _labelFontSize = FONT_SIZE_IPHONE;
            }
        }
    }
    
    return _labelFontSize;
}

- (void) layoutSubviews
{    
    self.textLabel.frame = CGRectMake(0, self.frame.size.height - LABEL_HEIGHT, self.frame.size.width, LABEL_HEIGHT);
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
        
        [self layoutSubviews];
    }
}


// default implementation does nothing
- (void) prepareForReuse {}

- (BOOL)shouldShadeImageWhenHighlighted
{
    return YES;
}

@end


@implementation AMSpringboardCellHighlightView : UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void) drawRect:(CGRect)rect
{
    if ([self.cell shouldShadeImageWhenHighlighted] && self.cell.highlighted)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        
        CGRect bounds = self.bounds;
        
        CGContextSetBlendMode(context, kCGBlendModeMultiply);
        
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextTranslateCTM(context, 0.0, -bounds.size.height);
        
        CGContextClipToRect(context, rect);
        CGContextClipToMask(context, bounds, self.cell.image.CGImage);
        
        UIColor* color = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4f];
        CGContextSetFillColor(context, CGColorGetComponents(color.CGColor));      
        CGContextFillRect(context, rect);
        
        CGContextRestoreGState(context);
    }
}


@end

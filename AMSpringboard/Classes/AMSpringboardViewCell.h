//
//  AMSpringboardViewCell.h
//  AMSpringboardView
//
//  Created by Andy Mroczkowski on 2/19/11.
//  Copyright 2011 Andy Mroczkowski. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	AMSpringboardViewCellStyleDefault = 1,
    AMSpringboardViewCellStyleMultiline,
    AMSpringboardViewCellStyleEmpty
} AMSpringboardViewCellStyle;


@interface AMSpringboardViewCell : UIView

- (id) initWithStyle:(AMSpringboardViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (id) initWithStyle:(AMSpringboardViewCellStyle)style reuseIdentifier:(NSString *)identifier size:(CGSize)size;
- (id) initWithStyle:(AMSpringboardViewCellStyle)style
     reuseIdentifier:(NSString *)reuseIdentifier
                size:(CGSize)size
            fontName:(NSString *)fontName;

@property (nonatomic, readonly, retain) UIImageView *imageView; // default is nil.  label will be created if necessary.
@property (nonatomic, retain) UIImage *image;

@property (nonatomic, readonly, retain) UILabel *textLabel; // default is nil.  label will be created if necessary.

@property (nonatomic, assign) BOOL highlighted;

@property (nonatomic, readonly, copy) NSString *reuseIdentifier;

@property (nonatomic, readonly, assign) CGFloat labelFontSize;

- (void)prepareForReuse;

#pragma mark Subclasses

/**
 @default YES
 */
- (BOOL)shouldShadeImageWhenHighlighted;

@end

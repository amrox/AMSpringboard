//
//  AMSpringboardViewCell.h
//  AMSpringboardView
//
//  Created by Andy Mroczkowski on 2/19/11.
//  Copyright 2011 Andy Mroczkowski. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	AMSpringboardViewCellStyleDefault,
} AMSpringboardViewCellStyle;


@interface AMSpringboardViewCell : UIView
{
    NSString*    _reuseIdentifier;
    UIImage*     _image;
	UILabel*     _textLabel;
    BOOL         _highlighted;
}

- (id) initWithStyle:(AMSpringboardViewCellStyle)style reuseIdentifier:(NSString*)identifier;

@property (nonatomic,readonly,copy) NSString* reuseIdentifier;

@property (nonatomic, retain) UIImage* image;
@property (nonatomic,readonly,retain) UILabel* textLabel; // default is nil.  label will be created if necessary.

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) BOOL highlighted;

- (void) prepareForReuse;

@end

//
//  AMSpringboardViewCell.h
//  AMSpringboardView
//
//  Created by Andy Mroczkowski on 2/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	AMSpringboardViewCellStyleDefault,
} AMSpringboardViewCellStyle;


@interface AMSpringboardViewCell : UIView
{
    NSString*    _reuseIdentifier;
	UIImageView* _imageView;
	UILabel*     _textLabel;
}

- (id) initWithStyle:(AMSpringboardViewCellStyle)style reuseIdentifier:(NSString*)identifier;

@property (nonatomic,readonly,retain) UIImageView* imageView;  // default is nil.  image view will be created if necessary.
@property (nonatomic,readonly,retain) UILabel* textLabel; // default is nil.  label will be created if necessary.

@property (nonatomic,readonly,copy) NSString* reuseIdentifier;

- (void) prepareForReuse;

@end

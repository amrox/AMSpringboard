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
    AMSpringboardViewCellStyleMultiline
} AMSpringboardViewCellStyle;


@interface AMSpringboardViewCell : UIView

- (id) initWithStyle:(AMSpringboardViewCellStyle)style reuseIdentifier:(NSString*)identifier;

@property (nonatomic, retain) UIImage* image;

@property (nonatomic,readonly,retain) UILabel* textLabel; // default is nil.  label will be created if necessary.

@property (nonatomic, assign) BOOL highlighted;

@property (nonatomic,readonly,copy) NSString* reuseIdentifier;

- (void) prepareForReuse;

@end

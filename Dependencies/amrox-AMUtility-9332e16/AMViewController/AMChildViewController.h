/*
 *  AMChildViewController.h
 *  GeoTick
 *
 *  Created by Andy Mroczkowski on 3/14/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#import "UIViewController+AMViewController.h"

@protocol AMChildViewController <NSObject>

@property (nonatomic, assign) UIViewController* am_parentViewController;

@end

//
//  DataProviderViewController.h
//  AMSpringboardView
//
//  Created by Andy Mroczkowski on 3/28/11.
//  Copyright 2011 MindSnacks. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AMSpringboardView.h"

@class AMSpringboardDataProvider;

@interface DataProviderViewController : UIViewController <AMSpringboardViewDelegate>
{    
    AMSpringboardView*          _springboardView;
    
    AMSpringboardDataProvider*  _dataProvider;
}

@property (nonatomic, retain) IBOutlet AMSpringboardView* springboardView;

@end

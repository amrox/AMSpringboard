//
//  AMSpringboardViewAppDelegate.h
//  AMSpringboardView
//
//  Created by Andy Mroczkowski on 2/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMSpringboardViewAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UIViewController *viewController;

@end


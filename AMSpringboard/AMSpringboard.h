//
//  AMSpringboard.h
//  AMSpringboardView
//
//  Created by Andy Mroczkowski on 3/29/11.
//  Copyright 2011 Andy Mroczkowski. All rights reserved.
//

#import "AMSpringboardView.h"
#import "AMSpringboardViewCell.h"
#import "NSIndexPath+AMSpringboard.h"
#import "AMSpringboardDataProvider.h"
#import "AMSpringboardItemSpecifier.h"

enum AMSpingboardErrorCode {
    AMSpringboardUnkownPlistFormatError = 1,
};

#define AMSpringboardErrorDomain @"com.amerzing.AMSpringboard"
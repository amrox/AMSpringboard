//
//  DataProviderViewController.m
//  AMSpringboardView
//
//  Created by Andy Mroczkowski on 3/28/11.
//  Copyright 2011 MindSnacks. All rights reserved.
//

#import "DataProviderViewController.h"

#import "AMSpringboardDataProvider.h"
#import "AMSpringboardItemSpecifier.h"


@implementation DataProviderViewController

@synthesize springboardView = _springboardView;


- (void) _initDataProvider
{
    [_dataProvider release], _dataProvider = nil; // TODO: property
    _dataProvider = [[AMSpringboardDataProvider alloc] init];
    
    _dataProvider.rowCount = 3;
    _dataProvider.columnCount = 2;
    
    NSArray* pages = [NSArray arrayWithObjects:
                      [NSArray arrayWithObjects:
                       [AMSpringboardItemSpecifier itemSpecifierWithTitle:@"one" 
                                                                imageName:@"beer-icon"],
                       [NSNull null],
                       
                       [AMSpringboardItemSpecifier itemSpecifierWithTitle:@"two" 
                                                                imageName:@"beer-icon"],
                       
                       [NSNull null],
                       
                       [AMSpringboardItemSpecifier itemSpecifierWithTitle:@"three"
                                                                imageName:@"beer-icon"],

                       [AMSpringboardItemSpecifier itemSpecifierWithTitle:@"four"
                                                                imageName:@"beer-icon"],
                       
                       nil],
                      [NSArray arrayWithObjects:
                       [AMSpringboardItemSpecifier itemSpecifierWithTitle:@"one" 
                                                                imageName:@"beer-icon"],
                       [NSNull null],
                       
                       [AMSpringboardItemSpecifier itemSpecifierWithTitle:@"two" 
                                                                imageName:@"beer-icon"],
                       
                       [AMSpringboardItemSpecifier itemSpecifierWithTitle:@"three"
                                                                imageName:@"beer-icon"],
                       
                       [NSNull null],
                       
                       [AMSpringboardItemSpecifier itemSpecifierWithTitle:@"four"
                                                                imageName:@"beer-icon"],
                       
                       nil],
                      nil];
    
    _dataProvider.pages = pages;
    _dataProvider.springboardView = self.springboardView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_springboardView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.springboardView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self _initDataProvider];
    [self.springboardView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.springboardView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark AMSpringboardViewDelegate

- (void) springboardView:(AMSpringboardView*)springboardView didSelectCellWithPosition:(NSIndexPath*)position
{
    LOG_TRACE();
}

@end

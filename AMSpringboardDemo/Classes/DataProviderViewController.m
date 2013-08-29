//
//  DataProviderViewController.m
//  AMSpringboardView
//
//  Created by Andy Mroczkowski on 3/28/11.
//  Copyright 2011 Andy Mroczkowski. All rights reserved.
//

#import "DataProviderViewController.h"

#import "AMSpringboardDataProvider.h"
#import "AMSpringboardItemSpecifier.h"

@interface DataProviderViewController ()
@property (nonatomic, retain) AMSpringboardDataProvider* dataProvider;
@end


@implementation DataProviderViewController

@synthesize springboardView = _springboardView;
@synthesize dataProvider = _dataProvider;


- (void) _initDataProvider
{
    // -- manual page array creation
    /*
    self.dataProvider = [AMSpringboardDataProvider dataProvider];
    self.dataProvider.rowCount = 3;
    self.dataProvider.columnCount = 2;
    NSMutableArray* pages = [NSMutableArray arrayWithObjects:
                             [NSMutableArray arrayWithObjects:
                              [AMSpringboardItemSpecifier itemSpecifierWithTitle:@"one" 
                                                                       imageName:@"beer-icon"],
                              
                              [AMSpringboardNullItem nullItem],
                              
                              [AMSpringboardItemSpecifier itemSpecifierWithTitle:@"two" 
                                                                       imageName:@"beer-icon"],
                              
                              [AMSpringboardNullItem nullItem],
                              
                              [AMSpringboardItemSpecifier itemSpecifierWithTitle:@"three"
                                                                       imageName:@"beer-icon"],
                              
                              [AMSpringboardItemSpecifier itemSpecifierWithTitle:@"four"
                                                                       imageName:@"beer-icon"],
                              
                              nil],
                             [NSMutableArray arrayWithObjects:
                              [AMSpringboardItemSpecifier itemSpecifierWithTitle:@"one" 
                                                                       imageName:@"beer-icon"],
                              [AMSpringboardNullItem nullItem],
                              
                              [AMSpringboardItemSpecifier itemSpecifierWithTitle:@"two" 
                                                                       imageName:@"beer-icon"],
                              
                              [AMSpringboardItemSpecifier itemSpecifierWithTitle:@"three"
                                                                       imageName:@"beer-icon"],
                              
                              [AMSpringboardNullItem nullItem],
                              
                              [AMSpringboardItemSpecifier itemSpecifierWithTitle:@"four"
                                                                       imageName:@"beer-icon"],
                              nil],
                             nil];
    self.dataProvider.pages = pages;
     */
    
    // -- Page creation from plist file
    NSError* error = nil;
    NSString* path = [[NSBundle mainBundle] pathForResource:@"Springboard" ofType:@"plist"];
    self.dataProvider = [AMSpringboardDataProvider dataProviderFromPlistWithPath:path error:&error];

    // -- set data source
    self.springboardView.dataSource = self.dataProvider;
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
    NSLog(@"selected %@", position);
}

@end

//
//  RootViewController.m
//  AMSpringboardView
//
//  Created by Andy Mroczkowski on 3/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"

#import "TestCell.h"


@implementation RootViewController

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
    
    AMSpringboardView* springboardView = (AMSpringboardView*)self.view;
    
    springboardView.delegate = self;
	springboardView.dataSource = self;
    springboardView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark AMSpringBoardViewDataSource

- (NSInteger) numberOfPagesInSpringboardView:(AMSpringboardView*)springboardView 
{
	return 5;
}


- (NSInteger) numberOfRowsInSpringboardView:(AMSpringboardView*)springboardView
{
	return 3;
}


- (NSInteger) numberOfColumnsInSpringboardView:(AMSpringboardView*)springboardView
{
	return 3;	
}

#pragma mark AMSpringboardViewDelegate

- (AMSpringboardViewCell*) springboardView:(AMSpringboardView*)springboardView cellForPositionWithIndexPath:(NSIndexPath*)indexPath
{
    //LOG_DEBUG( @"%@", indexPath );
    
    if( [indexPath springboardRow] == 2 && [indexPath springboardColumn] == 2 )
        return nil;
    
    static NSString* identifier = @"Myidentifier";
    
    AMSpringboardViewCell* cell = (AMSpringboardViewCell*)[springboardView dequeueReusableCellWithIdentifier:identifier];
    if( cell == nil )
    {
        cell = [[[AMSpringboardViewCell alloc] initWithStyle:AMSpringboardViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.backgroundColor = [UIColor redColor];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"(%d, %d, %d)",
                           [indexPath springboardPage],
                           [indexPath springboardColumn],
                           [indexPath springboardRow]];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    return cell;
}


- (void) springboardView:(AMSpringboardView*)springboardView didSelectCellWithPosition:(NSIndexPath*)position
{
    LOG_TRACE();
}

@end

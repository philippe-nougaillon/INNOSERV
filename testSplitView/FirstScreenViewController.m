//
//  FirstScreenViewController.m
//  Innoserv
//
//  Created by philippe nougaillon on 26/08/13.
//  Copyright (c) 2013 philippe nougaillon. All rights reserved.
//

#import "FirstScreenViewController.h"

@interface FirstScreenViewController () {

    BOOL introAnimationDone;
    __weak IBOutlet UIButton *button1;
    __weak IBOutlet UIButton *button2;
    __weak IBOutlet UIButton *button3;
    __weak IBOutlet UILabel *menuTitle;
}

@end

@implementation FirstScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    button1.titleLabel.text = NSLocalizedString(@"About", @"");
  
    [menuTitle setFont:[UIFont fontWithName:@"Open Sans" size:19]];
    
    [button1.titleLabel setFont:[UIFont fontWithName:@"Open Sans" size:16]];
    [button2.titleLabel setFont:[UIFont fontWithName:@"Open Sans" size:16]];
    [button3.titleLabel setFont:[UIFont fontWithName:@"Open Sans" size:16]];
   
    [self presentMainMenu];
    
}
- (void)presentMainMenu {
        
    if (introAnimationDone) {
        return;
    }
        
    CGRect rect;
    
    // position de départ
    for (NSInteger i = 1; i < 5; i++) {
		UIView *view = [self.view viewWithTag:i];
		rect = view.frame;
		rect.origin.x = -320 - i * 20;
		view.frame = rect;
	}
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	
    // position de fin
    for (NSInteger i = 1; i < 5; i++) {
		
		[UIView setAnimationDelay:i * 0.15];
		
		UIView *view = [self.view viewWithTag:i];
		rect = view.frame;
		rect.origin.x = 16;
		view.frame = rect;
	}
    // Lance l'animation
    [UIView commitAnimations];
    
    introAnimationDone = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

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

    __weak IBOutlet UILabel *menuTitle;
    __weak IBOutlet UIButton *button1;
    __weak IBOutlet UIButton *button2;
    __weak IBOutlet UIButton *button3;
    __weak IBOutlet UIButton *button4;
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
  
    [menuTitle setFont:[UIFont fontWithName:@"Open Sans" size:19]];
    
    [button1.titleLabel setFont:[UIFont fontWithName:@"Open Sans" size:15]];
    [button2.titleLabel setFont:[UIFont fontWithName:@"Open Sans" size:15]];
    [button3.titleLabel setFont:[UIFont fontWithName:@"Open Sans" size:15]];
    [button4.titleLabel setFont:[UIFont fontWithName:@"Open Sans" size:15]];

    [button1 setTitle:NSLocalizedString(@"menu_About", @"") forState:UIControlStateNormal];
    [button2 setTitle:NSLocalizedString(@"menu_Trailer", @"") forState:UIControlStateNormal];
    [button3 setTitle:NSLocalizedString(@"menu_20projects", @"") forState:UIControlStateNormal];
    [button4 setTitle:NSLocalizedString(@"menu_www", @"") forState:UIControlStateNormal];
    
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
    
    // démarre l'animation, position début
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	
    // va à la position de fin
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

- (IBAction)openInnoservWebSite:(id)sender {

    // ouvre le site dans Safari
    NSString *webPageLink = NSLocalizedString(@"innoserv-url", @"");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webPageLink]];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

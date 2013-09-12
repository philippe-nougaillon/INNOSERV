//
//  AboutPagesIPAD0ViewController.m
//  Innoserv
//
//  Created by philippe nougaillon on 12/09/13.
//  Copyright (c) 2013 philippe nougaillon. All rights reserved.
//

#import "AboutPagesIPAD0ViewController.h"
#import "AboutPagesContainerIPADViewController.h"

@interface AboutPagesIPAD0ViewController ()

@end

@implementation AboutPagesIPAD0ViewController

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
}

- (void)viewDidAppear:(BOOL)animated
{
    AboutPagesContainerIPADViewController *controller = [[AboutPagesContainerIPADViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    [self presentViewController:controller animated:YES completion:nil];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

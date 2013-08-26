//
//  aboutPageContainerViewController.m
//  Innoserv
//
//  Created by philippe nougaillon on 26/08/13.
//  Copyright (c) 2013 philippe nougaillon. All rights reserved.
//

#import "aboutPageContainerViewController.h"
#import "AboutPagesViewController.h"

@interface aboutPageContainerViewController ()

@end

@implementation aboutPageContainerViewController

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
    AboutPagesViewController *controller = [[AboutPagesViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    [self presentViewController:controller animated:YES completion:nil];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

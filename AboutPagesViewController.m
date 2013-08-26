//
//  AboutPagesViewController.m
//  Innoserv
//
//  Created by philippe nougaillon on 26/08/13.
//  Copyright (c) 2013 philippe nougaillon. All rights reserved.
//

#import "AboutPagesViewController.h"

@interface AboutPagesViewController ()

@property NSMutableArray *pages;

@end

@implementation AboutPagesViewController

@synthesize pages = _pages;

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

    [self createPages];
    self.dataSource = self;
    [self setViewControllers:[NSArray arrayWithObject:[self.pages objectAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:true completion:nil];

}


-(void) createPages
{
    self.pages = [[NSMutableArray alloc]initWithCapacity:4];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhoneStoryboard" bundle:[NSBundle mainBundle]];

    UIViewController *controller1;
    controller1 = [storyboard instantiateViewControllerWithIdentifier:@"AboutPageViewController1"];
    controller1.view.backgroundColor = [UIColor blueColor];
    [self.pages addObject:controller1];

    UIViewController *controller2;
    controller2 = [storyboard instantiateViewControllerWithIdentifier:@"AboutPageViewController2"];
    controller2.view.backgroundColor = [UIColor greenColor];
    [self.pages addObject:controller2];

    
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    UIViewController *view = nil;
    if ([self.pages objectAtIndex:0] != viewController){
        for (int i = 1; i > 0 ; i--) {
            if ([self.pages objectAtIndex:i] == viewController){
                view = [self.pages objectAtIndex:i-1];
                break;
            }
        }
    }
    return view;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    UIViewController * view = nil;
    if ([self.pages objectAtIndex:1] != viewController){
        for (int i = 0; i < 1; i++) {
            if ([self.pages objectAtIndex:i] == viewController){
                view = [self.pages objectAtIndex:i+1];
                break;
            }
        }
    }
    return view;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

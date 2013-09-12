//
//  AboutPagesContainerIPADViewController.m
//  Innoserv
//
//  Created by philippe nougaillon on 12/09/13.
//  Copyright (c) 2013 philippe nougaillon. All rights reserved.
//

#import "AboutPagesContainerIPADViewController.h"

#define nbPages 2

@interface AboutPagesContainerIPADViewController ()

@property NSMutableArray *pages;

@end


@implementation AboutPagesContainerIPADViewController

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
    self.pages = [[NSMutableArray alloc]initWithCapacity:nbPages];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPadStoryboard" bundle:[NSBundle mainBundle]];
    
    UIViewController *controller1;
    controller1 = [storyboard instantiateViewControllerWithIdentifier:@"AboutPagesIPAD1ViewController"];
    [self.pages addObject:controller1];
    
    UIViewController *controller2;
    controller2 = [storyboard instantiateViewControllerWithIdentifier:@"AboutPagesIPAD2ViewController"];
    [self.pages addObject:controller2];
    
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    UIViewController *view = nil;
    if ([self.pages objectAtIndex:0] != viewController){
        for (int i = nbPages -1; i > 0 ; i--) {
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
    
    // test si dernière page
    if ([self.pages objectAtIndex:nbPages-1] != viewController){
        for (int i = 0; i < nbPages; i++) {
            if ([self.pages objectAtIndex:i] == viewController){
                view = [self.pages objectAtIndex:i+1];
                break;
            }
        }
    }
    return view;
}

/*
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait; // etc
}
*/

@end

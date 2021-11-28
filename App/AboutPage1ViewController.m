//
//  AboutPage1ViewController.m
//  Innoserv
//
//  Created by philippe nougaillon on 26/08/13.
//  Copyright (c) 2013 philippe nougaillon. All rights reserved.
//

#import "AboutPage1ViewController.h"

@interface AboutPage1ViewController ()

@end

@implementation AboutPage1ViewController

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

- (IBAction)socialButtonsPressed:(UIButton *)sender {
    
    //UIButton *button = (UIButton*)sender;
    NSInteger buttonTag = sender.tag;
    NSURL *url;
    
    if (buttonTag == 1)
        url = [NSURL URLWithString:@"http://www.linkedin.com/groups/INNOSERV-Social-Platform-on-Innovative-4867400"];
    if (buttonTag == 2)
        url = [NSURL URLWithString:@"http://www.youtube.com/channel/UC8j5jjDi12xDSAyCR3Vk5PA"];
    if (buttonTag == 3)
        url = [NSURL URLWithString:@"https://www.facebook.com/innoserv"];
    if (buttonTag == 4)
        url = [NSURL URLWithString:@"https://twitter.com/INNOSERVproject"];
    
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {}];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

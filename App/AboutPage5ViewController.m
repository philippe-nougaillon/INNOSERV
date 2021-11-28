//
//  AboutPage5ViewController.m
//  Innoserv
//
//  Created by philippe nougaillon on 05/09/13.
//  Copyright (c) 2013 philippe nougaillon. All rights reserved.
//

#import "AboutPage5ViewController.h"

@interface AboutPage5ViewController ()

@end

@implementation AboutPage5ViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)openQuestionnairelink:(id)sender {
    
    // ouvre le site dans Safari
    NSString *webPageLink = NSLocalizedString(@"innoserv-survey-url", @"");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webPageLink] options:@{} completionHandler:^(BOOL success) {}];
    
}

@end

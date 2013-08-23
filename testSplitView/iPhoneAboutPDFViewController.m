//
//  iPhoneAboutPDFViewController.m
//  Innoserv
//
//  Created by philippe nougaillon on 10/04/13.
//  Copyright (c) 2013 philippe nougaillon. All rights reserved.
//

#import "iPhoneAboutPDFViewController.h"

@interface iPhoneAboutPDFViewController ()

@end

@implementation iPhoneAboutPDFViewController

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
    
    
    NSString *urlAddress = [[NSBundle mainBundle] pathForResource:@"INNOSERV_Flyer_2013" ofType:@"pdf"];
    
    NSURL *url = [NSURL fileURLWithPath:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webViewForPDF loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWebViewForPDF:nil];
    [super viewDidUnload];
}
@end

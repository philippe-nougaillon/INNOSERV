//
//  ViewControllerMorePage.m
//  Innoserv
//
//  Created by philippe nougaillon on 21/02/13.
//  Copyright (c) 2013 philippe nougaillon. All rights reserved.
//

#import "ViewControllerMorePage.h"

@interface ViewControllerMorePage ()
@property (weak, nonatomic) IBOutlet UIWebView *webViewForPDF;

@end

@implementation ViewControllerMorePage

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)okButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:NULL];

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight));
}


@end

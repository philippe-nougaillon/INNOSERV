//
//  iPadMorePageViewController.m
//  Innoserv
//
//  Created by philippe nougaillon on 24/04/13.
//  Copyright (c) 2013 philippe nougaillon. All rights reserved.
//

#import "iPadMorePageViewController.h"

@interface iPadMorePageViewController ()
{
    __weak IBOutlet UIBarButtonItem *closeButton;
    __weak IBOutlet WKWebView *webView;
    __weak IBOutlet UIActivityIndicatorView *myActivityIndicator;

}
@end

@implementation iPadMorePageViewController 

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
    
    // Localize button label
    closeButton.title = NSLocalizedString(@"Close", @"");
    
    
    [myActivityIndicator startAnimating];
    
    NSString *webPageLink;
    if (self.detailItem.website) {
        webPageLink = self.detailItem.website;
    }
    else {
        webPageLink = @"http://www.inno-serv.eu";
    }

    //webView.UIDelegate = self;
    
    NSURL *url = [NSURL URLWithString:webPageLink];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
}

/*
- (BOOL)webView:(UIWebView *)wv shouldStartLoadWithRequest:(NSURLRequest *)rq navigationType:(UIWebViewNavigationType)navigationType
{
    myActivityIndicator.hidden = FALSE;
    [myActivityIndicator startAnimating];
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    myActivityIndicator.hidden = TRUE;

    [myActivityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)wv didFailLoadWithError:(NSError *)error
{
    [myActivityIndicator stopAnimating];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight));
}

 */


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

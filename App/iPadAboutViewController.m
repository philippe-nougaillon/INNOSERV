//
//  iPadAboutViewController.m
//  Innoserv
//
//  Created by philippe nougaillon on 24/04/13.
//  Copyright (c) 2013 philippe nougaillon. All rights reserved.
//

#import "iPadAboutViewController.h"

@interface iPadAboutViewController ()
{
    __weak IBOutlet WKWebView *webView;
    __weak IBOutlet UIBarButtonItem *closeButton;
    __weak IBOutlet UIActivityIndicatorView *myActivityIndicator;
    
}
@end

@implementation iPadAboutViewController

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

    myActivityIndicator.hidden = YES;
    webView.UIDelegate = self;
    [myActivityIndicator startAnimating];
    
    NSURL *url;

    if (self.detailItem)
        url = [NSURL URLWithString:self.detailItem.website];
    else
        url = [NSURL URLWithString:NSLocalizedString(@"innoserv-url", @"")];
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
    
}

- (IBAction)closeButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:NULL];

}

# pragma mark <UIWebViewDelegate>
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
*/

# pragma mark app delegate

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

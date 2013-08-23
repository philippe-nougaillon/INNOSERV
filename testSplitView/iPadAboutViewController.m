//
//  iPadAboutViewController.m
//  Innoserv
//
//  Created by philippe nougaillon on 24/04/13.
//  Copyright (c) 2013 philippe nougaillon. All rights reserved.
//

#import "iPadAboutViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface iPadAboutViewController ()
{
    __weak IBOutlet UIWebView *webView;
    __weak IBOutlet UIBarButtonItem *closeButton;
    __weak IBOutlet UIBarButtonItem *trailerButton;
    __weak IBOutlet UIBarButtonItem *websiteButton;
    __weak IBOutlet UIActivityIndicatorView *myActivityIndicator;
    
    MPMoviePlayerViewController *_player;
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
    webView.delegate = self;
    [myActivityIndicator startAnimating];
    
    // Localize button title
    closeButton.title = NSLocalizedString(@"Close", @"");
    trailerButton.title = NSLocalizedString(@"Trailer", @"");
    websiteButton.title = NSLocalizedString(@"Website", @"");
    
    // load pdf
    NSString *urlAddress = [[NSBundle mainBundle] pathForResource:@"INNOSERV_Flyer_2013" ofType:@"pdf"];
    
    NSURL *url = [NSURL fileURLWithPath:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
    
}
- (IBAction)closeButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:NULL];

}

- (IBAction)openTrailerButtonPressed:(id)sender {
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:@"Trailer_V4" ofType:@"mp4"]];
    
    _player = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    _player.view.frame = CGRectMake(100, 200, 200, 200);
   
    [self.view addSubview:_player.view];
    
    [[NSNotificationCenter defaultCenter] removeObserver:_player
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:_player.moviePlayer];
    
    // Register this class as an observer instead
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_player.moviePlayer];
    
}

- (void)movieFinishedCallback:(NSNotification*)aNotification
{
    // Obtain the reason why the movie playback finished
    NSNumber *finishReason = [[aNotification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    // Dismiss the view controller ONLY when the reason is not "playback ended"
    if ([finishReason intValue] != MPMovieFinishReasonPlaybackEnded)
    {
        MPMoviePlayerController *moviePlayer = [aNotification object];
        
        // Remove this class from the observers
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:moviePlayer];
        
        [_player.view removeFromSuperview];
    }
}

- (IBAction)openWebsite:(id)sender {
 
    webView.delegate = self;
    
    myActivityIndicator.hidden = NO;
    [myActivityIndicator startAnimating];
    
    NSURL *url = [NSURL URLWithString:@"http://www.inno-serv.eu"];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
}

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




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

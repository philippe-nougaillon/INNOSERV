//
//  FirstScreenViewController.m
//  Innoserv
//
//  Created by philippe nougaillon on 26/08/13.
//  Copyright (c) 2013 philippe nougaillon. All rights reserved.
//

#import "FirstScreenViewController.h"
#import <MediaPlayer/MediaPlayer.h>


@interface FirstScreenViewController () {

    BOOL introAnimationDone;

    __weak IBOutlet UILabel  *menuTitle;
    __weak IBOutlet UIButton *button1;
    __weak IBOutlet UIButton *button2;
    __weak IBOutlet UIButton *button3;
    __weak IBOutlet UIButton *button4;
    
    MPMoviePlayerViewController *_player;

}

@end

@implementation FirstScreenViewController

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
  
    [menuTitle setFont:[UIFont fontWithName:@"Open Sans" size:19]];
    
    [button1.titleLabel setFont:[UIFont fontWithName:@"Open Sans" size:15]];
    [button2.titleLabel setFont:[UIFont fontWithName:@"Open Sans" size:15]];
    [button3.titleLabel setFont:[UIFont fontWithName:@"Open Sans" size:15]];
    [button4.titleLabel setFont:[UIFont fontWithName:@"Open Sans" size:15]];

    [button1 setTitle:NSLocalizedString(@"menu_About", @"") forState:UIControlStateNormal];
    [button2 setTitle:NSLocalizedString(@"menu_Trailer", @"") forState:UIControlStateNormal];
    [button3 setTitle:NSLocalizedString(@"menu_20projects", @"") forState:UIControlStateNormal];
    [button4 setTitle:NSLocalizedString(@"menu_www", @"") forState:UIControlStateNormal];
    
    [self presentMainMenu];
}

- (void)presentMainMenu {
        
    if (introAnimationDone) {
        return;
    }
        
    CGRect rect;
    
    // position de départ
    for (NSInteger i = 1; i < 5; i++) {
		UIView *view = [self.view viewWithTag:i];
		rect = view.frame;
		rect.origin.x = -320 - i * 20;
		view.frame = rect;
	}
    
    // démarre l'animation, position début
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	
    // va à la position de fin
    for (NSInteger i = 1; i < 5; i++) {
		
		[UIView setAnimationDelay:i * 0.15];
		
		UIView *view = [self.view viewWithTag:i];
		rect = view.frame;
		rect.origin.x = 16;
		view.frame = rect;
	}
    // Lance l'animation
    [UIView commitAnimations];
    
    introAnimationDone = YES;
}

- (IBAction)openInnoservWebSite:(id)sender {

    // ouvre le site dans Safari
    NSString *webPageLink = NSLocalizedString(@"innoserv-url", @"");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webPageLink]];
    
}


- (IBAction)openTrailerButtonPressed:(id)sender {

    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:@"Trailer_V4-mono" ofType:@"mp4"]];
    
    _player = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    _player.moviePlayer.fullscreen = YES;
    _player.view.frame = self.view.frame;
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:_player
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:_player.moviePlayer];
    
    // Register this class as an observer instead
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_player.moviePlayer];
    
    [self.view addSubview:_player.view];
    
    // self.openWebPageToolBarButton.enabled= NO;
    self.navigationController.navigationBarHidden = YES;

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
        self.navigationController.navigationBarHidden = NO;
    }
}

-(NSUInteger)supportedInterfaceOrientations{
    
    // allow rotation is video in playing
    if (_player.isViewLoaded)
        return UIInterfaceOrientationMaskAll;
    else
        return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end

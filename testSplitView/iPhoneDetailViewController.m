//
//  iPhoneDetailViewController.m
//  Innoserv
//
//  Created by philippe nougaillon on 09/04/13.
//  Copyright (c) 2013 philippe nougaillon. All rights reserved.
//

#import "iPhoneDetailViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface iPhoneDetailViewController ()
{
    MPMoviePlayerViewController *_player;
    UIWebView *videoView;
    
    __weak IBOutlet UIBarButtonItem *openWebPageToolBarButton;
    __weak IBOutlet UILabel *projectSubTiltle;
    __weak IBOutlet UITextView *projectInformation;
    __weak IBOutlet UIImageView *projectImage;
    __weak IBOutlet UIButton *playVideoButton;
}

@end

@implementation iPhoneDetailViewController

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
    
    //localize buttons
    openWebPageToolBarButton.title = NSLocalizedString(@"Website", @"");
    
    //set fonts
    [projectSubTiltle setFont:[UIFont fontWithName:@"Open Sans" size:18]];
    [projectInformation setFont:[UIFont fontWithName:@"Open Sans" size:14]];
    
	// Do any additional setup after loading the view.
    if (self.detailItem) {
        
        projectSubTiltle.text = self.detailItem.description;
        projectInformation.text = self.detailItem.information;

        NSString *imageFileName = [self.detailItem.image stringByAppendingString:@"-big.png"];
        projectImage.image = [UIImage imageNamed:imageFileName];
        
        // if website > show info button
        if ([self.detailItem.website isEqualToString:@""])
            openWebPageToolBarButton.enabled = NO;
        else
            openWebPageToolBarButton.enabled = YES;

        // if video file, show playVideo button
        if ([self.detailItem.videofile isEqualToString:@""])
            playVideoButton.hidden = YES;
        else
            playVideoButton.hidden = NO;
    }
}

- (IBAction)openWebPagePressed:(id)sender {
    
    if (self.detailItem) {
        
        NSString *webPageLink = self.detailItem.website;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webPageLink]];
    }
}
- (IBAction)playVideoButtonPressed:(id)sender {
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:self.detailItem.videofile ofType:@"mp4"]];
    
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTitle:nil];
    [super viewDidUnload];
}
@end

//
//  iPhoneVideoViewController.m
//  Innoserv
//
//  Created by philippe nougaillon on 23/08/13.
//  Copyright (c) 2013 philippe nougaillon. All rights reserved.
//

#import "iPhoneVideoViewController.h"
#import "SrtParser.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>  

@interface iPhoneVideoViewController () {

    UIView *myView;
    NSURL *url;
    NSString *dataFile;
}

@property (nonatomic, retain) SrtParser *srtParser;
@property (nonatomic, retain) UILabel *subtitleLabel;
@property (nonatomic, retain) NSTimer *subtitleTimer;
@property (nonatomic, retain) AVPlayerViewController *moviePlayer;

-(void)prepareView;

@end

@implementation iPhoneVideoViewController


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
    
    // subscribe to orientation change
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    // Prepare video subtitles
    //
    NSString *srtPath = [[NSBundle mainBundle] pathForResource:self.detailItem.subTitles ofType:@"txt"];

    // Parse subtitles
    self.srtParser = [[SrtParser alloc] init];
    [self.srtParser parseSrtFileAtPath:srtPath];
    
    if (self.detailItem) {
        // where is project video file to play ?
        NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        // Build the path to the data file
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            dataFile = [docsDir stringByAppendingPathComponent:
                    [self.detailItem.videofile stringByAppendingString:@"-iPad.mp4"]];
        else
            dataFile = [docsDir stringByAppendingPathComponent:
                        [self.detailItem.videofile stringByAppendingString:@".mp4"]];
    } else {
        // show the trailer if no project selected
        dataFile = [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"Trailer_V4-mono.mp4"];
    }
    // URL of the video
    url = [NSURL fileURLWithPath:dataFile];
    
	// setup video view and play
    [self prepareView];
}

-(void)prepareView {
    
    // A place for video player and subtitles
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        myView =[[UIView alloc] initWithFrame:CGRectMake(0, 200, 700, 400)];
    else
        myView =[[UIView alloc] initWithFrame:self.view.frame];
        
    // Movieplayer setup
    //self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    //self.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    //self.moviePlayer.controlStyle =  MPMovieControlStyleFullscreen;
    //self.moviePlayer.view.frame = myView.bounds;
    
    AVPlayerViewController * _moviePlayer1 = [[AVPlayerViewController alloc] init];
    _moviePlayer1.player = [AVPlayer playerWithURL:url];

    [self presentViewController:_moviePlayer1 animated:YES completion:^{
        [_moviePlayer1.player play];
    }];
    
    //[myView addSubview:self.moviePlayer.view];
    //[self.moviePlayer prepareToPlay];
    
    if (self.detailItem) {

        UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            // iPAD
            // Depending of the current orientation
            if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
                self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 400, 700, 100)];
                self.subtitleLabel.font = [UIFont fontWithName:@"Open Sans" size:24];
            } else {
                self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 400, 700, 60)];
                self.subtitleLabel.font = [UIFont fontWithName:@"Open Sans" size:16];
            }
        } else {
            // iPhone
            if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
                CGSize deviceBounds = [[UIScreen mainScreen] bounds].size;
                self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 290, deviceBounds.height, 40)];
                self.subtitleLabel.font = [UIFont fontWithName:@"Open Sans" size:24];
            } else {
                self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 380, 320, 60)];
                self.subtitleLabel.font = [UIFont fontWithName:@"Open Sans" size:16];
            }
        }
    
        // A place for subtitles
        self.subtitleLabel.numberOfLines = 2;
        //self.subtitleLabel.backgroundColor = [UIColor whiteColor];
        self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
        self.subtitleLabel.textColor = [UIColor whiteColor];
        self.subtitleLabel.shadowColor = [UIColor blackColor];
        self.subtitleLabel.shadowOffset = CGSizeMake(1, 1);
        [myView addSubview:self.subtitleLabel];
        
        // Register for Timer
        [self.subtitleTimer invalidate];
        self.subtitleTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateSubtitles) userInfo:self repeats:YES];
    }
        
    // Affiche la vue video+subtitles
    [self.view addSubview:myView];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self.moviePlayer
                                                    name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    
    // Register this class as an observer instead
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieEventFullscreenHandler:)
                                                 name:MPMoviePlayerWillEnterFullscreenNotification object:self.moviePlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(playMovie:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification object:self.moviePlayer];
    //[self.moviePlayer play];
}

#pragma mark Movie Notification

- (void)playMovie:(NSNotification *)notification {
    
    AVPlayer *player = notification.object;
    
    //if (player.loadState & MPMovieLoadStatePlayable)
    //{
        //NSLog(@"Movie is Ready to Play");
        [player play];
    //}
}

- (void)movieEventFullscreenHandler:(NSNotification*)notification {
    
    self.moviePlayer.view.frame = self.view.frame;

}

- (void)movieFinishedCallback:(NSNotification*)aNotification
{
    AVPlayerViewController *myMoviePlayer = [aNotification object];
    
    // Remove this class from the observers
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:myMoviePlayer];
    //[self.moviePlayer stop];
    
    // stop Timer
    [self.subtitleTimer invalidate];
    self.subtitleTimer = nil;
    
    // hide subtitles
    self.subtitleLabel.hidden = YES;
    
    // ask status bar to hide
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    
    // go back to detail view controller
    //[self.navigationController popViewControllerAnimated:YES];
    
}

// Subtitles
/*
-(void)updateSubtitles
{
    NSString *subTitleText;
    NSDate *initialDate = [self.srtParser initialTime];
    NSDate *currentTime = [initialDate dateByAddingTimeInterval:self.moviePlayer.currentPlaybackTime];
    
    subTitleText = [self.srtParser textForTime:currentTime];
    if (![subTitleText isEqualToString:self.subtitleLabel.text]) {
        self.subtitleLabel.text = subTitleText;
        //NSLog(@"text: %@", subTitleText);
    }
}
*/
// Orientation changed notification
- (void)orientationChanged:(NSNotification *)notification
{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    
    if ( UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {

        myView.frame =  self.view.bounds;
        self.moviePlayer.view.frame = myView.bounds;
        if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
            // Todo: adjust size for iPhone5
            CGSize deviceBounds = [[UIScreen mainScreen] bounds].size;
            self.subtitleLabel.frame = CGRectMake(0, 240, deviceBounds.height, 80);
            self.subtitleLabel.font = [UIFont fontWithName:@"Open Sans" size:22];
        } else {
            self.subtitleLabel.frame = CGRectMake(0, 380, 320, 60);
            self.subtitleLabel.font = [UIFont fontWithName:@"Open Sans" size:16];
        }
        
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    //[self.moviePlayer stop];
    
    // stop Timer
    [self.subtitleTimer invalidate];
    self.subtitleTimer = nil;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

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

@interface iPhoneVideoViewController () {

//    NSString *langueCourante;
    UIView *myView;
    NSURL *url;
    NSString *dataFile;
}

@property (nonatomic, retain) SrtParser *srtParser;
@property (nonatomic, retain) UILabel *subtitleLabel;
@property (nonatomic, retain) NSTimer *subtitleTimer;
@property (nonatomic, retain) MPMoviePlayerController *moviePlayer;

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
    
    // Language ?
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //NSArray *langues = [defaults objectForKey:@"AppleLanguages"];
    //langueCourante = [langues objectAtIndex:0];
    
    // Prepare video subtitles
    //if ([langueCourante isEqualToString:@"fr"] || [langueCourante isEqualToString:@"de"]) {
        // Parse subtitles
        NSString *srtPath = [[NSBundle mainBundle] pathForResource:self.detailItem.subTitles ofType:@"txt"];
        self.srtParser = [[SrtParser alloc] init];
        [self.srtParser parseSrtFileAtPath:srtPath];
    //}
    
    
    if (self.detailItem) {
        // where is video file to play ?
        NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsDir = dirPaths[0];
        
        // Build the path to the data file
        dataFile = [docsDir stringByAppendingPathComponent:
                    [self.detailItem.videofile stringByAppendingString:@".mp4"]];
    } else {
        dataFile = [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"Trailer_V4-mono.mp4"];
    }
    // URL to video to play
    url = [NSURL fileURLWithPath:dataFile];
    
	// setup video view and play
    [self prepareView];
}

-(void)prepareView {
    
    // A place for video player and subtitles
    myView =[[UIView alloc] initWithFrame:self.view.frame];
    
    // Movieplayer setup
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    self.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    self.moviePlayer.controlStyle =  MPMovieControlStyleDefault;
    self.moviePlayer.view.frame = myView.bounds;
    
    [self.moviePlayer prepareToPlay];
    
    [myView addSubview:self.moviePlayer.view];
    [self.moviePlayer setFullscreen:YES animated:YES];
    
    
    if (self.detailItem) {

        UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            // iPAD
            // Depending of the current orientation
            if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
                self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 240, 480, 40)];
                self.subtitleLabel.Font = [UIFont fontWithName:@"Open Sans" size:14];
            } else {
                self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 680, 700, 60)];
                self.subtitleLabel.Font = [UIFont fontWithName:@"Open Sans" size:16];
            }
        } else {
            // iPhone
            if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
                self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 240, 480, 40)];
                self.subtitleLabel.Font = [UIFont fontWithName:@"Open Sans" size:14];
            } else {
                self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 350, 320, 60)];
                self.subtitleLabel.Font = [UIFont fontWithName:@"Open Sans" size:12];
            }
        }
    
        // A place for subtitles
        self.subtitleLabel.numberOfLines = 2;
        self.subtitleLabel.backgroundColor = [UIColor whiteColor];
        self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
        self.subtitleLabel.textColor = [UIColor blackColor];
        [myView addSubview:self.subtitleLabel];
        
        // Register for Timer
        [self.subtitleTimer invalidate];
        self.subtitleTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateSubtitles) userInfo:self repeats:YES];
    }

        
    // Affiche la vue video+subtitles
    [self.view addSubview:myView];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self.moviePlayer
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:self.moviePlayer];
    
    // Register this class as an observer instead
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.moviePlayer];
}

- (void)movieFinishedCallback:(NSNotification*)aNotification
{
    MPMoviePlayerController *myMoviePlayer = [aNotification object];
    
    // Remove this class from the observers
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:myMoviePlayer];
    [self.moviePlayer stop];
    
    // stop Timer
    [self.subtitleTimer invalidate];
    self.subtitleTimer = nil;
    
    // hide subtitles
    self.subtitleLabel.hidden = YES;
    
}

// Subtitles

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

// Orientation changed notification
- (void)orientationChanged:(NSNotification *)notification
{
    myView.frame =  self.view.bounds;
    self.moviePlayer.view.frame = myView.bounds;
    
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // iPAD
        // Depending of the current orientation
        if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
            self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 240, 480, 40)];
            self.subtitleLabel.Font = [UIFont fontWithName:@"Open Sans" size:14];
        } else {
            self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 660, 700, 70)];
            self.subtitleLabel.Font = [UIFont fontWithName:@"Open Sans" size:16];
        }
    } else {
        // iPhone
        if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
            self.subtitleLabel.frame = CGRectMake(0, 240, 480, 40);
            self.subtitleLabel.Font = [UIFont fontWithName:@"Open Sans" size:14];
        } else {
            self.subtitleLabel.frame = CGRectMake(0, 350, 320, 60);
            self.subtitleLabel.Font = [UIFont fontWithName:@"Open Sans" size:12];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.moviePlayer stop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

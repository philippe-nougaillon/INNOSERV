//
//  DetailViewController.m
//  testSplitView
//
//  Created by philippe nougaillon on 05/02/13.
//  Copyright (c) 2013 philippe nougaillon. All rights reserved.
//

#import "DetailViewController.h"
#import "iPadMorePageViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "SrtParser.h"


@interface DetailViewController ()
{
    
    UIWebView *videoView;
    UIView *myView;
    NSString *langueCourante;
    
    __weak IBOutlet UILabel *detailSubtitle;
    __weak IBOutlet UIImageView *detailImage;
    __weak IBOutlet UITextView *detailInformation;
    __weak IBOutlet UIBarButtonItem *openWebPageButton;
    __weak IBOutlet UIButton *playVideoButton;
    
}
@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@property (nonatomic, retain) SrtParser *srtParser;
@property (nonatomic, retain) UILabel *subtitleLabel;
@property (nonatomic, retain) NSTimer *subtitleTimer;
@property (nonatomic, retain) MPMoviePlayerController *moviePlayer;


- (void)configureView;

@end


@implementation DetailViewController


#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {

        // remove video
        [myView removeFromSuperview];
        myView =nil;
        [self.subtitleTimer invalidate];
        [self.moviePlayer stop];

        // show selected project informations
        self.navigationItem.title = self.detailItem.title;
        detailSubtitle.text = self.detailItem.description;
        detailSubtitle.hidden = NO;
        NSString *imageFileName = [self.detailItem.image stringByAppendingString:@"-big.png"];
        detailImage.image = [UIImage imageNamed:imageFileName];

        // show project description and go on top of text
        detailInformation.text = self.detailItem.information;
        [detailInformation setContentOffset:CGPointMake(0.0, 0.0) animated:TRUE];
        
        // if website > show info button
        openWebPageButton.enabled = !([self.detailItem.website isEqualToString:@""]);
        
        // Prepare video subtitles
        if ([langueCourante isEqualToString:@"fr"]) {
            // Parse subtitles
            NSString *srtPath = [[NSBundle mainBundle] pathForResource:self.detailItem.subTitles ofType:@"txt"];
            self.srtParser = [[SrtParser alloc] init];
            [self.srtParser parseSrtFileAtPath:srtPath];
        }
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    // Localize
    openWebPageButton.title = NSLocalizedString(@"Website", @"");
 
    // Set fonts
    [detailSubtitle setFont:[UIFont fontWithName:@"Open Sans" size:18]];
    [detailInformation setFont:[UIFont fontWithName:@"Open Sans" size:14]];
   
    // Language ?
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *langues = [defaults objectForKey:@"AppleLanguages"];
    langueCourante = [langues objectAtIndex:0];
    
    if ([langueCourante isEqualToString:@"fr"]) {
        detailInformation.text = @"Plate-forme sur l'innovation dans les services sociaux\n\nLe projet a pour but d’évaluer la capacité future de services sociaux innovants à apporter une réponse pertinente aux besoins des citoyens, en tenant compte des activités multiformes des parties prenantes et des différents niveaux de gouvernance politique.\n\nCes projets ont été sélectionnés pour stimuler le débat sur l'innovation dans les services sociaux. Ils doivent être considérés comme des exemples d’idées innovantes, et non comme des guides de bonnes pratiques à suivre.";
    }
}

- (IBAction)playVideoButtonPushed:(id)sender
{
    NSURL *url;

    
    //NSLog(@"langue: %@",langueCourante);
    
    // Load subtitles for appropriate language
        
    // Setup video file
    NSString *videoFileName;
    // If current Detail page is about page or project page
    if (self.detailItem.videofile) {
        videoFileName = self.detailItem.videofile;
    } else {
        videoFileName = @"Trailer_V4";
    }
    url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:videoFileName ofType:@"mp4"]];

    // A place for video player and subtitles
    myView =[[UIView alloc] initWithFrame:CGRectMake(20, 108, 663, 380)];

    // Movieplayer setup
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    self.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    self.moviePlayer.view.frame = myView.bounds;
    
    [myView addSubview:self.moviePlayer.view];
    [self.moviePlayer setFullscreen:NO animated:NO];
        
    if ([langueCourante isEqualToString:@"fr"] && self.detailItem.subTitles) {
        // A place for subtitles
        self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, 663, 40)];
        self.subtitleLabel.backgroundColor = [UIColor whiteColor];
        self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
        self.subtitleLabel.Font = [UIFont fontWithName:@"Open Sans" size:14];
        self.subtitleLabel.textColor = [UIColor blackColor];
        [myView addSubview:self.subtitleLabel];
  
        // Register for Timer
        [self.subtitleTimer invalidate];
        self.subtitleTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateSubtitles) userInfo:self repeats:YES];
    }

    // Affiche la vue video+subtitles
    [self.view addSubview:myView];
    
    // unsubcribe notification
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
    // Obtain the reason why the movie playback finished
    //NSNumber *finishReason = [[aNotification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    // Dismiss the view controller ONLY when the reason is not "playback ended"
    //if ([finishReason intValue] != MPMovieFinishReasonPlaybackEnded)
    //{
        MPMoviePlayerController *myMoviePlayer = [aNotification object];
        
        // Remove this class from the observers
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:myMoviePlayer];
        
        [self.moviePlayer stop];
        
        [myView removeFromSuperview];
        myView =nil;
    
        [self.subtitleTimer invalidate];
        self.subtitleTimer = nil;
    //}
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


// This will get called too before the view appears
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"openiPadWebView"]) {
        
        // Get destination view
        iPadMorePageViewController *vc = [segue destinationViewController];
        
        // Pass the information to your destination view
        vc.detailItem = self.detailItem;
    }
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

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end

//
//  DetailViewController.m
//  testSplitView
//
//  Created by philippe nougaillon on 05/02/13.
//  Copyright (c) 2013 philippe nougaillon. All rights reserved.
//

#import "DetailViewController.h"
#import "iPhoneVideoViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "SrtParser.h"


@interface DetailViewController ()
{
    UIWebView *videoView;
    UIView *myView;
    NSString *langueCourante;

    NSMutableData *activeDownload;
    NSURLConnection *conn;
    NSFileManager *filemgr;
    NSString *dataFile;
    float _totalFileSize;
    float _receivedDataBytes;

    __weak IBOutlet UIProgressView *myProgressBar;
    __weak IBOutlet UILabel *detailSubtitle;
    __weak IBOutlet UIImageView *detailImage;
    __weak IBOutlet UITextView *detailInformation;
    __weak IBOutlet UIBarButtonItem *openWebPageButton;
    __weak IBOutlet UIButton *playVideoButton;
    __weak IBOutlet UIButton *buttonAboutProject;
    __weak IBOutlet UIButton *buttonWatchTrailer;
    __weak IBOutlet UIButton *buttonOpenWebsite;
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
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    
    if ([identifier isEqualToString:@"openVideo"]) {
        
        // check if video file exist
        filemgr = [NSFileManager defaultManager];
        NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsDir = dirPaths[0];
        
        // Build the path to the data file
        dataFile = [docsDir stringByAppendingPathComponent:
                    [self.detailItem.videofile stringByAppendingString:@".mp4"]];
        
        // Check if the video not exist and then download it
        if (![filemgr fileExistsAtPath: dataFile])
        {
            // init file data container
            activeDownload = [[NSMutableData alloc] init];
            
            //labelDownloadingVideo.hidden = NO;
            myProgressBar.hidden = NO;
            //playButton.hidden = YES;
            //[labelDownloadingVideo setText:NSLocalizedString(@"Downloading video", @"")];
            
            // the video file to download
            NSString *fileURL = [@"http://www.inno-serv.eu/sites/default/files/videos-iphone/" stringByAppendingString:self.detailItem.videofile];
            fileURL = [fileURL stringByAppendingString:@".mp4"];
            
            // create the web request
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            NSURL *url = [[NSURL alloc] initWithString:fileURL];
            [request setURL:url];
            
            // open Connection
            conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            return FALSE;
        } else {
            return TRUE;
        }
    }
    return TRUE;
}


// This will get called too before the view appears
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"openVideo"]) {
        
        // Get destination view
        iPhoneVideoViewController *vc = [segue destinationViewController];
        
        // Pass the information to your destination view
        vc.detailItem = self.detailItem;
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _totalFileSize = response.expectedContentLength;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    _receivedDataBytes += [data length];
    myProgressBar.progress = _receivedDataBytes / (float)_totalFileSize;

    [activeDownload appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    // write file into app Documents dir
    [activeDownload writeToFile:dataFile atomically:YES];
    
    // update interface
    myProgressBar.hidden = YES;
    //labelDownloadingVideo.hidden = YES;
    //playButton.hidden = NO;
    
    activeDownload = nil;
    conn = nil;
    
    // run the video
    [self performSegueWithIdentifier: @"openVideo" sender: self];
    
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

//
//  iPhoneDetailViewController.m
//  Innoserv
//
//  Created by philippe nougaillon on 09/04/13.
//  Copyright (c) 2013 philippe nougaillon. All rights reserved.
//

#import "iPhoneDetailViewController.h"


@interface iPhoneDetailViewController ()
{
    NSString *langueCourante;
    
    __weak IBOutlet UILabel *projectSubTiltle;
    __weak IBOutlet UITextView *projectInformation;
    __weak IBOutlet UIImageView *projectImage;
    __weak IBOutlet UIProgressView *myProgressBar;
    __weak IBOutlet UILabel *labelDownloadingVideo;
    __weak IBOutlet UIButton *playButton;
    __weak IBOutlet UIBarButtonItem *openWebsiteButton;
    
    NSMutableData *activeDownload;
    NSURLConnection *conn;
    NSFileManager *filemgr;
    NSString *dataFile;
    float _totalFileSize;
    float _receivedDataBytes;
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
    
	// Do any additional setup after loading the view.
    if (self.detailItem) {
        // set project values
        projectSubTiltle.text = self.detailItem.description;
        projectInformation.text = self.detailItem.information;
        
        // project image
        NSString *imageFileName = [self.detailItem.image stringByAppendingString:@"-big.png"];
        projectImage.image = [UIImage imageNamed:imageFileName];
        [openWebsiteButton setEnabled:![self.detailItem.website isEqualToString:@""]];
        
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
        if (![filemgr fileExistsAtPath: dataFile]) {
            // init file data container
            activeDownload = [[NSMutableData alloc] init];
            
            labelDownloadingVideo.hidden = NO;
            myProgressBar.hidden = NO;
            playButton.hidden = YES;
            [labelDownloadingVideo setText:NSLocalizedString(@"Downloading video", @"")];

            // the video file to download
            // http://innoserv.philnoug.com/videos-iphone/
            // http://www.inno-serv.eu/sites/default/files/videos-iphone/
            NSString *fileURL = [@"http://innoserv.philnoug.com/videos-iphone/" stringByAppendingString:self.detailItem.videofile];
            fileURL = [fileURL stringByAppendingString:@".mp4"];
            
            // create the web request
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            NSURL *url = [[NSURL alloc] initWithString:fileURL];
            [request setURL:url];

            // open Connection
            conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];

            if (!conn) {
                // Inform the user that the connection failed.
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"INNOSERV"
                                               message:NSLocalizedString(@"networkError", @"")
                                               preferredStyle:UIAlertControllerStyleAlert];
                 
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                   handler:^(UIAlertAction * action) {}];
                 
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
                
            } else {
                myProgressBar.hidden = NO;
                playButton.hidden = YES;
            }
            return FALSE;
        } else {
            return TRUE;        
        }
    }
    return TRUE;
}

- (IBAction)openWebsite:(id)sender {
    
    NSString* link = self.detailItem.website;
    
    if (![link isEqualToString:@""]) {
        // open webpage
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link] options:@{} completionHandler:^(BOOL success) {}];
    }
    
}

// This will get called too before the view appears
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"openVideo"]) {
        
        // Get destination view
        iPhoneDetailViewController *vc = [segue destinationViewController];
        
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
    labelDownloadingVideo.hidden = YES;
    playButton.hidden = NO;
    
    activeDownload = nil;
    conn = nil;
    
    // run the video
    [self performSegueWithIdentifier: @"openVideo" sender: self];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (void)viewDidUnload {
    [self setTitle:nil];
    [super viewDidUnload];
}
*/
 
@end

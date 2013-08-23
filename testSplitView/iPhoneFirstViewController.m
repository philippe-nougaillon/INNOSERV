//
//  iPhoneFirstViewController.m
//  Innoserv
//
//  Created by philippe nougaillon on 26/02/13.
//  Copyright (c) 2013 philippe nougaillon. All rights reserved.
//

#import "iPhoneFirstViewController.h"
#import "iPhoneDetailViewController.h"
#import "ProjectData.h"
#import "ProjectDataFR.h"
#import "ProjectListItem.h"
#import "CustomCell.h"
#import <MediaPlayer/MediaPlayer.h>

@interface iPhoneFirstViewController ()
{
    NSArray *_items;
    ProjectListItem *selectedProject;
    MPMoviePlayerViewController *_player;
    NSString *langueCourante;

    __weak IBOutlet UIBarButtonItem *aboutButton;
    __weak IBOutlet UIBarButtonItem *trailerButton;
}
@end

@implementation iPhoneFirstViewController

- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //_items = [[ProjectData alloc] init];
    
    aboutButton.title = NSLocalizedString(@"About", @"");
    trailerButton.title = NSLocalizedString(@"Trailer", @"");
    
    // Language ?
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *langues = [defaults objectForKey:@"AppleLanguages"];
    langueCourante = [langues objectAtIndex:0];
    
    //NSLog(@"langue: %@",langueCourante);
    
    // Load items for appropriate language
    if ([langueCourante isEqualToString:@"fr"]) {
        _items = [[ProjectDataFR alloc] init];
    } else {
        _items = [[ProjectData alloc] init];
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
    return ((interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) );
}

- (IBAction)openPdfToolbarButtonPressed:(id)sender {
}

- (IBAction)openTrailerButtonPressed:(id)sender {

    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:@"Trailer_V4" ofType:@"mp4"]];
    
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


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:@"MyCustomCell"];
    
    ProjectListItem *item = _items[indexPath.row];
    cell.titleLabel.text = item.title;
    cell.subTitleLabel.text = item.description;
    
    cell.image.image = [UIImage imageNamed:[item.image stringByAppendingString:@".png"]];
    
    [cell.titleLabel setFont:[UIFont fontWithName:@"Open Sans" size:16]];
    [cell.subTitleLabel setFont:[UIFont fontWithName:@"Open Sans" size:14]];
     
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedProject = _items[indexPath.row];
    
    [self performSegueWithIdentifier:@"openDetailView" sender:self];
    
}

// This will get called too before the view appears
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"openDetailView"]) {
        
        // Get destination view
        iPhoneDetailViewController *vc = [segue destinationViewController];
        
        // Pass the information to your destination view
        vc.detailItem = selectedProject;
        vc.navigationItem.title = selectedProject.title;
    }
}

@end

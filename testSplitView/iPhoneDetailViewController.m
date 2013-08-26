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
    
    __weak IBOutlet UIBarButtonItem *openWebPageToolBarButton;
    __weak IBOutlet UILabel *projectSubTiltle;
    __weak IBOutlet UITextView *projectInformation;
    __weak IBOutlet UIImageView *projectImage;
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
    }
}

- (IBAction)openWebPagePressed:(id)sender {
    
    if (self.detailItem) {
        
        NSString *webPageLink = self.detailItem.website;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webPageLink]];
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
        vc.navigationItem.title = self.detailItem.title;
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

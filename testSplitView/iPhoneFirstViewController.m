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
#import "ProjectDataDE.h"
#import "ProjectListItem.h"
#import "CustomCell.h"

@interface iPhoneFirstViewController ()
{
    ProjectListItem *selectedProject;
    NSArray *_items;
    NSString *langueCourante;
    IBOutlet UITableView *projectsTableView;
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
    
    self.navigationItem.title = NSLocalizedString(@"20SelectedProjects", @"");
    
    // Language ?
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *langues = [defaults objectForKey:@"AppleLanguages"];
    langueCourante = [langues objectAtIndex:0];
    
    //NSLog(@"langue: %@",langueCourante);
    
    // Load items for appropriate language
    if ([langueCourante isEqualToString:@"fr"]) {
        _items = [[ProjectDataFR alloc] init];
    } else if ([langueCourante isEqualToString:@"de"]) {
        _items = [[ProjectDataDE alloc] init];
    } else {
        _items = [[ProjectData alloc] init];
    }
}

- (IBAction)backToMenuButtonTapped:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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

// block orientation to portrait
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    // set color of Field of services
    if (item.fieldOfWelfare) {
        [cell.fieldOfServiceLabel setTextColor:[UIColor greenColor]];
    } else if (item.fieldOfHealth) {
        [cell.fieldOfServiceLabel setTextColor:[UIColor redColor]];
    } else if (item.fieldOfEducation) {
        [cell.fieldOfServiceLabel setTextColor:[UIColor yellowColor]];
    }
    
    // show Field of services
    NSString *fos = @"";
    if (item.fieldOfWelfare) {
        fos = [fos stringByAppendingString:NSLocalizedString(@"Welfare",nil)];
    }
    if (item.fieldOfHealth) {
        if (fos.length > 0)
            fos = [fos stringByAppendingString:@", "];
        fos = [fos stringByAppendingString:NSLocalizedString(@"Health",nil)];
    }
    if (item.fieldOfEducation) {
        if (fos.length > 0)
            fos = [fos stringByAppendingString:@", "];
        fos = [fos stringByAppendingString:NSLocalizedString(@"Education",nil)];
    }
    cell.fieldOfServiceLabel.text = fos;

    //[cell.titleLabel setFont:[UIFont fontWithName:@"Open Sans" size:25]];
    //[cell.subTitleLabel setFont:[UIFont fontWithName:@"Open Sans" size:17]];
    //[cell.fieldOfServiceLabel setFont:[UIFont fontWithName:@"Open Sans" size:12]];
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedProject = _items[indexPath.row];
    [self performSegueWithIdentifier:@"openDetailView" sender:self];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

    // test if at top or end of projects list
    if (indexPath.row == _items.count -1 || indexPath.row == 0)
    {
       // if Navigation Bar is already hidden
        if (self.navigationController.navigationBar.hidden == YES)
        {
            // Show the Navigation Bar
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }
    } else {
        // check if the Navigation Bar is shown
        if (self.navigationController.navigationBar.hidden == NO)
        {
            // hide the Navigation Bar
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
    }
}


@end

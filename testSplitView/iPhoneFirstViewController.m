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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeButtonTapped:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    [cell.titleLabel setFont:[UIFont fontWithName:@"Open Sans" size:22]];
    [cell.subTitleLabel setFont:[UIFont fontWithName:@"Open Sans" size:18]];
     
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

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}


@end

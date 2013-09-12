//
//  MasterViewController.m
//  testSplitView
//
//  Created by philippe nougaillon on 05/02/13.
//  Copyright (c) 2013 philippe nougaillon. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "ProjectData.h"
#import "ProjectDataFR.h"
#import "ProjectDataDE.h"
#import "ProjectListItem.h"

@interface MasterViewController ()
{
    NSArray *_items;
    NSString *langueCourante;

    __weak IBOutlet UIBarButtonItem *aboutButton;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // localize view
    aboutButton.title = NSLocalizedString(@"About", @"");
    
    // allocate detailViewController
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];

    // Language ?
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *langues = [defaults objectForKey:@"AppleLanguages"];
    langueCourante = [langues objectAtIndex:0];
    
    //NSLog(@"langue: %@",langueCourante);
    
    // Load items for appropriate language
    if ([langueCourante isEqualToString:@"fr"]) {
        
        self.title = @"20 projets INNOSERV";
        /*
        // Afiche un titre en 2 lignes
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 2;
        label.font = [UIFont fontWithName:@"Open Sans" size:14];
        label.shadowColor = [UIColor colorWithWhite:0.0 alpha:1];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.text = @"Une sélection de 20 projets INNOSERV en vidéo";
        self.navigationItem.titleView = label;
        self.detailViewController.title = @"Présentation du projet INNOSERV";
         */
        
        _items = [[ProjectDataFR alloc] init];
    }
    else if ([langueCourante isEqualToString:@"de"]) {
        //de
        _items = [[ProjectDataDE alloc] init];
    }
    else {
        // load Data for English
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
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight));
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
    // Configure the cell...

    static NSString *CellIdentifier = @"MyCustomCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    ProjectListItem *item = _items[indexPath.row];
    
    UILabel *projectTitleLabel = (UILabel *)[cell viewWithTag:100];
    projectTitleLabel.text = item.title;
    
    UIImageView *projectImageView = (UIImageView *)[cell viewWithTag:101];
    projectImageView.image = [UIImage imageNamed:[item.image stringByAppendingString:@".png"]];
    
    UILabel *projectSubTitleLabel = (UILabel *)[cell viewWithTag:102];
    projectSubTitleLabel.text = item.description;

    UILabel *fieldOfServiceLabel = (UILabel *)[cell viewWithTag:103];
    
    // set color of Field of services
    if (item.fieldOfWelfare) {
        [fieldOfServiceLabel setTextColor:[UIColor greenColor]];
    } else if (item.fieldOfHealth) {
        [fieldOfServiceLabel setTextColor:[UIColor redColor]];
    } else if (item.fieldOfEducation) {
        [fieldOfServiceLabel setTextColor:[UIColor yellowColor]];
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
    fieldOfServiceLabel.text = fos;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectListItem *object = _items[indexPath.row];
    self.detailViewController.detailItem = object;
    
    //stop the video
    // if videoView in the stack ?
    int navControllers = [[self.detailViewController.navigationController viewControllers] count];

    if (navControllers == 2){
        [self.detailViewController.navigationController popViewControllerAnimated:YES];
        //NSLog(@"%d", navControllers);
    }
    
}

@end

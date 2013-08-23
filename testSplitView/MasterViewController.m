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
#import "ProjectListItem.h"
#import "CustomCell.h"

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
        _items = [[ProjectDataFR alloc] init];
        self.title = @"Vidéos INNOSERV";
        
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

    }
    else if ([langueCourante isEqualToString:@"de"]) {
        //de
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
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:@"MyCustomCell"];
    
    ProjectListItem *item = _items[indexPath.row];
    cell.titleLabel.text = item.title;
    cell.subTitleLabel.text = item.description;

    cell.image.image = [UIImage imageNamed:[item.image stringByAppendingString:@".png"]];
    
    [cell.titleLabel setFont:[UIFont fontWithName:@"Open Sans" size:18]];
    [cell.subTitleLabel setFont:[UIFont fontWithName:@"Open Sans" size:13]];
    
    // Change la couleur de la cellule quand selectionnée
    
    //UIView *selectionColor = [[UIView alloc] init];
    //selectionColor.backgroundColor = [UIColor colorWithRed:(252/255.0) green:(243/255.0) blue:(193/255.0) alpha:1];
    //cell.selectedBackgroundView = selectionColor;
    //selectionColor = nil;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectListItem *object = _items[indexPath.row];
    self.detailViewController.detailItem = object;
}

@end

//
//  AboutPagesIPAD2ViewController.m
//  Innoserv
//
//  Created by philippe nougaillon on 12/09/13.
//  Copyright (c) 2013 philippe nougaillon. All rights reserved.
//

#import "AboutPagesIPAD2ViewController.h"

@interface AboutPagesIPAD2ViewController ()

@end

@implementation AboutPagesIPAD2ViewController

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
}

- (IBAction)doneButton:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  iPadMorePageViewController.h
//  Innoserv
//
//  Created by philippe nougaillon on 24/04/13.
//  Copyright (c) 2013 philippe nougaillon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectListItem.h"

@interface iPadMorePageViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) ProjectListItem *detailItem;

@end

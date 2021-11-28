//
//  iPadAboutViewController.h
//  Innoserv
//
//  Created by philippe nougaillon on 24/04/13.
//  Copyright (c) 2013 philippe nougaillon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "ProjectListItem.h"

@interface iPadAboutViewController : UIViewController <WKUIDelegate>

@property (strong, nonatomic) ProjectListItem *detailItem;

@end

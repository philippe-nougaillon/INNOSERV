//
//  AppData.m
//  testSplitView
//
//  Created by philippe nougaillon on 05/02/13.
//  Copyright (c) 2013 philippe nougaillon. All rights reserved.
//

#import "ProjectListItem.h"

@implementation ProjectListItem

@synthesize title =_title;
@synthesize description = _description;
@synthesize image = _image;
@synthesize information = _information;
@synthesize website = _website;
@synthesize videofile = _videofile;
@synthesize subTitles = _subTitles;

- (ProjectListItem *)initWithValues:(NSString *)title description:(NSString *)description image:(NSString *)image information:(NSString  *)information website:(NSString *)website videofile:(NSString *)videofile subTitles:(NSString *)subTitles
{
    _title = title;
    _description = description;
    _image = image;
    _information = information;
    _website = website;
    _videofile = videofile;
    _subTitles = subTitles;
    
    return self;
}

@end

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
@synthesize fieldOfEducation = _fieldOfEducation;
@synthesize fieldOfWelfare = _fieldOfWelfare;
@synthesize fieldOfHealth = _fieldOfHealth;


- (ProjectListItem *)initWithValues:(NSString *)title description:(NSString *)description image:(NSString *)image information:(NSString  *)information website:(NSString *)website videofile:(NSString *)videofile subTitles:(NSString *)subTitles fieldOfEducation:(BOOL)fieldOfEducation fieldOfWelfare:(BOOL)fieldOfWelfare fieldOfHealth:(BOOL)fieldOfHealth;

{
    _title = title;
    _description = description;
    _image = image;
    _information = information;
    _website = website;
    _videofile = videofile;
    _subTitles = subTitles;
    _fieldOfEducation = fieldOfEducation;
    _fieldOfWelfare = fieldOfWelfare;
    _fieldOfHealth = fieldOfHealth;

    
    return self;
}

@end

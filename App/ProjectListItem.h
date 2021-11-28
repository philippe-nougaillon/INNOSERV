//
//  AppData.h
//  testSplitView
//
//  Created by philippe nougaillon on 05/02/13.
//  Copyright (c) 2013 philippe nougaillon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectListItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *information;
@property (nonatomic, strong) NSString *website;
@property (nonatomic, strong) NSString *videofile;
@property (nonatomic, strong) NSString *subTitles;
@property BOOL fieldOfEducation;
@property BOOL fieldOfWelfare;
@property BOOL fieldOfHealth;

- (ProjectListItem *)initWithValues:(NSString *)title
                        description:(NSString *)description
                              image:(NSString *)image
                        information:(NSString *)information
                            website:(NSString *)website
                          videofile:(NSString *)videofile
                          subTitles:(NSString *)subTitles
                   fieldOfEducation:(BOOL)fieldOfEducation
                     fieldOfWelfare:(BOOL)fieldOfWelfare
                      fieldOfHealth:(BOOL)fieldOfHealth;

@end





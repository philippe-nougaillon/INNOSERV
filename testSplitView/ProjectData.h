//
//  ProjectData.h
//  Innoserv
//
//  Created by philippe nougaillon on 19/08/13.
//  Copyright (c) 2013 philippe nougaillon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectData : NSArray

@property (strong, nonatomic) NSArray *informations;

-(ProjectData *)initWithLanguageCode:(NSString *)lang;

@end

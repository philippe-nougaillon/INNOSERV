//
//  SrtData.h
//  YSLv2
//
//  Created by Martin Krasnočka on 3/30/13.
//
//

#import <Foundation/Foundation.h>

@interface SrtData : NSObject
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic) NSInteger index;
@end

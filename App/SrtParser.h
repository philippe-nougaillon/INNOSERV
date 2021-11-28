//
//  SrtParser.h
//  YSLv2
//
//  Created by Martin Krasnočka on 3/30/13.
//
//

#import <Foundation/Foundation.h>

@interface SrtParser : NSObject
-(void)parseSrtFileAtPath:(NSString *)path;
-(NSString *)textForTime:(NSDate *)time;
-(NSDate *)initialTime;
@end

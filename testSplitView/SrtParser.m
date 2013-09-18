//
//  SrtParser.m
//  YSLv2
//
//  Created by Martin Krasnočka on 3/30/13.
//
//

#import "SrtParser.h"
#import "SrtData.h"

@interface SrtParser ()
@property (nonatomic, strong) NSMutableArray *srtDataArray;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end


@implementation SrtParser

-(id)init
{
    self = [super init];
    if (self) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"HH:mm:ss,SSS"];
    }
    return self;
}

-(void)parseSrtFileAtPath:(NSString *)path
{
    self.srtDataArray = [NSMutableArray array];
    NSError *error = nil;
    NSString *string = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];

    if (error) {
        //NSLog(@"%@", [error description]);
    }

    NSScanner *scanner = [NSScanner scannerWithString:string];

    while (![scanner isAtEnd])
    {
        @autoreleasepool
        {
            NSString *indexString;
            (void) [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&indexString];

            NSString *startString;
            (void) [scanner scanUpToString:@" --> " intoString:&startString];

            // My string constant doesn't begin with spaces because scanners
            // skip spaces and newlines by default.
            (void) [scanner scanString:@"-->" intoString:NULL];

            NSString *endString;
            (void) [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&endString];

            NSString *textString;
            (void) [scanner scanUpToString:@"\r" intoString:&textString];
            textString = [textString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];

            // Addresses trailing space added if CRLF is on a line by itself at the end of the SRT file
            textString = [textString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

            SrtData *srtData = [[SrtData alloc] init];
            srtData.text = textString;
            srtData.startDate = [self.dateFormatter dateFromString:startString];
            srtData.endDate = [self.dateFormatter dateFromString:endString];
            srtData.index = [indexString integerValue];

            [self.srtDataArray addObject:srtData];
            
            //NSLog(@"%i", self.srtDataArray.count);
        }
    }
}

-(NSString *)textForTime:(NSDate *)time
{
    for (SrtData *srtData in self.srtDataArray) {
        if ([time compare:srtData.startDate] == NSOrderedDescending && [time compare:srtData.endDate] == NSOrderedAscending) {
            return srtData.text;
        }
    }
    return nil;
}

-(NSDate *)initialTime
{
    return [self.dateFormatter dateFromString:@"00:00:00,000"];
}

@end

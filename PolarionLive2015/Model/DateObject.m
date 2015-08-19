//
//  DateObject.m
//  Polarion Live
//
//  Created by Scott Richards on 10/1/14.
//  Copyright (c) 2014 Scott Richards. All rights reserved.
//

#import "DateObject.h"

@implementation DateObject

@class SessionInfo;

- (id)initWithDate:(NSDate *)date andString:(NSString *)displayName
{
    self = [super init];
    if (self) {
        self.date = date;
        self.dateString = displayName;
        self.sessions = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addSession:(SessionInfo *)session
{
    [self.sessions addObject:session];
}
@end

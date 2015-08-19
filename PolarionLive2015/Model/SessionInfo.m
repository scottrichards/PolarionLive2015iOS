//
//  SessionInfo.m
//  Polarion Live
//
//  Created by Scott Richards on 10/1/14.
//  Copyright (c) 2014 Scott Richards. All rights reserved.
//

#import "SessionInfo.h"
#import <Parse/PFObject+Subclass.h>

@implementation SessionInfo
@dynamic displayTime;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Agenda";
}

@end

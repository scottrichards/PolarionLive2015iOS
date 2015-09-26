//
//  SessionRating.m
//  Polarion Live
//
//  Created by Scott Richards on 10/1/14.
//  Copyright (c) 2014 Scott Richards. All rights reserved.
//

#import "SessionRating.h"
#import <Parse/PFObject+Subclass.h>

@implementation SessionRating
@dynamic contentRating;
@dynamic presenterRating;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"SessionRating";
}
@end

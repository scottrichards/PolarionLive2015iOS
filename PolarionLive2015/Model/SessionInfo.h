//
//  SessionInfo.h
//  Polarion Live
//
//  Created by Scott Richards on 10/1/14.
//  Copyright (c) 2014 Scott Richards. All rights reserved.
//

#import <Parse/Parse.h>

@interface SessionInfo : PFObject <PFSubclassing>
+ (NSString *)parseClassName;

@property (retain) NSString *displayTime;
@end

//
//  AgendaItem.h
//  PolarionLive2015
//
//  Created by Scott Richards on 9/1/15.
//  Copyright (c) 2015 Scott Richards. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface AgendaItem : NSObject
@property (strong, nonatomic) NSString *sessionName;
@property (strong, nonatomic) NSString *sessionDescription;
@property (strong, nonatomic) NSString *presenter;
@property (strong, nonatomic) NSString *displayTime;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *icon;
@property (strong, nonatomic) NSDate *start;
@property (strong, nonatomic) NSDate *end;
+ (id)initWithPFObject:(PFObject *)object;
@end

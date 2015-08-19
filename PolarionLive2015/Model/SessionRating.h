//
//  SessionRating.h
//  Polarion Live
//
//  Created by Scott Richards on 10/1/14.
//  Copyright (c) 2014 Scott Richards. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>

@interface SessionRating : PFObject<PFSubclassing>
@property (retain) NSNumber *contentRating;
@property (retain) NSNumber *presenterRating;
@end

//
//  SessionDetailsViewController.h
//  PolarionLive2015
//
//  Created by Scott Richards on 8/20/15.
//  Copyright (c) 2015 Scott Richards. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SessionInfo.h"

@class AgendaItem;

@interface SessionDetailsViewController : UIViewController 
@property (strong, nonatomic) AgendaItem *agendaItem;
@end

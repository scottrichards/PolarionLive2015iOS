//
//  AgendaItem.m
//  PolarionLive2015
//
//  Created by Scott Richards on 9/1/15.
//  Copyright (c) 2015 Scott Richards. All rights reserved.
//

#import "AgendaItem.h"

@implementation AgendaItem
+ (id)initWithPFObject:(PFObject *)object
{
  AgendaItem *agendaItem = [AgendaItem new];
  if (agendaItem) {
    agendaItem.sessionName = object[@"session"];
    agendaItem.sessionDescription = object[@"description"];
    agendaItem.displayTime = object[@"displayTime"];
    agendaItem.presenter = object[@"presenter"];
    agendaItem.start = object[@"start"];
    agendaItem.end = object[@"end"];
    agendaItem.icon = object[@"icon"];
    agendaItem.location = object[@"location"];
    agendaItem.pfObject = object;   // point back to the original session object
  }
  return agendaItem;
}
@end

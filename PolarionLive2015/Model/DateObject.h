//
//  DateObject.h
//  Polarion Live
//
//  Created by Scott Richards on 10/1/14.
//  Copyright (c) 2014 Scott Richards. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PFObject;
@class SessionInfo;
@class AgendaItem;

@interface DateObject : NSObject
@property (strong, nonatomic) NSString *dateString;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSMutableArray *sessions;
@property (strong, nonatomic) NSMutableArray *agendaItems;

- (id)initWithDate:(NSDate *)date andString:(NSString *)displayName;
- (void)addSession:(SessionInfo *)session;
- (void)addAgendaItem:(AgendaItem *)item;
@end

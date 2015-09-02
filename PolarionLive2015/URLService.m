//
//  URLService.m
//  Polarion Live
//
//  Created by Scott Richards on 10/3/14.
//  Copyright (c) 2014 Scott Richards. All rights reserved.
//

#import "URLService.h"
#import "AppDelegate.h"

static NSString *BASE_URL = @"http://54.183.27.217/";

@implementation URLService
+ (NSString *)buildURLWithString:(NSString *)string
{
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@",BASE_URL,string];
    return fullUrl;
}
@end

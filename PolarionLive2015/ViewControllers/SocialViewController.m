//
//  SocialViewController.m
//  PolarionLive2015
//
//  Created by Scott Richards on 8/31/15.
//  Copyright (c) 2015 Scott Richards. All rights reserved.
//

#import "SocialViewController.h"
#import <Social/Social.h>

@interface SocialViewController ()

@end

@implementation SocialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onFacebookPost:(id)sender {
  if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    [controller setInitialText:@"Meeting great people at Polarion Live 2015!"];
    [self presentViewController:controller animated:YES completion:Nil];
  }
}

- (IBAction)onTweet:(id)sender {
  if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
  {
    SLComposeViewController *tweetSheet = [SLComposeViewController
                                           composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweetSheet setInitialText:@"Learning lots at Polarion Live 2015!"];
    [self presentViewController:tweetSheet animated:YES completion:nil];
  }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  PartnerViewController.m
//  PolarionLive2015
//
//  Created by Scott Richards on 8/20/15.
//  Copyright (c) 2015 Scott Richards. All rights reserved.
//

#import "PartnerViewController.h"

static NSString *partnerURL =  @"http://54.183.27.217/partners.php";
@interface PartnerViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation PartnerViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self loadURL:partnerURL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadURL:(NSString *)urlAddress
{
  NSURL *url = [NSURL URLWithString:urlAddress];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  
  [_webview loadRequest:request];
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

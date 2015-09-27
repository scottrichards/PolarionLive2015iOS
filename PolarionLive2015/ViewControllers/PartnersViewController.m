//
//  PartnersViewController.m
//  PolarionLive2015
//
//  Created by Scott Richards on 9/26/15.
//  Copyright (c) 2015 Scott Richards. All rights reserved.
//

#import "PartnersViewController.h"
#import "URLService.h"

@interface PartnersViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

static NSString *oldPartnerURL =  @"http://54.183.27.217/partners.php";
static NSString *partnerURL =  @"2015m/partners/index.html";

@implementation PartnersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadURL:[URLService buildURLWithString:partnerURL]];
//  [self loadURL:oldPartnerURL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  _webView.scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)loadURL:(NSString *)urlAddress
{
  NSURL *url = [NSURL URLWithString:urlAddress];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  
  [_webView loadRequest:request];
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

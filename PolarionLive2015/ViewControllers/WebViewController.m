//
//  WebViewController.m
//  PolarionLive2015
//
//  Created by Scott Richards on 8/31/15.
//  Copyright (c) 2015 Scott Richards. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadURL:_urlToLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  if (self.titleText.length > 0) {
    self.navigationItem.title = self.titleText;
  }
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadURL:(NSString *)urlAddress
{
  NSURL *url = [NSURL URLWithString:urlAddress];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  
  [self.webView loadRequest:request];
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

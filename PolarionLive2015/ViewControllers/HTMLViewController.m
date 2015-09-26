//
//  HTMLViewController.m
//  PolarionLive2015
//
//  Created by Scott Richards on 9/23/15.
//  Copyright (c) 2015 Scott Richards. All rights reserved.
//

#import "HTMLViewController.h"

@interface HTMLViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation HTMLViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self loadURL:_urlToLoad];
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

@end

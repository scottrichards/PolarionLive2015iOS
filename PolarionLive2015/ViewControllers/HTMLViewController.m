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
//  self.automaticallyAdjustsScrollViewInsets = NO;
//  NSLog(@"_webView.frame.origin.y %f",_webView.frame.origin.y);
//  CGRect webViewFrameRect = _webView.frame;
//  webViewFrameRect.origin.y = 0;
//  [_webView setFrame:webViewFrameRect];
//  NSLog(@"_webView.frame.origin.y %f",_webView.frame.origin.y);
//  NSLog(@"_webView.scrollView.contentInset %f",_webView.scrollView.contentInset.top);
  _webView.scrollView.contentInset = UIEdgeInsetsZero;
  [self loadURL:_urlToLoad];
}


- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  _webView.scrollView.contentInset = UIEdgeInsetsZero;
//  _webView.scrollView.contentInset = UIEdgeInsetsZero;
//  NSLog(@"_webView.frame.origin.y %f",_webView.frame.origin.y);
//  CGRect webViewFrameRect = _webView.frame;
//  webViewFrameRect.origin.y = 0;
//  [_webView setFrame:webViewFrameRect];
//  NSLog(@"_webView.frame.origin.y %f",_webView.frame.origin.y);
//  NSLog(@"_webView.scrollView.contentInset %f",_webView.scrollView.contentInset.top);
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

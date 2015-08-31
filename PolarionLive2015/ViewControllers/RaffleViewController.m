//
//  RaffleViewController.m
//  PolarionLive2015
//
//  Created by Scott Richards on 8/31/15.
//  Copyright (c) 2015 Scott Richards. All rights reserved.
//

#import "RaffleViewController.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"

@interface RaffleViewController ()
@property (weak, nonatomic) IBOutlet UITextView *testimonialView;
@property (weak, nonatomic) IBOutlet UISwitch *usageConsent;

@end

@implementation RaffleViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _testimonialView.layer.borderWidth = 1.0f;
  _testimonialView.layer.cornerRadius = 8;
  _testimonialView.layer.borderColor = [[UIColor grayColor] CGColor];
}


- (void)viewWillAppear:(BOOL)animated
{
  [self checkForLogin];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkForLogin
{
  PFUser *currentUser = [PFUser currentUser];
  if (!currentUser) {
    LoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
    loginViewController.delegate = self;
    [self.navigationController pushViewController:loginViewController animated:YES];
  }
}

- (IBAction)onSubmit:(id)sender {
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

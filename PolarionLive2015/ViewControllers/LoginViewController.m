//
//  LoginViewController.m
//  PolarionLive2015
//
//  Created by Scott Richards on 8/19/15.
//  Copyright (c) 2015 Scott Richards. All rights reserved.
//

#import "LoginViewController.h"

#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface LoginViewController ()
@property (strong, nonatomic) FBSDKAccessToken *fbToken;
@property (strong, nonatomic) NSString *userName;
@property (weak, nonatomic) IBOutlet UIView *loggedInView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//  Facebook Login Button
//    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
//    // Optional: Place the button in the center of your view.
//    loginButton.center = self.view.center;
//    [self.view addSubview:loginButton];
    _fbToken = [FBSDKAccessToken currentAccessToken];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
  [self checkForLogin];
}

- (void)checkForLogin
{
  PFUser *currentUser = [PFUser currentUser];
  _fbToken = [FBSDKAccessToken currentAccessToken];
  if (_fbToken) {
    [_loggedInView setHidden:NO]; // unhide the logged in view
    [_loginView setHidden:YES];   // hide the login view
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
       if (!error) {
         NSLog(@"fetched user:%@", result);
         _userName = result[@"name"];
         _userNameLabel.text = _userName;
       }
     }];
  } else if (currentUser) {
    _userName = currentUser.username;
    _userNameLabel.text = _userName;
    [_loggedInView setHidden:NO]; // unhide the logged in view
    [_loginView setHidden:YES];   // hide the login view
  } else {
    [_loginView setHidden:NO];
  }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogout:(id)sender {
  [PFUser logOut];
  [_loginView setHidden:NO];
  [_loggedInView setHidden:YES];
}

- (IBAction)onLogin:(id)sender {
  [PFUser logInWithUsernameInBackground:_usernameField.text password:_passwordField.text
      block:^(PFUser *user, NSError *error) {
        if (user) {
          NSLog(@"User %@ logged in",user.username);
          [self checkForLogin];
        } else {
          NSLog(@"LOG In FAILURE:");
          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                          message:@"Login failed, make sure your username and password are correct"
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
          [alert show];
        }
      }];

}

- (IBAction)facebookLogin:(id)sender {
  [PFFacebookUtils logInInBackgroundWithReadPermissions:@[@"email"] block:^(PFUser *user, NSError *error) {
    if (error) {
      NSLog(@"Error: %ld",error.code);
    } else {
      NSLog(@"Logged in: ");
      [self checkForLogin];
    }
  }];
  
  
//  This was doing a direct login to Facebook not through Parse Helper class
//  FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
//  [login logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
//    if (error) {
//      // Process error
//    } else if (result.isCancelled) {
//      // Handle cancellations
//    } else {
//      // If you ask for multiple permissions at once, you
//      // should check if specific permissions missing
//      if ([result.grantedPermissions containsObject:@"email"]) {
//        // Do work
//      }
//    }
//  }];
  
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  return YES;
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

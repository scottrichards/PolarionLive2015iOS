//
//  SignUpViewController.m
//  PolarionLive2015
//
//  Created by Scott Richards on 8/20/15.
//  Copyright (c) 2015 Scott Richards. All rights reserved.
//

#import "SignUpViewController.h"
#import "RaffleViewController.h"

#import <Parse/Parse.h>

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *fullname;
@property (weak, nonatomic) IBOutlet UITextField *company;
@property (weak, nonatomic) IBOutlet UITextField *titleField;



@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSignup:(id)sender {
  PFUser *user = [PFUser user];
  user.username = self.username.text;
  user.password = self.password.text;
  user.email = self.email.text;
  user[@"fullName"] = self.fullname.text;
  user[@"company"] = self.company.text;
  user[@"title"] = self.titleField.text;
  [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (!error) {
      // Hooray! Let them use the app now.
      NSLog(@"user %@ created",user.username);
      if ([_delegate isKindOfClass:[RaffleViewController class]]) {   // if we were invoked from RaffleViewController popViewBack to Raffle View
        [self.navigationController popToRootViewControllerAnimated:YES];
      } else
        [self performSegueWithIdentifier:@"signupToLoginSegue" sender:self];
    } else {
      NSString *errorString = [error userInfo][@"error"];
      // Show the errorString somewhere and let the user try again.
      NSLog(@"Error %@",errorString);
    }
  }];

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self.view endEditing:YES];
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

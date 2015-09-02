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
#import "WebViewController.h"
#import "URLService.h"

@interface RaffleViewController ()
@property (weak, nonatomic) IBOutlet UITextView *testimonialView;
@property (weak, nonatomic) IBOutlet UISwitch *usageConsent;
@property (weak, nonatomic) IBOutlet UIView *finishedView;
@property (weak, nonatomic) IBOutlet UIView *submitView;

@end

@implementation RaffleViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _finishedView.alpha = 0;
  _testimonialView.layer.borderWidth = 1.0f;
  _testimonialView.layer.cornerRadius = 8;
  _testimonialView.layer.borderColor = [[UIColor grayColor] CGColor];
}


- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
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
  if ([_testimonialView.text length] == 0) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Note"
                                                    message:@"Please provide a testimonial to enter the raffle."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    return;
  } else if (![_usageConsent isOn]) {    // make sure user consented to marketing usage
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Note"
                                                    message:@"Please consent to marketing usage to enter the raffle."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    return;
  } else {
    PFObject *testimonial = [PFObject objectWithClassName:@"Testimonial"];
    testimonial[@"tesimonial"] = _testimonialView.text;
    testimonial[@"user"] = [PFUser currentUser];
    [testimonial saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
      if (!succeeded) {
        NSLog(@"Error: %@",error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"There was an error, please check your connection and try again."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
      } else {
        NSLog(@"Success!");
        [UIView animateWithDuration: 0.5
                              delay: 1
                            options: UIViewAnimationCurveEaseOut
                         animations:^{
                           _finishedView.hidden = NO;
                            _finishedView.alpha = 1;
                           _submitView.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                           NSLog(@"Done!");
                           _submitView.hidden = NO;
                         }];
      
      }
    }];
  }
}

// End Editing when you touch anywhere outside TextView
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self.view endEditing:YES];
}

- (IBAction)onRaffleRules:(id)sender {
  WebViewController *webViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"webViewController"];
  webViewController.titleText = @"Raffle Rules";
  webViewController.urlToLoad = [URLService buildURLWithString:@"rules.html"];
  [self.navigationController pushViewController:webViewController animated:YES];
}

- (IBAction)onSampleTestimonials:(id)sender {
  WebViewController *webViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"webViewController"];
  webViewController.titleText = @"Sample Testimonials";
  webViewController.urlToLoad = [URLService buildURLWithString:@"testimonial.html"];
  [self.navigationController pushViewController:webViewController animated:YES];
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

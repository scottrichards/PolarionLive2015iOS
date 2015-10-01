//
//  ExpertsViewController.m
//  PolarionLive2015
//
//  Created by Scott Richards on 9/30/15.
//  Copyright (c) 2015 Scott Richards. All rights reserved.
//

#import "ExpertsViewController.h"
#import <Parse/Parse.h>

@interface ExpertsViewController ()
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *expertName;

@property (strong, nonatomic) NSArray *expertsData;
@property (strong, nonatomic) NSArray *descriptionsData;
@property (strong, nonatomic) NSArray *expertsNames;
@end

@implementation ExpertsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Meet the Experts";

    _expertsData = [[NSArray alloc] initWithObjects:@"Polarion API & Widgets",@"Polarion Integrations",@"Process & Configuration",@"New Features", nil];
    _descriptionsData = [[NSArray alloc] initWithObjects:
                         @"How to extend the power of Polarion via Scripting",
                         @"How to leverage existing or build own Extensions. Interplay between Polarion and other Systems.",
                         @"How to translate business problems into Polarion Processes such as Requirements- Test-, and Change Management, as well as Planning.",
                         @"How to adjust Polarion to specific need and processes. How does Feature X work? How should x Feature X be applied? How can problem X be solved.", nil];
    _expertsNames = [[NSArray alloc] initWithObjects:
                       @"Rainer Kreutzer, Martin Losch",
                       @"Benjamin Engele, Clara Cismaru, Reiner Kolb",
                       @"Hartmut Schäfer, Lukas Vogler, Michael Bischops",
                       @"Daniel Morris, Wolfgang Ehlert", nil];
  self.descriptionLabel.text = _descriptionsData[0];
  self.expertName.text = _expertsNames[0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onSignUp:(id)sender {
  PFObject *expertSignup = [PFObject objectWithClassName:@"ExpertSignup"];
  PFUser *currentUser = [PFUser currentUser];
  if (currentUser)
    expertSignup[@"user"] = currentUser;
  NSInteger selectedRow = [_pickerView selectedRowInComponent:0];
  if (selectedRow > -1) {
    expertSignup[@"session"] = _expertsData[selectedRow];
    [expertSignup saveEventually];
  }
  [self.navigationController popViewControllerAnimated:YES];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
  return [_expertsData count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
  return [_expertsData objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component{
  self.descriptionLabel.text = _descriptionsData[row];
  self.expertName.text = _expertsNames[row];
}

@end

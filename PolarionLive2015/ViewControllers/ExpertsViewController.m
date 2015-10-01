//
//  ExpertsViewController.m
//  PolarionLive2015
//
//  Created by Scott Richards on 9/30/15.
//  Copyright (c) 2015 Scott Richards. All rights reserved.
//

#import "ExpertsViewController.h"

@interface ExpertsViewController ()
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *expertName;

@property (strong, nonatomic) NSArray *expertsData;
@end

@implementation ExpertsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Meet the Experts";

    _expertsData = [[NSArray alloc] initWithObjects:@"Polarion API & Widgets",@"Polarion Integrations",@"Process & Configuration",@"New Features", nil];
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
@end

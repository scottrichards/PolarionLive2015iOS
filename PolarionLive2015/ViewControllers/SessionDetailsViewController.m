//
//  SessionDetailsViewController.m
//  PolarionLive2015
//
//  Created by Scott Richards on 8/20/15.
//  Copyright (c) 2015 Scott Richards. All rights reserved.
//

#import "SessionDetailsViewController.h"
#import "AMRatingControl.h"
#import "SessionRating.h"

#define CONTENT_RATING_X 140
#define CONTENT_RATING_Y 320


#define PRESENTATION_RATING_X 140
#define PRESENTATION_RATING_Y 360

@interface SessionDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *sessionName;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *presenters;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (strong, nonatomic) AMRatingControl *contentRatingControl;
@property (strong, nonatomic) AMRatingControl *presenterRatingControl;
@property (weak, nonatomic) IBOutlet UIButton *rateButton;
@property (weak, nonatomic) IBOutlet UIView *ratingView;
@property (assign) int presenterRating;
@property (assign) int contentRating;
@end

@implementation SessionDetailsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.time.text = self.sessionInfo[@"displayTime"];
  self.sessionName.text = self.sessionInfo[@"session"];
  self.descriptionLabel.text = self.sessionInfo[@"description"];
  self.presenters.text = self.sessionInfo[@"presenter"];
  self.location.text = self.sessionInfo[@"location"];
  if ([self.presenters.text length] == 0) // if we don't have any presenter's hide the label
  {
    
  }
  [self addRatingControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)addRatingControl
{
  if ([self.sessionInfo[@"rateable"] boolValue] == YES) {
    [self.rateButton setHidden:NO];
    [self.ratingView setHidden:NO];
    self.presenterRating = -1;
    self.contentRating = -1;
    self.presenterRatingControl = [[AMRatingControl alloc] initWithLocation:CGPointMake(CONTENT_RATING_X, CONTENT_RATING_Y)
                                                                 emptyColor:[UIColor blackColor]
                                                                 solidColor:[UIColor orangeColor]
                                                               andMaxRating:5];
    
    self.contentRatingControl = [[AMRatingControl alloc] initWithLocation:CGPointMake(PRESENTATION_RATING_X, PRESENTATION_RATING_Y)
                                                               emptyColor:[UIColor blackColor]
                                                               solidColor:[UIColor orangeColor]
                                                             andMaxRating:5];
    
    [self.presenterRatingControl setStarSpacing:0];
    // Define block to handle events
    self.presenterRatingControl.editingChangedBlock = ^(NSUInteger rating)
    {
      NSLog(@"Content Rating: %lu",(unsigned long)rating);
      _presenterRating = (int)rating;
    };
    
    // Define block to handle events
    self.contentRatingControl.editingChangedBlock = ^(NSUInteger rating)
    {
      NSLog(@"Content Rating: %lu",(unsigned long)rating);
      _contentRating = (int)rating;
    };
    
    //    self.logInfo.rating = 0;
    //    if (self.delegate.logInfo.rating) {    // set the rating
    //        [self.simpleRatingControl setRating:self.delegate.logInfo.rating];
    //    }
    
    [self.view addSubview:self.contentRatingControl];
    [self.view addSubview:self.presenterRatingControl];
  } else {
    [self.rateButton setHidden:YES];
    [self.ratingView setHidden:YES];
  }
}

- (IBAction)onRate:(id)sender {
  SessionRating *sessionRating = [SessionRating object];
  if (self.presenterRating >= 0) {
    sessionRating[@"presenterRating"] = [NSNumber numberWithInt:self.presenterRating];
    sessionRating[@"contentRating"] = [NSNumber numberWithInt:self.contentRating];
    sessionRating[@"session"] = self.sessionInfo;
    sessionRating[@"user"] = [PFUser currentUser];
    [sessionRating saveInBackground];
    [self.navigationController popViewControllerAnimated:YES];
  }
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

//
//  SpeakerTableViewController.m
//  PolarionLive2015
//
//  Created by Scott Richards on 9/3/15.
//  Copyright (c) 2015 Scott Richards. All rights reserved.
//

#import "SpeakerTableViewController.h"
#import <Parse/Parse.h>
#import "SpeakerTableViewCell.h"

@interface SpeakerTableViewController ()
@property (strong, nonatomic) NSArray *speakersArray;

@end

@implementation SpeakerTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
    
  [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_speakersArray count];
}

- (void)loadData
{
  PFQuery *query = [PFQuery queryWithClassName:@"Speakers"];
  [query orderByAscending:@"name"];
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error) {
      _speakersArray = objects;
      [self.tableView reloadData];
    } else {
      // Log details of the failure
      NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
  }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  SpeakerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
  if (cell && indexPath.row < [_speakersArray count]) {
    PFObject *object = _speakersArray[indexPath.row];
    cell.nameLabel.text = object[@"name"];
    cell.titleLabel.text = object[@"title"];
    cell.companyLabel.text = object[@"company"];
    cell.bioLabel.text = object[@"bio"];
    PFFile *imageFile = [object objectForKey:@"headshot"];
    if (imageFile) {
      [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error)
        {
          
          dispatch_async(dispatch_get_main_queue(), ^(void)
          {
            
            UIImage *image = [UIImage imageWithData:imageData];
            if (image)
              [cell.speakerImage setImage:image];
            cell.speakerImage.layer.cornerRadius = cell.speakerImage.frame.size.height/2;
            cell.speakerImage.layer.masksToBounds = YES;
            cell.speakerImage.layer.borderWidth = 2;
            cell.speakerImage.layer.borderColor = [[UIColor lightGrayColor] CGColor];
          });
        }
      }];
    } else {
      [cell.speakerImage setImage:nil];
      cell.speakerImage.layer.borderWidth = 0;
      cell.speakerImage.layer.borderColor = [[UIColor whiteColor] CGColor];
      cell.speakerImage.layer.masksToBounds = NO;
    }
  }
  return cell;
}




@end

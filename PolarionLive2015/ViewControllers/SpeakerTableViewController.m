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
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
  PFQuery *query = [PFQuery queryWithClassName:@"Speakers"];
  query.cachePolicy = kPFCachePolicyNetworkElseCache;
  [query orderByAscending:@"name"];
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error) {
      [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
      _speakersArray = objects;
      [self.tableView reloadData];
    } else {
      [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
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
      [cell.speakerImage setImage:[UIImage imageNamed:@"userGray"]];
      cell.speakerImage.layer.cornerRadius = cell.speakerImage.frame.size.height/2;
      cell.speakerImage.layer.masksToBounds = YES;
      cell.speakerImage.layer.borderWidth = 2;
      cell.speakerImage.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
  }
  return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row < [_speakersArray count]) {
    PFObject *object = _speakersArray[indexPath.row];
    NSString *text = object[@"bio"];
    if (text.length > 0) {
      CGSize theSize = [text sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:CGSizeMake(310.0f, FLT_MAX) lineBreakMode:UILineBreakModeWordWrap];
      NSLog(@"calculated size for %@: %f, %f",text, theSize.width, theSize.height);
      return 190.0;
    } else
      return 95.0;
  } else {
    return 95.0;
  }

}




@end

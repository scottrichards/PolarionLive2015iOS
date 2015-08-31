//
//  AgendaTableViewController.m
//  PolarionLive2015
//
//  Created by Scott Richards on 8/19/15.
//  Copyright (c) 2015 Scott Richards. All rights reserved.
//

#import "AgendaTableViewController.h"
#import "AgendaTableViewCell.h"
#import <Parse/Parse.h>
#import "SessionInfo.h"
#import "SessionDetailsViewController.h"
#import "DateObject.h"

@interface AgendaTableViewController ()
@property (strong, nonatomic) NSMutableArray *dateArray;       // Array of DateObjects
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *timeFormatter;
@end

@implementation AgendaTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
    
  [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
  NSLog(@"ViewWillAppear");
}

- (void)loadData
{
  PFQuery *query = [PFQuery queryWithClassName:@"Agenda"];
  [query orderByAscending:@"start"];
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error) {
      [self orderByDate:objects];
      [self.tableView reloadData];
    } else {
      // Log details of the failure
      NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
  }];
  
}

- (void)orderByDate:(NSArray *)objects
{
  NSString *lastDate = @"";
  DateObject *currentDateObject;
  if (self.dateArray == nil) {
    self.dateArray = [[NSMutableArray alloc] init];
  } else {
    [self.dateArray removeAllObjects];
  }
  for (SessionInfo *session in objects) {
    
    NSString *currentDate = [self formatDateWithObject:session];
    if (![lastDate isEqualToString:currentDate]) {
      currentDateObject = [[DateObject alloc] initWithDate:session[@"start"] andString:currentDate];
      [self.dateArray addObject:currentDateObject];
      lastDate = currentDate;
    }
    NSLog(@"Item: %@ Date: %@ Time: %@",session[@"session"],[self formatDateWithObject:session], [self formatTimeWithObject:session]);
    session[@"displayTime"] = [self formatTimeWithObject:session];
    //       [self.sessionArray addObject:session];
    [currentDateObject addSession:session];
  }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dateArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  DateObject *dateObject = self.dateArray[section];
  return [dateObject.sessions count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  // The header for the section is the region name -- get this from the region at the section index.
  DateObject *dateObject = self.dateArray[section];
  return dateObject.dateString;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  AgendaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
  if (indexPath.section < [_dateArray count]) {
    DateObject *dateObject = _dateArray[indexPath.section];
    if (dateObject && indexPath.row < [dateObject.sessions count]) {
      SessionInfo *sessionInfo = [dateObject.sessions objectAtIndex:indexPath.row];
//      PFObject *agendaObject = _agendaItems[indexPath.row];
      cell.sessionName.text = sessionInfo[@"session"];
      cell.location.text = sessionInfo[@"location"];
      cell.timeLabel.text = sessionInfo[@"displayTime"];
      NSString *iconImage = sessionInfo[@"icon"];
      if (iconImage)
        [cell.iconImageView setImage:[UIImage imageNamed:iconImage]];
      else
        [cell.iconImageView setImage:nil];
    }
  }
    
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section < [_dateArray count]) {
    DateObject *dateObject = _dateArray[indexPath.section];
    if (dateObject && indexPath.row < [dateObject.sessions count]) {
        SessionInfo *sessionInfo = [dateObject.sessions objectAtIndex:indexPath.row];
        NSNumber *customType = sessionInfo[@"customType"];
        SessionDetailsViewController *sessionDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sessionDetailsController"];
        if (sessionDetailsVC) {
          sessionDetailsVC.sessionInfo = sessionInfo;
          [self.navigationController pushViewController:sessionDetailsVC animated:YES];
        }
    }
  }
}


- (NSString *)formatDateWithObject:(PFObject *)object
{
  if (self.dateFormatter == nil) {
    self.dateFormatter = [[NSDateFormatter alloc] init];
    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"EEEEdMMMM" options:0
                                                              locale:[NSLocale currentLocale]];
    [self.dateFormatter setDateFormat:formatString];
    
  }
  
  NSDate *date = object[@"start"];
  
  NSString *formattedDateString = [NSString stringWithFormat:@"%@",[self.dateFormatter stringFromDate:date]];
  NSLog(@"formattedDateString: %@", formattedDateString);
  
  return formattedDateString;
}

- (NSString *)formatTimeWithObject:(PFObject *)object
{
  
  if (self.timeFormatter == nil) {
    self.timeFormatter = [[NSDateFormatter alloc] init];
    [self.timeFormatter setDateFormat:@"H:mm"];
    [self.timeFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
  }
  NSDate *date = object[@"start"];
  NSString *formattedTimeString;
  if (object[@"end"] == nil) {
    formattedTimeString = [self.timeFormatter stringFromDate:date];
  } else {
    formattedTimeString = [NSString stringWithFormat:@"%@-%@",[self.timeFormatter stringFromDate:date],[self.timeFormatter stringFromDate:object[@"end"]]];
  }
  NSLog(@"formattedTimeString: %@", formattedTimeString);
  
  return formattedTimeString;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

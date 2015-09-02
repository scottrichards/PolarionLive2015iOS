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
#import "AgendaItem.h"

@interface AgendaTableViewController ()
@property (strong, nonatomic) NSMutableArray *dateArray;       // Array of DateObjects
@property (strong, nonatomic) NSMutableArray *searchDateArray;       // Array of DateObjects
@property (strong, nonatomic) NSArray *sessionsArray;       // Copy of All Sessions used for searching
@property (strong, nonatomic) NSMutableArray *sessionsFilterArray;       // Array of Sessions used for searching
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *timeFormatter;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (assign) BOOL isSearching;
@end

@implementation AgendaTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Search Bar in the title bar
//  _searchBar = [[UISearchBar alloc] init];
//  _searchBar.delegate = self;
//  [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
//  self.navigationItem.titleView = _searchBar;
//  _searchBar.placeholder = @"Search";
  
  [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
  NSLog(@"ViewWillAppear");
}

#pragma mark - Data Structures

- (void)loadData
{
  PFQuery *query = [PFQuery queryWithClassName:@"Agenda"];
  [query orderByAscending:@"start"];
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error) {
      _sessionsArray = objects;
      [self orderByDate:objects];
      [self.tableView reloadData];
    } else {
      // Log details of the failure
      NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
  }];
  
}

- (void)setUpFilterArray
{
  if (!_sessionsFilterArray) {
    _sessionsFilterArray = [NSMutableArray new];
    for (PFObject *session in _sessionsArray) {
      [_sessionsFilterArray addObject:[AgendaItem initWithPFObject:session]];
    }
  }
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

-(void)filterContentForSearchText:(NSString*)searchText {
  [self setUpFilterArray];
  NSString *lastDate = @"";
  DateObject *currentDateObject;
  if (self.searchDateArray == nil) {
    self.searchDateArray = [[NSMutableArray alloc] init];
  } else {
    [self.searchDateArray removeAllObjects];
  }
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.sessionName contains[c] %@",searchText];
  NSArray *filteredSessionsArray = [NSMutableArray arrayWithArray:[_sessionsFilterArray filteredArrayUsingPredicate:predicate]];
  for (AgendaItem *agendaItem in filteredSessionsArray) {
    
    NSString *currentDate = [self formatDateWithAgendaItem:agendaItem];
    if (![lastDate isEqualToString:currentDate]) {
      currentDateObject = [[DateObject alloc] initWithDate:agendaItem.start andString:currentDate];
      [self.searchDateArray addObject:currentDateObject];
      lastDate = currentDate;
    }
    NSLog(@"Item: %@ Date: %@ Time: %@",agendaItem.sessionName,[self formatDateWithAgendaItem:agendaItem], [self formatTimeWithAgendaItem:agendaItem]);
    agendaItem.displayTime = [self formatTimeWithAgendaItem:agendaItem];
    //       [self.sessionArray addObject:session];
    [currentDateObject addAgendaItem:agendaItem];
  }
  [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (_isSearching)
    return [self.searchDateArray count];
  else
    return [self.dateArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (_isSearching) {
    DateObject *dateObject = self.searchDateArray[section];
    return [dateObject.agendaItems count];
  } else {
    DateObject *dateObject = self.dateArray[section];
    return [dateObject.sessions count];
  }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  // The header for the section is the region name -- get this from the region at the section index.
  if (_isSearching) {
    DateObject *dateObject = self.searchDateArray[section];
    return dateObject.dateString;
  } else {
    DateObject *dateObject = self.dateArray[section];
    return dateObject.dateString;
  }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  AgendaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
  if (_isSearching) {
    if (indexPath.section < [_searchDateArray count]) {
      DateObject *dateObject = _searchDateArray[indexPath.section];
      if (dateObject && indexPath.row < [dateObject.agendaItems count]) {
        AgendaItem *agendaItem = [dateObject.agendaItems objectAtIndex:indexPath.row];
        //      PFObject *agendaObject = _agendaItems[indexPath.row];
        cell.sessionName.text = agendaItem.sessionName;
        cell.location.text = agendaItem.location;
        cell.timeLabel.text = agendaItem.displayTime;
        NSString *iconImage = agendaItem.icon;
        
        
        if (iconImage)
          [cell.iconImageView setImage:[UIImage imageNamed:iconImage]];
        else
          [cell.iconImageView setImage:nil];
      }
    }
  } else {
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

- (NSString *)formatDateWithAgendaItem:(AgendaItem *)agendaItem
{
  if (self.dateFormatter == nil) {
    self.dateFormatter = [[NSDateFormatter alloc] init];
    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"EEEEdMMMM" options:0
                                                              locale:[NSLocale currentLocale]];
    [self.dateFormatter setDateFormat:formatString];
    
  }
  
  NSDate *date = agendaItem.start;
  
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

- (NSString *)formatTimeWithAgendaItem:(AgendaItem *)agendaItem
{
  if (self.timeFormatter == nil) {
    self.timeFormatter = [[NSDateFormatter alloc] init];
    [self.timeFormatter setDateFormat:@"H:mm"];
    [self.timeFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
  }
  NSDate *date = agendaItem.start;
  NSString *formattedTimeString;
  if (agendaItem.end == nil) {
    formattedTimeString = [self.timeFormatter stringFromDate:date];
  } else {
    formattedTimeString = [NSString stringWithFormat:@"%@-%@",[self.timeFormatter stringFromDate:date],[self.timeFormatter stringFromDate:agendaItem.end]];
  }
  NSLog(@"formattedTimeString: %@", formattedTimeString);
  
  return formattedTimeString;
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
  NSLog(@"Search Bar Did Change");
  if (_isSearching)
    [self filterContentForSearchText:_searchBar.text];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
  NSLog(@"Search Bar BEGIN Editing");
  _isSearching = YES;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
  NSLog(@"Search Bar END Editing");
  _isSearching = NO;
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

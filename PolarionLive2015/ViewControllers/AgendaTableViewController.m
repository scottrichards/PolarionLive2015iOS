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

static CGFloat kSectionHeaderHeight = 40.0F;  // Section Header Height with the Date

@interface AgendaTableViewController ()
@property (strong, nonatomic) NSMutableArray *dateArray;       // Array of DateObjects to Group AgendaItems by Date
@property (strong, nonatomic) NSMutableArray *searchDateArray;       // Array for Searching of AgendaItems grouped by Date
@property (strong, nonatomic) NSArray *sessionsArray;       // Copy of All Sessions used for searching
@property (strong, nonatomic) NSMutableArray *agendaItemsArray;       // Array of AgendaItems objects converted from PFObjects to NSObject used for searching
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *timeFormatter;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (assign, nonatomic) BOOL isSearching;   // if we are currently doing a search
@property (assign, nonatomic) BOOL wasSearching;  // retain the state when we are dismissing the view
@end

@implementation AgendaTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  NSLog(@"Is Searching %@",_isSearching ? @"YES" : @"NO");
  NSLog(@"ViewWillAppear");
  if (_wasSearching) {
    _isSearching = YES;
    [self filterContentForSearchText:_searchBar.text];
  }
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  if (_isSearching) {
    _wasSearching = YES;
  } else {
    _wasSearching = NO;
  }
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

// organize the sessions into DateObjects so all sessions on the same Date are grouped into a DateObject also convert them to AgendaItem objects
- (void)orderByDate:(NSArray *)objects
{
  NSString *lastDate = @"";
  DateObject *currentDateObject;
  if (self.dateArray == nil) {
    self.dateArray = [[NSMutableArray alloc] init];
  } else {
    [self.dateArray removeAllObjects];
  }
  _agendaItemsArray = [NSMutableArray new];
  for (PFObject *session in _sessionsArray) {
    [_agendaItemsArray addObject:[AgendaItem initWithPFObject:session]];
  }
  
  for (AgendaItem *agendaItem in _agendaItemsArray) {
    NSString *currentDate = [self formatDateWithAgendaItem:agendaItem];
    if (![lastDate isEqualToString:currentDate]) {
      currentDateObject = [[DateObject alloc] initWithDate:agendaItem.start andString:currentDate];
      [self.dateArray addObject:currentDateObject];
      lastDate = currentDate;
    }
    NSLog(@"Item: %@ Date: %@ Time: %@",agendaItem.sessionName,[self formatDateWithAgendaItem:agendaItem], [self formatTimeWithAgendaItem:agendaItem]);
    agendaItem.displayTime = [self formatTimeWithAgendaItem:agendaItem];
    //       [self.sessionArray addObject:session];
    [currentDateObject addAgendaItem:agendaItem];
  }

}

-(void)filterContentForSearchText:(NSString*)searchText {
  NSString *lastDate = @"";
  DateObject *currentDateObject;
  if (self.searchDateArray == nil) {
    self.searchDateArray = [[NSMutableArray alloc] init];
  } else {
    [self.searchDateArray removeAllObjects];
  }
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.sessionName contains[c] %@",searchText];
  NSArray *filteredSessionsArray = [NSMutableArray arrayWithArray:[_agendaItemsArray filteredArrayUsingPredicate:predicate]];
  for (AgendaItem *agendaItem in filteredSessionsArray) {
    
    NSString *currentDate = [self formatDateWithAgendaItem:agendaItem];
    if (![lastDate isEqualToString:currentDate]) {
      currentDateObject = [[DateObject alloc] initWithDate:agendaItem.start andString:currentDate];
      [self.searchDateArray addObject:currentDateObject];
      lastDate = currentDate;
    }
    NSLog(@"Item: %@ Date: %@ Time: %@",agendaItem.sessionName,[self formatDateWithAgendaItem:agendaItem], [self formatTimeWithAgendaItem:agendaItem]);
    agendaItem.displayTime = [self formatTimeWithAgendaItem:agendaItem];
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
    return [dateObject.agendaItems count];
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
      if (dateObject && indexPath.row < [dateObject.agendaItems count]) {
        AgendaItem *agendaItem = [dateObject.agendaItems objectAtIndex:indexPath.row];
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
  }
  
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  DateObject *dateObject;
  if (_isSearching) {
    if (indexPath.section < [_searchDateArray count]) {
      dateObject = _searchDateArray[indexPath.section];
    }
  } else {
    if (indexPath.section < [_dateArray count]) {
      dateObject = _dateArray[indexPath.section];
    }
  }
  if (dateObject && indexPath.row < [dateObject.agendaItems count]) {
    DateObject *dateObject = _dateArray[indexPath.section];
    if (dateObject && indexPath.row < [dateObject.agendaItems count]) {
      AgendaItem *agendaItem = [dateObject.agendaItems objectAtIndex:indexPath.row];
      if ([agendaItem.sessionName isEqualToString:@"Meet the Experts"]) {
        SessionDetailsViewController *sessionDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sessionDetailsController"];
        if (sessionDetailsVC) {
          sessionDetailsVC.agendaItem = [dateObject.agendaItems objectAtIndex:indexPath.row];
          [self.navigationController pushViewController:sessionDetailsVC animated:YES];
        }
        
      } else {
        SessionDetailsViewController *sessionDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sessionDetailsController"];
        if (sessionDetailsVC) {
          sessionDetailsVC.agendaItem = [dateObject.agendaItems objectAtIndex:indexPath.row];
          [self.navigationController pushViewController:sessionDetailsVC animated:YES];
        }
      }
    }
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return kSectionHeaderHeight;
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

#pragma mark - UIViewControllerDelegate

// when clicking anywhere in the view controller dismisses the keyboard
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self.view endEditing:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
  NSLog(@"Search Bar Did Change");
  
    if ([_searchBar.text length] == 0) {  // if no search criteria stop searching
      _isSearching = NO;
      [self.tableView reloadData];
    } else {
      _isSearching = YES;
      [self filterContentForSearchText:_searchBar.text];
    }
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
  [self.tableView reloadData];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
  _isSearching = NO;
  _wasSearching = NO;
  [self.tableView reloadData];
  [self.searchBar resignFirstResponder];
  self.searchBar.text = @"";
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

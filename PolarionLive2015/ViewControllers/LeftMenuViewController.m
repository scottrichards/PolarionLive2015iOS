//
//  LeftMenuViewController.m
//  PolarionLive2015
//
//  Created by Scott Richards on 8/24/15.
//  Copyright (c) 2015 Scott Richards. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "UIViewController+RESideMenu.h"
#import "HTMLViewController.h"
#import "URLService.h"

static NSUInteger MENU_POSITION_Y = 100;

@interface LeftMenuViewController ()
@property (strong, readwrite, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSArray *images;
@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _titles = @[@"Home", @"Agenda", @"Speakers", @"Partners", @"Map", @"Raffle", @"Log In", @"Social"];
  _images = @[@"IconHome", @"Agenda", @"Speaker", @"Partners", @"Map", @"Raffle", @"IconProfile", @"Social"];
  self.tableView = ({
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MENU_POSITION_Y, self.view.frame.size.width, 54 * [_titles count]) style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.opaque = NO;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.backgroundView = nil;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.bounces = NO;
    tableView.scrollsToTop = NO;
    tableView;
  });
  [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  switch (indexPath.row) {
    case 0:
      [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"homeViewController"]]
                                                   animated:YES];
      [self.sideMenuViewController hideMenuViewController];
      break;
    case 1:
      [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"agendaViewController"]]
                                                   animated:YES];
      [self.sideMenuViewController hideMenuViewController];
      break;
//    case 2:
//      [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"partnerViewController"]]
//                                                   animated:YES];
//      [self.sideMenuViewController hideMenuViewController];
//      break;
    case 2:
      [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"speakerViewController"]]
                                                   animated:YES];
      [self.sideMenuViewController hideMenuViewController];
      break;
    case 3:
    {
      HTMLViewController *htmlViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"htmlView"];
      
//      htmlViewController = (HTMLViewController *)[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"htmlView"]];
  
      htmlViewController.urlToLoad = [URLService buildURLWithString:@"2015m/partners/index.html"];
//      [self.sideMenuViewController setContentViewController:htmlViewController
//                                                   animated:YES];
      [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:htmlViewController]
                                                   animated:YES];
      [self.sideMenuViewController hideMenuViewController];
      break;
    }
    case 4:
      [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"mapViewController"]]
                                                   animated:YES];
      [self.sideMenuViewController hideMenuViewController];
      break;
    case 5:
      [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"raffleView"]]
                                                   animated:YES];
      [self.sideMenuViewController hideMenuViewController];
      break;
    case 6:
      [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"]]
                                                   animated:YES];
      [self.sideMenuViewController hideMenuViewController];
      break;
    case 7:
      [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"socialView"]]
                                                   animated:YES];
      [self.sideMenuViewController hideMenuViewController];
      break;

    default:
      break;
  }
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
  return [_titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
    cell.selectedBackgroundView = [[UIView alloc] init];
  }
  
  
  cell.textLabel.text = _titles[indexPath.row];
  cell.imageView.image = [UIImage imageNamed:_images[indexPath.row]];
  
  return cell;
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

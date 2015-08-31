//
//  MapViewController.m
//  PolarionLive2015
//
//  Created by Scott Richards on 8/25/15.
//  Copyright (c) 2015 Scott Richards. All rights reserved.
//

#import "MapViewController.h"
#import "PlaceAnnotation.h"

@interface MapViewController ()

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self centerAtHotel];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Zoom and Center around the specified location
- (void)zoomToLocation:(CLLocationCoordinate2D)location
{
  MKCoordinateRegion theRegion = self.mapView.region;
  
  // Zoom in
  theRegion.span.latitudeDelta = 0.112872;
  theRegion.span.longitudeDelta = 0.109863;
  
  theRegion.center = location;
  [self.mapView setRegion:theRegion animated:YES];
}

- (void)centerAtHotel
{
  CLLocationCoordinate2D location;  // Movenpick location
  location.latitude = 48.691593;
  location.longitude = 9.193243;
  [self zoomToLocation:location];
  
  /* Create the annotation using the location */
  /* Create the annotation using the location */
  PlaceAnnotation *placeMarker =  [[PlaceAnnotation alloc] initWithCoordinates:location
                                                                         title:@"Movenpick Stuttgart"
                                                                      subTitle:nil];
  
  /* And eventually add it to the map */
  [self.mapView addAnnotation:placeMarker];
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

//
//  ResultsMapViewController.m
//  bikepath
//
//  Created by Farheen Malik on 8/14/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import "ResultsMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>
#import "MDDirectionService.h"

@interface ResultsMapViewController () {
    GMSMapView *mapView_;
    NSMutableArray *waypoints_;
    NSMutableArray *waypointStrings_;
}
@end

@implementation ResultsMapViewController


- (IBAction)unwindToSearchPage:(UIStoryboardSegue *)segue{
    
}
- (void)viewDidLoad{
    [super viewDidLoad];
    
    waypoints_ = [[NSMutableArray alloc]init];
    waypointStrings_ = [[NSMutableArray alloc]init];
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:40.706638
                                                            longitude:-74.009070
                                                                 zoom:13];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.delegate = self;
    self.view = mapView_;
    
    CLLocationCoordinate2D startPosition = CLLocationCoordinate2DMake(40.706638, -74.009070);
    GMSMarker *startPoint = [GMSMarker markerWithPosition:startPosition];
    startPoint.title = @"Start";
    startPoint.map = mapView_;
    [waypoints_ addObject:startPoint];
    
    NSString *startPositionString = [[NSString alloc] initWithFormat:@"%f,%f", 40.706638, -74.009070];
    [waypointStrings_ addObject:startPositionString];
    
    CLLocationCoordinate2D startStationPosition = CLLocationCoordinate2DMake(40.705638, -74.013070);
    GMSMarker *startStationPoint = [GMSMarker markerWithPosition:startStationPosition];
    startStationPoint.title = @"Start station";
    startStationPoint.map = mapView_;
    [waypoints_ addObject:startStationPoint];
    
    NSString *startStationPositionString = [[NSString alloc] initWithFormat:@"%f,%f", 40.705638, -74.013070];
    [waypointStrings_ addObject:startStationPositionString];
    
    CLLocationCoordinate2D endStationPosition = CLLocationCoordinate2DMake(40.722638, -74.009070);
    GMSMarker *endStationPoint = [GMSMarker markerWithPosition:endStationPosition];
    endStationPoint.title = @"End Station";
    endStationPoint.map = mapView_;
    [waypoints_ addObject:endStationPoint];
    
    NSString *endStationPositionString = [[NSString alloc] initWithFormat:@"%f,%f", 40.722638, -74.009070];
    [waypointStrings_ addObject:endStationPositionString];
    
    CLLocationCoordinate2D endPosition = CLLocationCoordinate2DMake(40.720638, -74.006070);
    GMSMarker *endPoint = [GMSMarker markerWithPosition:endPosition];
    endPoint.title = @"Your destination";
    endPoint.map = mapView_;
    [waypoints_ addObject:endPoint];
    
    NSString *endPositionString = [[NSString alloc] initWithFormat:@"%f,%f", 40.720638, -74.006070];
    [waypointStrings_ addObject:endPositionString];
    NSLog(@"%@", waypointStrings_);
    
    NSString *sensor = @"false";
    NSArray *parameters = [NSArray arrayWithObjects:sensor, waypointStrings_,
                           nil];
    NSArray *keys = [NSArray arrayWithObjects:@"sensor", @"waypoints", nil];
    NSDictionary *query = [NSDictionary dictionaryWithObjects:parameters
                                                      forKeys:keys];
    MDDirectionService *mds=[[MDDirectionService alloc] init];
    SEL selector = @selector(addDirections:);
    [mds setDirectionsQuery:query
               withSelector:selector
               withDelegate:self];
}

- (void)addDirections:(NSDictionary *)json {
    
    NSDictionary *routes = [json objectForKey:@"routes"][0];
    
    NSDictionary *route = [routes objectForKey:@"overview_polyline"];
    NSString *overview_route = [route objectForKey:@"points"];
    GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.map = mapView_;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
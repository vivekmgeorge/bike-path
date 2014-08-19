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
#import <CoreLocation/CoreLocation.h>
#import "StationFinder.h"
#import "GMSMarkerFactory.h"

@interface ResultsMapViewController () {
    GMSMapView *mapView_;
    NSMutableArray *waypoints_;
    NSMutableArray *waypointStrings_;
    CLLocationManager *locationManager;
}
@end

@implementation ResultsMapViewController


- (IBAction)unwindToSearchPage:(UIStoryboardSegue *)segue{
    
}

- (NSString *)deviceLocation {
    return [NSString stringWithFormat:@"latitude: %f longitude: %f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
}

- (void) initMap{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:40.706638
                                                            longitude:-74.009070
                                                                 zoom:13];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.delegate = self;
    self.view = mapView_;
    return;
}

- (void)getUserLocation{
    locationManager = [[CLLocationManager alloc] init];
}

- (void)updateUserLocation{
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
}

- (void)viewDidLoad{
    // do the default view behavior
    [super viewDidLoad];
    
    [self initMap];
    [self getUserLocation]; // does this initialize every time the view loads? possible reason for crashing
    [self updateUserLocation];
    
    // init a waypoints instance var, it's an array of markers not locations
    waypoints_ = [[NSMutableArray alloc]init];
    waypointStrings_ = [[NSMutableArray alloc]init];

    // place a marker on the map at the current location of the phone
//    NSDictionary *closestStation = [StationFinder findClosestStation:stations location:currentLocation];
    CLLocationCoordinate2D startPosition = locationManager.location.coordinate;
    GMSMarker *startPoint = [GMSMarkerFactory createGMSMarker:&startPosition
                                                      mapView:mapView_
                                                        title:@"Start"
                                                        color:[GMSMarker markerImageWithColor:[UIColor redColor]]];
    [waypoints_ addObject: startPoint];
    // also set the first "poistion string" ... where are these used?
    NSString *startPositionString = [[NSString alloc] initWithFormat:@"%f,%f", startPoint.position.latitude, startPoint.position.longitude];
    [waypointStrings_ addObject:startPositionString];
    
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:startPosition.latitude
                                                             longitude:startPosition.longitude];


    CLLocationCoordinate2D createEndLocation = CLLocationCoordinate2DMake(self.item.lati, self.item.longi);
    GMSMarker *endPoint = [GMSMarkerFactory createGMSMarker:&createEndLocation
                                                    mapView:mapView_
                                                      title:self.item.address //the address being given is not the full address
                                                      color:[GMSMarker markerImageWithColor:[UIColor redColor]]];
    [waypoints_ addObject:endPoint];
    NSString *endPositionString = [[NSString alloc] initWithFormat:@"%f,%f", endPoint.position.latitude, endPoint.position.longitude];
    [waypointStrings_ addObject:endPositionString];
    
    // now fetch the nyc bike station locations and try to find closeby stations for
    // the start and destination locations
    NSURL *url = [NSURL URLWithString:@"http://www.citibikenyc.com/stations/json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         // todo: handle error response from server
         // if some results and no error
         if (data.length > 0 && connectionError == nil)
         {
             // todo: handle invalid json from server
             // parse raw data response from server into dictionary
             NSDictionary *bikepathjson = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:0
                                                                            error:NULL];

             // extract out the list of stations from the response dict, throw away everything
             // else
             NSArray *stations = [bikepathjson objectForKey:@"stationBeanList"];

             NSDictionary *closestStation = [StationFinder findClosestStation:stations location:currentLocation];
             CLLocationCoordinate2D closestStationLocation = CLLocationCoordinate2DMake(
                 [[closestStation objectForKey:@"latitude"] doubleValue],
                 [[closestStation objectForKey:@"longitude"] doubleValue]);
             
             NSString *closestStationTitle = [closestStation objectForKey:@"stationName"];
             NSString *availableBikes      = [[closestStation objectForKey:@"availableBikes"] stringValue];
             NSNumber *numBikes            = @([[closestStation objectForKey:@"availableBikes"] intValue]);
             
             GMSMarker *startStation  = [GMSMarkerFactory createGMSMarker:&closestStationLocation
                                                                  mapView:mapView_
                                                                    title:closestStationTitle
                                                                    color:[GMSMarker markerImageWithColor:[UIColor redColor]]];
             [waypoints_ addObject:startStation];
             NSString *startStationString = [[NSString alloc] initWithFormat:@"%f,%f", closestStationLocation.latitude, closestStationLocation.longitude];
             [waypointStrings_ addObject:startStationString];
             
             if ([numBikes intValue] > 3) {
                 startStation.icon    = [GMSMarker markerImageWithColor:[UIColor greenColor]];
                 startStation.snippet = [NSString stringWithFormat:@"Bicyles available: %@", availableBikes];
             } else if ([numBikes intValue] > 0) {
                 startStation.icon    = [GMSMarker markerImageWithColor:[UIColor orangeColor]];
                 startStation.snippet = [NSString stringWithFormat:@"Bicyles available: %@", availableBikes];
             } else {
                 startStation.icon    = [GMSMarker markerImageWithColor:[UIColor redColor]];
                 startStation.snippet = @"No bicyles available at this location.";
             };
             
             CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:createEndLocation.latitude
                                                                  longitude:createEndLocation.longitude];
             
             NSDictionary *closestEndStation = [StationFinder findClosestStation:stations location:endLocation];
             CLLocationCoordinate2D closestEndStationLocation =
             CLLocationCoordinate2DMake([[closestEndStation objectForKey:@"latitude"] doubleValue],
                                        [[closestEndStation objectForKey:@"longitude"] doubleValue]);

             NSString *availableEndStationBikes = [[closestStation objectForKey:@"availableBikes"] stringValue];
             NSNumber *numberOfEndStationBikes  = @([[closestStation objectForKey:@"availableBikes"] intValue]);
             
             GMSMarker *endStation  = [GMSMarkerFactory createGMSMarker:&closestEndStationLocation
                                                                mapView:mapView_
                                                                  title:[closestStation objectForKey:@"stationName"]
                                                                  color:[GMSMarker markerImageWithColor:[UIColor redColor]]];
             [waypoints_ addObject:closestEndStation];
             NSString *endStationString = [[NSString alloc] initWithFormat:@"%f,%f", closestEndStationLocation.latitude, closestEndStationLocation.longitude];
             [waypointStrings_ addObject:endStationString];
             
             if ([numberOfEndStationBikes intValue] > 3) {
                 endStation.icon    = [GMSMarker markerImageWithColor:[UIColor greenColor]];
                 endStation.snippet = [NSString stringWithFormat:@"Bicyles available: %@", availableEndStationBikes];
             } else if ([numBikes intValue] > 0) {
                 startStation.icon    = [GMSMarker markerImageWithColor:[UIColor orangeColor]];
                 startStation.snippet = [NSString stringWithFormat:@"Bicyles available: %@", availableEndStationBikes];
             } else {
                 endStation.icon    = [GMSMarker markerImageWithColor:[UIColor redColor]];
                 endStation.snippet = @"No bikes available at this location.";
             };
             
             // make google waypoint search struct ... do this somewhere else
             NSArray *parameters = [NSArray arrayWithObjects: waypointStrings_, nil];
             NSArray *keys = [NSArray arrayWithObjects: @"waypoints", nil];
             NSDictionary *query = [NSDictionary dictionaryWithObjects:parameters
                                                               forKeys:keys];
             
             // finally, find the waypoints and set the delegate to this view, the direction
             // lines will be drawn when the request completes
             MDDirectionService *mds=[[MDDirectionService alloc] init];
             SEL selector = @selector(addDirections:);
             [mds setDirectionsQuery:query
                        withSelector:selector
                        withDelegate:self];
         }
     }];
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
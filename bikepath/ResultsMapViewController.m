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

- (void)viewDidLoad{
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
    
    waypoints_ = [[NSMutableArray alloc]init];
    waypointStrings_ = [[NSMutableArray alloc]init];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:40.706638
                                                            longitude:-74.009070
                                                                 zoom:13];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.delegate = self;
    self.view = mapView_;

    CLLocationCoordinate2D startPosition = locationManager.location.coordinate;
    GMSMarker *startPoint = [GMSMarker markerWithPosition:startPosition];
    startPoint.title = @"Start";
    startPoint.map = mapView_;
    [waypoints_ addObject:startPoint];
    
    NSString *startPositionString = [[NSString alloc] initWithFormat:@"%f,%f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
    [waypointStrings_ addObject:startPositionString];
    
    GMSMarker *endPoint = [[GMSMarker alloc] init];
    endPoint.position = CLLocationCoordinate2DMake(self.item.lati, self.item.longi);
    endPoint.title = self.item.searchQuery;
    endPoint.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
    endPoint.map = mapView_;
    [waypoints_ addObject:endPoint];
    
    NSString *endPositionString = [[NSString alloc] initWithFormat:@"%f,%f", self.item.lati, self.item.longi];
    [waypointStrings_ addObject:endPositionString];
    
    NSURL *url = [NSURL URLWithString:@"http://www.citibikenyc.com/stations/json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSDictionary *bikepathjson = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:NULL];
             NSArray *stations = [bikepathjson objectForKey:@"stationBeanList"];
             
             CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:startPosition.latitude longitude:startPosition.longitude];
             
             NSDictionary *closestStation = [StationFinder findClosestStation:stations location:currentLocation];
             
             CLLocationDistance smallestDistance = DBL_MAX;
             CLLocation *closestLocation;
//             NSDictionary *closestStation;
             
             CLLocation *closestEndLocation;
             NSDictionary *closestEndStation;
             
             for(id st in stations) {
                 NSDictionary *station      = (NSDictionary *)st;
                 NSString *stationLatitude  = [station objectForKey:@"latitude"];
                 NSString *stationLongitude = [station objectForKey:@"longitude"];
                 
                 CLLocation *bikeStop = [[CLLocation alloc] initWithLatitude:[stationLatitude doubleValue] longitude:[stationLongitude doubleValue]];
                 CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:startPosition.latitude longitude:startPosition.longitude];
                 
                 NSMutableArray *locations = [[NSMutableArray alloc] init];
                 [locations addObject:bikeStop];
                 
                 for (CLLocation *location in locations) {
                     CLLocationDistance distance = [currentLocation distanceFromLocation:location];
                     
                     if (distance < smallestDistance) {
                         smallestDistance    = distance;
                         closestLocation     = location;
                         closestStation      = station;
                     }
                 }
                 
                 CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:self.item.lati longitude:self.item.longi];
                 
                 for (CLLocation *endStationlocation in locations) {
                     CLLocationDistance distance = [endLocation distanceFromLocation:endStationlocation];
                     
                     if (distance < smallestDistance) {
                         smallestDistance    = distance;
                         closestEndLocation  = endStationlocation;
                         closestEndStation   = station;
                     }
                 }
             }
             
             NSString *title            = [closestStation objectForKey:@"stationName"];
             NSString *availableBikes   = [[closestStation objectForKey:@"availableBikes"] stringValue];
             NSNumber *numBikes         = @([[closestStation objectForKey:@"availableBikes"] intValue]);
             
             GMSMarker *startStation  = [[GMSMarker alloc] init];
             
             if ([numBikes intValue] > 0) {
                 startStation.icon    = [GMSMarker markerImageWithColor:[UIColor greenColor]];
                 startStation.snippet = [NSString stringWithFormat:@"Bicyles avaiable: %@", availableBikes];
             } else {
                 startStation.icon    = [GMSMarker markerImageWithColor:[UIColor redColor]];
                 startStation.snippet = @"No bicyles available at this location.";
             };
             
             startStation.title       = title;
             startStation.position    = closestLocation.coordinate;
             startStation.map         = mapView_;
             
             [waypoints_ addObject:startStation];
             NSString *startStationString = [[NSString alloc] initWithFormat:@"%f,%f", closestLocation.coordinate.latitude, closestLocation.coordinate.longitude];
             [waypointStrings_ addObject:startStationString];
             
             NSString *endTitle            = [closestStation objectForKey:@"stationName"];
             NSString *availableEndBikes   = [[closestStation objectForKey:@"availableBikes"] stringValue];
             NSNumber *numEndBikes         = @([[closestStation objectForKey:@"availableBikes"] intValue]);
             
             GMSMarker *endStation  = [[GMSMarker alloc] init];
             
             if ([numEndBikes intValue] > 0) {
                 endStation.icon    = [GMSMarker markerImageWithColor:[UIColor greenColor]];
                 endStation.snippet = availableEndBikes;
             } else {
                 endStation.icon    = [GMSMarker markerImageWithColor:[UIColor redColor]];
                 endStation.snippet = @"No bikes available at this location.";
             };
             
             endStation.title       = endTitle;
             endStation.position    = closestEndLocation.coordinate;
             endStation.map         = mapView_;
             
             [waypoints_ addObject:endStation];
             NSString *endStationString = [[NSString alloc] initWithFormat:@"%f,%f", closestEndLocation.coordinate.latitude, closestEndLocation.coordinate.longitude];
             [waypointStrings_ addObject:endStationString];
             
             NSString *sensor = @"false";
             NSArray *parameters = [NSArray arrayWithObjects:sensor, waypointStrings_, nil];
             NSArray *keys = [NSArray arrayWithObjects:@"sensor", @"waypoints", nil];
             NSDictionary *query = [NSDictionary dictionaryWithObjects:parameters
                                                               forKeys:keys];
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
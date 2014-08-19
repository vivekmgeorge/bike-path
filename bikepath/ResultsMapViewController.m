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

// should be responsible for setting up the map, (setting camera point etc)
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

//-(void)GMSMarkerFactory{
//    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(coordinates);
//    GMSMarker *startPoint = [GMSMarker markerWithPosition:postion];
//    startPoint.title = @"Start";
//    startPoint.map = mapView_;
//}

- (void)viewDidLoad{
    // do the default view behavior
    [super viewDidLoad];
    
    [self initMap];
    [self getUserLocation]; // does this initialize every time the view loads? possible reason for crashing
    [self updateUserLocation];

    // get the current location of the phone from the locationManager
    CLLocationCoordinate2D startPosition = locationManager.location.coordinate;
    
    // init a waypoints instance var, it's an array of markers not locations
//    waypoints_ = [[NSMutableArray alloc]init];
    waypointStrings_ = [[NSMutableArray alloc]init];

    // place a marker on the map at the current location of the phone
//    startPosition = locationManager.coordinate;
//    NSDictionary *closestStation = [StationFinder findClosestStation:stations location:currentLocation];
    

    
//    [self GMSMarkerFactory]; GMSMarker *startPoint = [Factory:startPosition];
    GMSMarker *startPoint = [GMSMarker markerWithPosition:startPosition];
    startPoint.title = @"Start";
    startPoint.map = mapView_;
    
    // set the first waypoint to the *marker* that's at the current position
//    [waypoints_ addObject: startPoint];
    // also set the first "poistion string" ... where are these used?
    NSString *startPositionString = [[NSString alloc] initWithFormat:@"%f,%f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
    [waypointStrings_ addObject:startPositionString];

    // place a marker on the map for the end point using the values in the self.item object
    // which is a custom object with lat & lng values passed from the search controller
    GMSMarker *endPoint = [[GMSMarker alloc] init];
    endPoint.position = CLLocationCoordinate2DMake(self.item.lati, self.item.longi);
    // you probably want this line instead of the one above, that would allow you
    // to remove item.lati and item.longi
    // endPoint.position = self.item.position;
    endPoint.title = self.item.searchQuery; // should be item.locationName
    endPoint.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
    endPoint.map = mapView_;
    
    // Set the second waypoint to be the *marker* of the destination
    [waypoints_ addObject:endPoint];
    NSString *endPositionString = [[NSString alloc] initWithFormat:@"%f,%f", self.item.lati, self.item.longi];
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
               NSLog(@"%@", bikepathjson);
             // extract out the list of stations from the response dict, throw away everthing
             // else
             NSArray *stations = [bikepathjson objectForKey:@"stationBeanList"];
             
             // create a corelocation object from the phones current location
             // this could be moved up out of this response handler
             CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:startPosition.latitude longitude:startPosition.longitude];

             // use the StationFinder module to search the station list returned from the
             // server for the closest one (for now its just one)
             NSDictionary *closestStation = [StationFinder findClosestStation:stations location:currentLocation];
             
             
             CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:self.item.lati longitude:self.item.longi];
             NSDictionary *closestEndStation = [StationFinder findClosestStation:stations location:endLocation];
             
             
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
             
             
             // make core location objects for the locations of the two bike stations found
             // above but the StationFinder module
             CLLocation *closestLocation = [[CLLocation alloc]
                                            initWithLatitude:[[closestStation objectForKey:@"latitude"] doubleValue]    longitude:[[closestStation objectForKey:@"longitude"] doubleValue]];
             CLLocation *closestEndLocation = [[CLLocation alloc]
                                            initWithLatitude:[[closestEndStation objectForKey:@"latitude"] doubleValue]    longitude:[[closestEndStation objectForKey:@"longitude"] doubleValue]];
             
             // set the marker label and position for the start marker
             startStation.title       = title;
             startStation.position    = closestLocation.coordinate;
             startStation.map         = mapView_;
             
             // add the start station as a waypoint as waypoint 3 (index 2)
             [waypoints_ addObject:startStation];
             NSString *startStationString = [[NSString alloc] initWithFormat:@"%f,%f", closestLocation.coordinate.latitude, closestLocation.coordinate.longitude];
             [waypointStrings_ addObject:startStationString];
             
             // extract title, bike count (twice, string and int)
             NSString *endTitle            = [closestStation objectForKey:@"stationName"];
             NSString *availableEndBikes   = [[closestStation objectForKey:@"availableBikes"] stringValue];
             NSNumber *numEndBikes         = @([[closestStation objectForKey:@"availableBikes"] intValue]);
             
             // create a marker for the end station
             GMSMarker *endStation  = [[GMSMarker alloc] init];
             
             // color the markers based on number of bikes
             if ([numEndBikes intValue] > 0) {
                 endStation.icon    = [GMSMarker markerImageWithColor:[UIColor greenColor]];
                 endStation.snippet = availableEndBikes;
             } else {
                 endStation.icon    = [GMSMarker markerImageWithColor:[UIColor redColor]];
                 endStation.snippet = @"No bikes available at this location.";
             };
             
             // set properties of end location marker
             endStation.title       = endTitle;
             endStation.position    = closestEndLocation.coordinate;
             endStation.map         = mapView_;
             
             // add final waypoint (index 3), end station marker
             [waypoints_ addObject:endStation];
             NSString *endStationString = [[NSString alloc] initWithFormat:@"%f,%f", closestEndLocation.coordinate.latitude, closestEndLocation.coordinate.longitude];
             [waypointStrings_ addObject:endStationString];
             
             // make google waypoint search struct ... do this somewhere else
             NSString *sensor = @"false";
             NSArray *parameters = [NSArray arrayWithObjects:sensor, waypointStrings_, nil];
             NSArray *keys = [NSArray arrayWithObjects:@"sensor", @"waypoints", nil];
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
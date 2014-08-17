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
- (void)viewDidLoad
{
    GMSCameraPosition *dbc = [GMSCameraPosition cameraWithLatitude:40.706638
                                                         longitude:-74.009070
                                                              zoom:14];

    self.mapView.mapType = kGMSTypeNormal;
    [self.mapView setCamera:dbc];
    self.mapView.myLocationEnabled          = YES;
    self.mapView.settings.compassButton     = YES;
    self.mapView.settings.myLocationButton  = YES;
    self.mapView.settings.zoomGestures      = YES;
    self.mapView.delegate                   = self;

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:40.706638
                                                            longitude:-74.009070
                                                                 zoom:13];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.delegate = self;
    self.view = mapView_;


    CLLocationCoordinate2D startPosition = CLLocationCoordinate2DMake(40.706638, -74.010070);
    GMSMarker *startPoint = [GMSMarker markerWithPosition:startPosition];
    startPoint.title = @"Start";
    startPoint.map = mapView_;
    [waypoints_ addObject:startPoint];

    NSString *startPositionString = [[NSString alloc] initWithFormat:@"%f,%f", 40.706638, -74.010070];
    [waypointStrings_ addObject:startPositionString];
        NSLog(@"%@", waypointStrings_);

    NSURL *url = [NSURL URLWithString:@"http://www.citibikenyc.com/stations/json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSDictionary *greeting = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:NULL];
             NSArray *stations = [greeting objectForKey:@"stationBeanList"];
             CLLocationDistance smallestDistance = DBL_MAX;
             CLLocation *closestLocation;
             NSDictionary *closestStation;

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

             }
             NSLog(@"%@", closestLocation);
             NSLog(@"%f", closestLocation.coordinate.longitude);

             NSString *title            = [closestStation objectForKey:@"stationName"];
             NSString *availableBikes   = [[closestStation objectForKey:@"availableBikes"] stringValue];
             NSNumber *numBikes         = @([[closestStation objectForKey:@"availableBikes"] intValue]);

             GMSMarker *citiMarker  = [[GMSMarker alloc] init];

             if ([numBikes intValue] > 0) {
                 citiMarker.icon    = [GMSMarker markerImageWithColor:[UIColor greenColor]];
                 citiMarker.snippet = availableBikes;
             } else {
                 citiMarker.icon    = [GMSMarker markerImageWithColor:[UIColor redColor]];
                 citiMarker.snippet = @"No bikes available at this location.";
             };

             citiMarker.title       = title;
             citiMarker.position    = closestLocation.coordinate;
             citiMarker.map         = mapView_;
             NSLog(@"%@", citiMarker);

             [waypoints_ addObject:citiMarker];
             NSString *citiMarkerString = [[NSString alloc] initWithFormat:@"%f,%f", closestLocation.coordinate.latitude, closestLocation.coordinate.longitude];
             [waypointStrings_ addObject:citiMarkerString];
                 NSLog(@"hello %@", waypointStrings_);

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

             NSString *sensor = @"false";
             NSArray *parameters = [NSArray arrayWithObjects:sensor, waypointStrings_,
                                    nil];
             NSArray *keys = [NSArray arrayWithObjects:@"sensor", @"waypoints", nil];
             NSDictionary *query = [NSDictionary dictionaryWithObjects:parameters
                                                               forKeys:keys];

             NSLog(@"%@", waypointStrings_);
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

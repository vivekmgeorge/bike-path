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
#import "AFNetworking.h"
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
//- (void)viewDidLoad
//{
////
////    locationManager = [[CLLocationManager alloc] init];
////    locationManager.delegate = self;
////    locationManager.distanceFilter = kCLDistanceFilterNone;
////    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
////    [locationManager startUpdatingLocation];
//
//    GMSCameraPosition *dbc = [GMSCameraPosition cameraWithLatitude:40.706638
//                                                         longitude:-74.009070
//                                                              zoom:14];
//
//    self.mapView.mapType = kGMSTypeNormal;
//    [self.mapView setCamera:dbc];
//    self.mapView.myLocationEnabled = YES;
//    self.mapView.settings.compassButton = YES;
//    self.mapView.settings.myLocationButton = YES;
//    self.mapView.settings.zoomGestures = YES;
//    self.mapView.delegate = self;
//
//    NSURL *url = [NSURL URLWithString:@"http://www.citibikenyc.com/stations/json"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:[NSOperationQueue mainQueue]
//                           completionHandler:^(NSURLResponse *response,
//                                               NSData *data, NSError *connectionError)
//     {
//         if (data.length > 0 && connectionError == nil)
//         {
//             NSDictionary *greeting = [NSJSONSerialization JSONObjectWithData:data
//                                                                      options:0
//                                                                        error:NULL];
//             NSArray* stations = [greeting objectForKey:@"stationBeanList"];
//             CLLocationDistance smallestDistance = DBL_MAX;
//             CLLocation *closestLocation;
//             for(id st in stations) {
//                 NSDictionary *station      = (NSDictionary *)st;
//                 NSString *lati             = [station objectForKey:@"latitude"];
//                 NSString *longi            = [station objectForKey:@"longitude"];
//                 NSString *title            = [station objectForKey:@"stationName"];
//                 NSString *availableBikes   = [[station objectForKey:@"availableBikes"] stringValue];
//                 NSNumber *num              = @([[station objectForKey:@"availableBikes"] intValue]);
//
//                 GMSMarker *citiMarker  = [[GMSMarker alloc] init];
//                 citiMarker.position    = closestLocation.coordinate;
//                 citiMarker.title       = title;
//
//                 if ([num intValue] > 0) {
//                     citiMarker.icon    = [GMSMarker markerImageWithColor:[UIColor greenColor]];
//                     citiMarker.snippet = availableBikes;
//                 } else {
//                     citiMarker.icon    = [GMSMarker markerImageWithColor:[UIColor redColor]];
//                     citiMarker.snippet = @"No bikes available at this location.";
//                 };
//
//                 citiMarker.map = self.mapView;
//
//                 CLLocation *bikeStop           = [[CLLocation alloc] initWithLatitude:[lati doubleValue] longitude:[longi doubleValue]];
//                 CLLocation *currentLocation    = self.mapView.myLocation;
//
//                 NSMutableArray *locations = [[NSMutableArray alloc] init];
//                 [locations addObject:bikeStop];
//
//                    for (CLLocation *location in locations) {
//                        CLLocationDistance distance = [currentLocation distanceFromLocation:location];
//
//                        if (distance < smallestDistance) {
//                            smallestDistance = distance;
//                            closestLocation = location;
//                        }
//                    }
//             }
//             NSLog(@"%f", smallestDistance);
//        }
//     }];
//
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager GET:@"https://maps.googleapis.com/maps/api/directions/json?mode=bycycling&origin=40.706038+-74.009070&destination=40.706638+-74.009070&z=12&key=AIzaSyDeifXgaBJFQSSUNQuC88lCq3M43tej5o4" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
//

//    - (void)loadView {
//        waypoints_ = [[NSMutableArray alloc]init];
//        waypointStrings_ = [[NSMutableArray alloc]init];
//        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:40.706638
//                                                                longitude:-74.009070
//                                                                     zoom:13];
//        mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
//        mapView_.delegate = self;
//        self.view = mapView_;
//
//    }

    - (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:
    (CLLocationCoordinate2D)coordinate {

        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(
                                                                     coordinate.latitude,
                                                                     coordinate.longitude);
        GMSMarker *marker = [GMSMarker markerWithPosition:position];
        marker.map = mapView_;
        [waypoints_ addObject:marker];
        NSString *positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                                    coordinate.latitude,coordinate.longitude];
        [waypointStrings_ addObject:positionString];
        if([waypoints_ count]>1){
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
        startStationPoint.title = @"Middle";
        startStationPoint.map = mapView_;
        [waypoints_ addObject:startStationPoint];
        
        NSString *startStationPositionString = [[NSString alloc] initWithFormat:@"%f,%f", 40.705638, -74.013070];
        [waypointStrings_ addObject:startStationPositionString];
        
        CLLocationCoordinate2D endStationPosition = CLLocationCoordinate2DMake(40.722638, -74.009070);
        GMSMarker *endStationPoint = [GMSMarker markerWithPosition:endStationPosition];
        endStationPoint.title = @"Middle";
        endStationPoint.map = mapView_;
        [waypoints_ addObject:endStationPoint];
        
        NSString *endStationPositionString = [[NSString alloc] initWithFormat:@"%f,%f", 40.722638, -74.009070];
        [waypointStrings_ addObject:endStationPositionString];
        
        CLLocationCoordinate2D endPosition = CLLocationCoordinate2DMake(40.720638, -74.006070);
        GMSMarker *endPoint = [GMSMarker markerWithPosition:endPosition];
        endPoint.title = @"End";
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
//}

@end

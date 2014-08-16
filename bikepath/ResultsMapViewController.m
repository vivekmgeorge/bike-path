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

@implementation ResultsMapViewController

- (void)viewDidLoad
{
//
//    locationManager = [[CLLocationManager alloc] init];
//    locationManager.delegate = self;
//    locationManager.distanceFilter = kCLDistanceFilterNone;
//    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    [locationManager startUpdatingLocation];

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
             NSArray* stations = [greeting objectForKey:@"stationBeanList"];
             for(id st in stations) {
                 NSDictionary *station = (NSDictionary *)st;
                 NSString *lati = [station objectForKey:@"latitude"];
                 NSString *longi = [station objectForKey:@"longitude"];
                 NSString *title = [station objectForKey:@"stationName"];
                 NSLog(@"%@", [station objectForKey:@"availableBikes"]);
                 NSString *num = [station objectForKey:@"availableBikes"];

                 CLLocation *bikeStop = [[CLLocation alloc] initWithLatitude:[lati doubleValue] longitude:[longi doubleValue]];
                 NSMutableArray *locations = [[NSMutableArray alloc] init];
                 [locations addObject:bikeStop];

                 CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:40.748441 longitude:-73.985664];
                 CLLocation *closestLocation;
                 CLLocationDistance smallestDistance = DBL_MAX;
                    for (CLLocation *location in locations) {
                        CLLocationDistance distance = [currentLocation distanceFromLocation:location];
    
                        if (distance < smallestDistance) {
                            distance = smallestDistance;
                            closestLocation = location;
                            
                            GMSMarker *citiMarker = [[GMSMarker alloc] init];
                            citiMarker.position = closestLocation.coordinate;
//                            citiMarker.position= CLLocationCoordinate2DMake([lati doubleValue], [longi doubleValue]);
                            citiMarker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
                            citiMarker.map = self.mapView;
                        }
                    }
             }
        }
     }];
}

@end
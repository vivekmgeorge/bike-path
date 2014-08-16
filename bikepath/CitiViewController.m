//
//  CitiViewController.m
//  bikepath
//
//  Created by Apprentice on 8/15/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import "CitiViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <MapKit/MapKit.h>

@implementation CitiViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

//- (IBAction)fetchGreeting;
//{
    GMSCameraPosition *dbc = [GMSCameraPosition cameraWithLatitude:40.706638
                                                         longitude:-74.009070
                                                              zoom:14];
    
    self.mapView.mapType = kGMSTypeNormal;
    [self.mapView setCamera:dbc];
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.settings.zoomGestures = YES;
    self.mapView.delegate = self;
    
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
             //             NSLog(@"%@", greeting);
             //             NSLog(@"%@", [greeting objectForKey:@"stationBeanList"]);
             NSArray* stations = [greeting objectForKey:@"stationBeanList"];
             for(id st in stations) {
                 NSDictionary *station = (NSDictionary *)st;
                 NSString *lati = [station objectForKey:@"latitude"];
                 NSString *longi = [station objectForKey:@"longitude"];
                 NSString *title = [station objectForKey:@"stationName"];
                 MKMapItem *item;
                 GMSMarker *citiMarker = [[GMSMarker alloc] init];
                 citiMarker.position= CLLocationCoordinate2DMake([lati doubleValue], [longi doubleValue]);
                 //                 NSDouble *latitude = [[station objectForKey:@"latitude"]];
                 //                 NSLog(@"%@", [report.latitude = [latitude doubleValue]]);
                 //                 CLLocationCoordinate2DMake([[station objectForKey:[@"latitude" ] doubleValue], [[station objectForKey:[@"longitude" ] doubleValue]);
                 NSLog(@"%@", [station objectForKey:@"latitude"]);
                 citiMarker.title = item.name;
                 citiMarker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
                 citiMarker.map = self.mapView;
//                 NSLog(@"latitude = %f", item.placemark.location.coordinate.latitude);
//                 NSLog(@"longitude = %f", item.placemark.location.coordinate.longitude);
             }
         }
     }];
}


@end

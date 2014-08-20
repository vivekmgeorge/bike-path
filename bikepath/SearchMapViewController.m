//
//  SearchMapViewController.m
//  bikepath
//
//  Created by Farheen Malik on 8/14/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import "SearchMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <MapKit/MapKit.h>
#import "SearchItem.h"
#import "AppDelegate.h"

@interface SearchMapViewController ()

@end

@implementation SearchMapViewController {
    
}

- (void)viewDidLoad

{
    [super viewDidLoad];
    
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel loadCitiBikeData];
  
    GMSCameraPosition *startLocation = [GMSCameraPosition cameraWithLatitude:40.706638
                                                         longitude:-74.009070
                                                              zoom:16];
    
//    GMSCameraPosition *startLocation = [GMSCameraPosition cameraWithLatitude:37.7848395
//                                                            longitude:-122.4041945
//                                                                 zoom:15];
    
    [self.mapView setCamera:startLocation];
    self.mapView.mapType                    = kGMSTypeNormal;
    self.mapView.myLocationEnabled          = YES;
    self.mapView.settings.compassButton     = YES;
    self.mapView.settings.myLocationButton  = YES;
    self.mapView.settings.zoomGestures      = YES;
    self.mapView.delegate                   = self;
    
    for(id station in appDel.stationJSON) {
        NSString *latitude          = [station objectForKey:@"latitude"];
        NSString *longitude         = [station objectForKey:@"longitude"];
        NSString *title             = [station objectForKey:@"stationName"];
        NSString *availableBikes    = [[station objectForKey:@"availableBikes"] stringValue];
        NSNumber *num               = @([[station objectForKey:@"availableBikes"] intValue]);
        
        GMSMarker *citiMarker   = [[GMSMarker alloc] init];
        citiMarker.position     = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
        citiMarker.title        = title;
        citiMarker.map          = self.mapView;
        
        if ([num intValue] > 0) {
            citiMarker.icon = [UIImage imageNamed:@"bicycleGreen"];
            citiMarker.snippet  = [NSString stringWithFormat:@"Bicyles available: %@", availableBikes];
        } else {
            citiMarker.icon = [UIImage imageNamed:@"bicycleRed"];
            citiMarker.snippet = @"No bicyles available at this location.";
        };
        citiMarker.map = self.mapView;
    }
}


@end



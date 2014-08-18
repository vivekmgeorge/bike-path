//
//  GMSMarkerFactory.m
//  bikepath
//
//  Created by Armen Vartan on 8/18/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import "GMSMarkerFactory.h"
#import <GoogleMaps/GoogleMaps.h>

@implementation GMSMarkerFactory
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(locationManager.location.coordinate);
    GMSMarker *startPoint = [GMSMarker markerWithPosition:postion];
    startPoint.title = @"Start";
    startPoint.map = mapView_;
}

@end

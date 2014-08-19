//
//  GMSMarkerFactory.m
//  bikepath
//
//  Created by Armen Vartan on 8/18/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import "GMSMarkerFactory.h"
#import <GoogleMaps/GoogleMaps.h>
#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>
#import "MDDirectionService.h"
#import <CoreLocation/CoreLocation.h>
#import "StationFinder.h"
#import "GMSMarkerFactory.h"


@implementation GMSMarkerFactory
+ (CLLocationCoordinate2D)createGMSMarker:(CLLocationCoordinate2D*) locationCoordinates
                                  mapView:(GMSMapView*) map{
    GMSMarker *marker = [GMSMarker markerWithPosition:*locationCoordinates];
    marker.title = @"Start";
    marker.map = map;
}

@end

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
+ (GMSMarker*)createGMSMarker:(CLLocationCoordinate2D*) locationCoordinates
                      mapView:(GMSMapView*) map
                        title:(NSString*) title
                        color:(UIColor*) color{
    GMSMarker *marker = [GMSMarker markerWithPosition:*locationCoordinates];
    marker.title = title;
    marker.map = map;
    marker.icon = color;
    return marker;
}
@end

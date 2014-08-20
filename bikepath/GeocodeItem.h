//
//  GeocodeItem.h
//  bikepath
//
//  Created by Farheen Malik on 8/19/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface GeocodeItem : NSObject

@property NSString *latitude;
@property NSString *longitude;
@property CLLocation *position;
@property NSString *address;
@property (readonly) NSDate *creationDate;

@end

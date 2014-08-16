//
//  SearchItem.h
//  bikepath
//
//  Created by Farheen Malik on 8/15/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface SearchItem : NSObject

@property NSString *searchQuery;
//@property CLLocationCoordinate2D *position;
@property (readonly) NSDate *creationDate;

@end

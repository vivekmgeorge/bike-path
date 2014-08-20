//
//  AddressGeocoderFactory.h
//  bikepath
//
//  Created by Farheen Malik on 8/19/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPGooglePlacesAutocomplete.h"
#import <UIKit/UIKit.h>
#import "GeocodeItem.h"

@interface AddressGeocoderFactory : NSObject

//+ (GeocodeItem*) translateAddressToGeocodeObject:(NSString*)addressString;

+ (NSString*)translateAddresstoUrl:(NSString*)addressString;
//
+ (NSMutableDictionary*)translateUrlToGeocodedObject:(NSString*)url;

@end

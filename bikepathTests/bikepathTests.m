//
//  bikepathTests.m
//  bikepathTests
//
//  Created by Vivek George, Molly Huerster, Farheen Malik and Armen Vartan on 8/14/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import "Kiwi.h"
#import <CoreLocation/CoreLocation.h>
#import "StationFinder.h"
#import "AddressGeocoderFactory.h"
#import "GMSMarkerFactory.h"
#import <GoogleMaps/GoogleMaps.h>

SPEC_BEGIN(MathSpec)

describe(@"Math", ^{
    it(@"is pretty cool", ^{
        NSUInteger a = 16;
        NSUInteger b = 26;
        [[theValue(a + b) should] equal:theValue(42)];
    });
});

SPEC_END

SPEC_BEGIN(BikePathSpec)

describe(@"AddressGeocoderFactory", ^{
    it(@"translates a street address to a URL",^{
        NSString *address = @"48 Wall St New York NY";
        NSString *translatedAddress = [AddressGeocoderFactory translateAddresstoUrl:address];
        [[translatedAddress should] containString:@"https://maps.googleapis.com/maps/api/geocode/json?address="];
        [[translatedAddress should] containString:@"48+Wall+St+New+York+NY"];
    });
    it(@"translates a query URL to a geocoded object",^{
        NSString *url = @"https://maps.googleapis.com/maps/api/geocode/json?address=48+Wall+St+&key=AIzaSyAxaqfMyyc-WSrvsWP_jF2IUaTZVjkMlFo";
        NSMutableDictionary *geocodedObject = [AddressGeocoderFactory translateUrlToGeocodedObject:url];
        [[[geocodedObject allKeys]should]containObjects:@"latitude",@"longitude",@"position", nil];
    });
});

describe(@"GMSMarkerFactory", ^{
    it(@"creates a marker for a trip start point", ^{
//       do stuff
    });
    it(@"creates a marker for a full bike station",^{
//        do stuff
    });
    it(@"creates a marker for an empty bike station",^{
//        do stuff
    });
});

describe(@"NYCBikeData", ^{
    it(@"extracts station list from json response", ^{
        // load fake response data into memory
        NSString *bikepathjsonPath = [[@__FILE__ stringByDeletingLastPathComponent] stringByAppendingString: @"/nycbikesresponse.json"];
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:bikepathjsonPath];
        NSDictionary *bikepathjson = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0
                                                                   error:NULL];
        // get the station list
        NSArray *stations = [bikepathjson objectForKey:@"stationBeanList"];
        
        // set a location to search
        CLLocation *currentLocation = [[CLLocation alloc]
                                initWithLatitude: 40.76727216
                                longitude: -73.99392888];
        
        NSDictionary *closestStation = [StationFinder findClosestStation:stations location:currentLocation];
        
//        print result (not an assertion)
        NSLog(@"%@", closestStation);
        
    });
});

describe(@"ErrorMessage",^{
    it(@"is an instance of class error message", ^{
        id errorMock = [UIAlertView mock];
        [ [errorMock should] beMemberOfClass:[UIAlertView class]];
    });
});

SPEC_END

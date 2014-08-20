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

SPEC_BEGIN(MathSpec)

describe(@"Math", ^{
    it(@"is pretty cool", ^{
        NSUInteger a = 16;
        NSUInteger b = 26;
        [[theValue(a + b) should] equal:theValue(42)];
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

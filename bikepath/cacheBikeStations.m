//
//  cacheBikeStations.m
//  bikepath
//
//  Created by Molly Huerster on 8/19/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import "cacheBikeStations.h"
#import <GoogleMaps/GoogleMaps.h>

@implementation cacheBikeStations

@synthesize sortedBikeStations;

-(NSArray*)loadAndCacheStations
{
//    NSArray *sortedStations;
    
    
//    NSURLCache *citiBikeCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
//                                                              diskCapacity:20 * 1024 * 1024
//                                                                  diskPath:nil];
//    
//    [citiBikeCache removeAllCachedResponses];
//    NSLog(@"%i",citiBikeCache.currentDiskUsage);
//    NSLog(@"%i",citiBikeCache.currentMemoryUsage);
//
//    
//    [NSURLCache setSharedURLCache:citiBikeCache];
//
//    NSURL *url = [NSURL URLWithString:@"http://www.citibikenyc.com/stations/json"];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url
//                                                           cachePolicy: NSURLRequestReturnCacheDataElseLoad
//                                                       timeoutInterval: 120.0];
//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:[NSOperationQueue mainQueue]
//                           completionHandler:^(NSURLResponse *response,
//                                           NSData *data, NSError *connectionError)
//    {
//        if (data.length > 0 && connectionError == nil)
//        {
//         
//            NSLog(@"%i",citiBikeCache.currentDiskUsage);
//            NSLog(@"%i",citiBikeCache.currentMemoryUsage);
//         
//            NSDictionary *citiBikeJSON = [NSJSONSerialization JSONObjectWithData:data
//                                                                      options:0
//                                                                        error:NULL];
//            NSArray* stations = [citiBikeJSON objectForKey:@"stationBeanList"];
//            NSSortDescriptor *sortDescriptor;
//            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"availableBikes"
//                                                      ascending:NO];
//            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
//            __block NSArray *sortedStations = [stations sortedArrayUsingDescriptors:sortDescriptors];
//         
//            NSLog(@"Current Memory Usage: %i", [citiBikeCache currentMemoryUsage]);
//            NSLog(@"Current Disk Usage: %i", [citiBikeCache currentDiskUsage]);
//         
//            for(id st in sortedStations) {
//                NSDictionary *station = (NSDictionary *)st;
//                NSString *lati             = [station objectForKey:@"latitude"];
//             	NSString *longi            = [station objectForKey:@"longitude"];
//                CLLocation *location = [[CLLocation alloc] initWithLatitude:[lati doubleValue] longitude:([longi doubleValue] *2)];
//                NSMutableArray *locations = [[NSMutableArray alloc] init];
//                [locations addObject:location];
//            }
//            NSLog(@"%@",sortedStations);
//            sortedBikeStations = sortedStations;
//        }
//    }];
    return 0;
}

@end

//
//  AddressGeocoderFactory.m
//  bikepath
//
//  Created by Farheen Malik on 8/19/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import "AddressGeocoderFactory.h"

@implementation AddressGeocoderFactory

//+ (GeocodeItem*)translateAddressToGeocodeObject:(NSString*) addressString {
+ (NSString*)translateAddresstoUrl:(NSString*)addressString{
    //create api url
    NSString *address = addressString;
    NSArray *addressItems = [address componentsSeparatedByString:@" "];
    NSMutableArray *addressCombinedArray = [[NSMutableArray alloc] init];
    for (NSString *addressPart in addressItems){
        [addressCombinedArray addObject:[[NSString alloc] initWithFormat:@"%@+", addressPart]];
    }
    NSString *addressCombinedString = [addressCombinedArray componentsJoinedByString:@""];
    NSString *kGoogleGeocodeApiUrl = @"https://maps.googleapis.com/maps/api/geocode/json?address=";
    NSString *kGoogleGeocodeApiKey = @"AIzaSyAxaqfMyyc-WSrvsWP_jF2IUaTZVjkMlFo";
    NSString *addressForJson = [[NSString alloc] initWithFormat:@"%@%@&key=%@", kGoogleGeocodeApiUrl, addressCombinedString, kGoogleGeocodeApiKey];
    return addressForJson;
//    GeocodeItem *geocodeAddress = [[GeocodeItem init] alloc];
//    NSURL *url = [NSURL URLWithString: addressForJson];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:[NSOperationQueue mainQueue]
//                           completionHandler:^(NSURLResponse *response,
//                                               NSData *data, NSError *connectionError) {
//                               if (data.length > 0 && connectionError == nil) {
//                                   
//                                   // parse json to create object
//                                   NSDictionary *addressJson = [NSJSONSerialization
//                                                                JSONObjectWithData:data
//                                                                options:0
//                                                                error:NULL];
//                                   
//                                   NSArray *addressParts = [[addressJson objectForKey:@"results"] valueForKey:@"geometry"];
//                                   NSString *formattedAddress = [addressParts valueForKey:@"formatted_address"];
//                                   for(id info in addressParts){
//                                       NSDictionary *addressPartsLocation = (NSDictionary *)[addressParts valueForKey:@"location"];
//                                       NSString *lati = [addressPartsLocation objectForKey:@"lat"];
//                                       NSString *longi = [addressPartsLocation objectForKey:@"lng"];
//                                       CLLocation *location = [[CLLocation alloc] initWithLatitude:[lati doubleValue] longitude:[longi doubleValue]];
//                                       geocodeAddress.latitude = lati;
//                                       
//                                       NSLog(@"geocode address: %@", geocodeAddress.latitude);
//                                       
//                                       geocodeAddress.longitude = longi;
//                                       geocodeAddress.position = location;
//                                   }
//                                   geocodeAddress.address = formattedAddress;
//                               }
//                           }];
//    return geocodeAddress;

}
    
+ (GeocodeItem*)translateUrlToGeocodedObject:(NSString*)addressUrl {
    GeocodeItem *geocodeAddress = [[GeocodeItem init] alloc];
    NSURL *url = [NSURL URLWithString: addressUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                NSData *data, NSError *connectionError) {
         if (data.length > 0 && connectionError == nil) {
             
             // parse json to create object
             NSDictionary *addressJson = [NSJSONSerialization
                                      JSONObjectWithData:data
                                      options:0
                                      error:NULL];
         
             NSArray *addressParts = [[addressJson objectForKey:@"results"] valueForKey:@"geometry"];
             NSString *formattedAddress = [addressParts valueForKey:@"formatted_address"];
             for(id info in addressParts){
                 NSDictionary *addressPartsLocation = (NSDictionary *)[addressParts valueForKey:@"location"];
                 NSString *lati = [addressPartsLocation objectForKey:@"lat"];
                 NSString *longi = [addressPartsLocation objectForKey:@"lng"];
                 CLLocation *location = [[CLLocation alloc] initWithLatitude:[lati doubleValue] longitude:[longi doubleValue]];
                 geocodeAddress.latitude = lati;
                 
                 NSLog(@"geocode address: %@", geocodeAddress.latitude);
                 
                 geocodeAddress.longitude = longi;
                 geocodeAddress.position = location;
             }
             geocodeAddress.address = formattedAddress;
         }
    }];
    return geocodeAddress;
}
@end

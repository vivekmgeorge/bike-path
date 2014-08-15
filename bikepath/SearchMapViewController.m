//
//  SearchMapViewController.m
//  bikepath
//
//  Created by Farheen Malik on 8/14/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import "SearchMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <MapKit/MapKit.h>

@interface SearchMapViewController ()

@end

@implementation SearchMapViewController {

    GMSMapView *mapView_;
}


- (IBAction)unwindToSearchPage:(UIStoryboardSegue *)segue {
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:40.706638
                                                            longitude:-74.009070
                                                                 zoom:14];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    mapView_.settings.myLocationButton = YES;
    mapView_.settings.zoomGestures = YES;
    
    self.view = mapView_;
    //
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = @"222 Fulton Street New York NY";
    
    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (response.mapItems.count == 0)
            NSLog(@"No Matches");
        else
            for (MKMapItem *item in response.mapItems)
            {
                GMSMarker *marker = [[GMSMarker alloc] init];
                marker.position = CLLocationCoordinate2DMake(item.placemark.location.coordinate.latitude, item.placemark.location.coordinate.longitude);
                marker.title = item.name;
                marker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
                marker.map = mapView_;
                NSLog(@"latitude = %f", item.placemark.location.coordinate.latitude);
                NSLog(@"longitude = %f", item.placemark.location.coordinate.longitude);
            }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

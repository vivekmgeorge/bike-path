//
//  SearchMapViewController.m
//  bikepath
//
//  Created by Farheen Malik on 8/14/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import "SearchMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface SearchMapViewController ()

@end

@implementation SearchMapViewController {

}

- (IBAction)unwindToSearchPage:(UIStoryboardSegue *)segue {
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:40.706638
//                                                            longitude:-74.009070
//                                                                 zoom:14];
    
//    [mapView_ setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
//    NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=CSV", "FETCH TEXT FROM SEARCH BAR" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
//
    self.mapView.mapType = kGMSTypeNormal;
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.settings.zoomGestures = YES;
    self.mapView.delegate = self;
//
//    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

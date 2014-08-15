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
   

//- (IBAction)unwindToList:(UIStoryboardSegue *)segue
//{
//    
//}
//
    GMSMapView *mapView_;
}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [mapView_ addObserver:self forKeyPath:@"myLocation" options:0 context: nil];
//}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    if([keyPath isEqualToString:@"myLocation"]) {
//        CLLocation *location = [object myLocation];
//        NSLog(@"User's location: %@", mapView_.myLocation);
//        
//        CLLocationCoordinate2D target = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
//    }
//}
//
//-(void)dealloc {
//    [mapView_ removeObserver:self forKeyPath:@"myLocation"];
//}
//
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:target
//                                                               zoom:10];
    
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    //    mapView_ = [[GMSMapView alloc] initWithFrame:self.view.bounds];
    
    mapView_.myLocationEnabled = YES;
    //    NSLog(@"User's location: %@", mapView_.myLocation);
    
    mapView_.settings.myLocationButton = YES;
    //    mapView_.settings.compassButton = YES;
    
    mapView_.settings.zoomGestures = YES;
    
    self.view = mapView_;
}
//
////- (void)didTapMyLocationButtonForMapView: (GMSMapView*) mapView{
////    NSLog(@"User's location: %@", mapView_.myLocation);
//////    return YES;
////}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}


@end

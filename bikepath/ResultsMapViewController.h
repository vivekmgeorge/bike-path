//
//  ResultsMapViewController.h
//  bikepath
//
//  Created by Farheen Malik on 8/14/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface ResultsMapViewController : UIViewController <GMSMapViewDelegate>

- (IBAction)unwindToSearchPage:(UIStoryboardSegue *)segue;

@property (strong, nonatomic) IBOutlet GMSMapView *mapView;

@end

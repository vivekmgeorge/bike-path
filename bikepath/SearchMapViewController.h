//
//  SearchMapViewController.h
//  bikepath
//
//  Created by Farheen Malik on 8/14/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface SearchMapViewController : UIViewController <GMSMapViewDelegate>
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;


@end

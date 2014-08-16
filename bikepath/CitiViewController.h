//
//  CitiViewController.h
//  bikepath
//
//  Created by Apprentice on 8/15/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface CitiViewController : UIViewController <GMSMapViewDelegate>
@property (strong, nonatomic) IBOutlet GMSMapView *mapView;
@end

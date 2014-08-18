//
//  GooglePlacesAutocompleteViewController.h
//  bikepath
//
//  Created by Farheen Malik on 8/17/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class SPGooglePlacesAutocompleteQuery;

@interface GooglePlacesAutocompleteViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate, MKMapViewDelegate>
{
    NSArray *searchResultPlaces;
    SPGooglePlacesAutocompleteQuery *searchQuery;
    MKPointAnnotation *selectedPlaceAnnotation;
    
    BOOL shouldBeginEditing;
}
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

//@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
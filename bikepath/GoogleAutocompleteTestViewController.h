//
//  GoogleAutocompleteTestViewController.h
//  bikepath
//
//  Created by Apprentice on 8/17/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>

@class SPGooglePlacesAutocompleteQuery;

@interface GoogleAutocompleteTestViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate, MKMapViewDelegate>
{
    NSArray *searchResultPlaces;
    SPGooglePlacesAutocompleteQuery *searchQuery;
    MKPointAnnotation *selectedPlaceAnnotation;
    
    BOOL shouldBeginEditing;
}
//@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;


//@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end

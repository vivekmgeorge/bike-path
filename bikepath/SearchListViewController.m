//
//  SearchListViewController.m
//  bikepath
//
//  Created by Farheen Malik on 8/16/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import "SearchListViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <MapKit/MapKit.h>
#import "SearchItem.h"

@interface SearchListViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *array;
@property (strong, nonatomic) NSArray *searchResults;

@end

@implementation SearchListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.array = [[NSArray alloc] init];
    self.searchResults = [[NSArray alloc] init];
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    
    request.naturalLanguageQuery = @"Starbucks, New York, NY";
    //    request.naturalLanguageQuery = @"48 Wall Street New York NY";
    
    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (response.mapItems.count == 0)
            NSLog(@"no items");
        else
            for (MKMapItem *item in response.mapItems)
            {
                GMSMarker *marker = [[GMSMarker alloc] init];
                marker.position = CLLocationCoordinate2DMake(item.placemark.location.coordinate.latitude, item.placemark.location.coordinate.longitude);
                marker.title = item.name;
                marker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
                NSLog(@"title = %@", marker.title);
            }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    //    [searchBar setShowsCancelButton:YES animated:YES];
    //    [self keyboardWillShow];
}
-(void) searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    //    [self keyboardWillHide];
    //    searchBar.text=@"";
    //
    //    [searchBar setShowsCancelButton:NO animated:YES];
    //    [searchBar resignFirstResponder];
}

-(void) searchBar: (UISearchBar *) searchBar textDidChange:(NSString *) searchText
{
    // Use this delegate if you want to make ur app to show the search results while the user entering their search item in search bar…
    // Am going to put the search functionality in Search button click delegate…
}

-(void) searchBarSearchButtonClicked: (UISearchBar *) searchBar
{
    //    if (self.searchField.text.length > 0) {
    //        self.search = [[SearchItem alloc] init];
    //        self.search.searchQuery = self.searchField.text;
    //    }
    //    NSLog(self.search.searchQuery);
    //    NSLog(searchBar.text);
    //    return self.search.searchQuery;
    
}


#pragma Table View Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchResults count];

    } else {
        return [self.array count];
    }
    //    return [self.array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [self.searchResults objectAtIndex:indexPath.row];

    } else {
        cell.textLabel.text = [self.array objectAtIndex:indexPath.row];
    }
    //    cell.textLabel.text = [self.array objectAtIndex:indexPath.row];
    return cell;
}

@end




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
@property (strong, nonatomic) IBOutlet UISearchBar *searchField;
//@property (strong, nonatomic) NSMutableArray *searchResults;

@end

@implementation SearchListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchResults = [[NSMutableArray alloc] init];
//    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    //    [self keyboardWillShow];
}
-(void) searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    //    [self keyboardWillHide];
    searchBar.text=@"";
    [searchBar setShowsCancelButton:NO animated:YES];
    //    [searchBar resignFirstResponder];
}

-(void) searchBar: (UISearchBar *) searchBar textDidChange:(NSString *) searchText
{
}

-(NSMutableArray*) searchBarSearchButtonClicked: (UISearchBar *) searchBar
{
    self.searchLocation = [[SearchItem alloc] init];
    self.searchLocation.searchQuery = self.searchField.text;
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = self.searchLocation.searchQuery;
    
    NSLog(self.searchLocation.searchQuery);
    
    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (response.mapItems.count == 0)
            NSLog(@"no items");
        else
            for (MKMapItem *item in response.mapItems)
            {
                NSLog(item.name);
                
                SearchItem *query = [[SearchItem alloc] init];
                    query.searchQuery = item.name;
//                    query.position = CLLocationCoordinate2DMake(item.placemark.location.coordinate.latitude, item.placemark.location.coordinate.longitude);

                NSLog(@"HERE");
                NSLog(query.searchQuery);
                
                [self.searchResults addObject:query];
            }
    }];
//    [self.tableView reloadData];
    return self.searchResults;
}


#pragma Table View Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"ListPrototypeCell" forIndexPath:indexPath];
    SearchItem *item = (SearchItem*)[self.searchResults objectAtIndex:indexPath.row];
    cell.textLabel.text = item.searchQuery;
    return cell;
}


#pragma Search Methods

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSLog(@"now here");
    [self.tableView reloadData];
//    [self filterContentForSearchText:searchString
//    scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
//                                      objectAtIndex:[self.searchDisplayController.searchBar
//                                                     selectedScopeButtonIndex]];
////
    return YES;
}

@end




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
//@property (strong, nonatomic) NSArray *array;
@property (strong, nonatomic) NSMutableArray *searchResults;

@end

@implementation SearchListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.array = [[NSArray alloc] init ]; //WithObjects:@"Apple", @"Samsung", @"HTC", @"LG", @"Moto", nil];
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
    // Use this delegate if you want to make ur app to show the search results while the user entering their search item in search bar…
    // Am going to put the search functionality in Search button click delegate…
}

-(NSMutableArray *) searchBarSearchButtonClicked: (UISearchBar *) searchBar
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
        [self.tableView reloadData];
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

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellID = @"cellID";
//    NSLog(@"zomg");
//    
////    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"ListPrototypeCell" forIndexPath:indexPath];
//    // Configure the cell...
//    SearchItem *item = (SearchItem*)[self.searchResults objectAtIndex:indexPath.row];
////    ToDoItem *toDoItem = [self.toDoItems objectAtIndex:indexPath.row];
//    cell.textLabel.text = item.searchQuery;
//    
////    if (cell == nil)
//    {
////        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//    }
//    if (tableView == self.searchDisplayController.searchResultsTableView) {
//        NSLog(@"zomg");
//        SearchItem *item = (SearchItem*)[self.searchResults objectAtIndex:indexPath.row];
//        NSLog(item.searchQuery);
//        
//        NSLog([self.searchResults objectAtIndex:indexPath.row]);
////cell.textLabel.text = [self.searchResults objectAtIndex:indexPath.row];
//        
//    } else {
////        cell.textLabel.text = [self.array objectAtIndex:indexPath.row];
//    }
//    //    cell.textLabel.text = [self.array objectAtIndex:indexPath.row];


#pragma Search Methods

//- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
//{
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", searchText];
//    //    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"contains[c] %@", searchText];
//    self.searchResults = [self.array filteredArrayUsingPredicate:predicate];
//}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self.tableView reloadData];
//    [self filterContentForSearchText:searchString
//    scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
//                                      objectAtIndex:[self.searchDisplayController.searchBar
//                                                     selectedScopeButtonIndex]];
////
    return YES;
}

@end




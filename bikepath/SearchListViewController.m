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

@interface SearchListViewController () <UITableViewDataSource, UITableViewDelegate>

//@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchField;
@property (strong, nonatomic) NSMutableArray *searchResults;
@property (strong,nonatomic) UITableView *tableView;
@property(strong,nonatomic) UISearchBar *mySearchBar;

@end

@implementation SearchListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchResults = [[NSMutableArray alloc] init];
 
    self.mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 70, 320, 44)];
    //set the delegate to self so we can listen for events
    self.mySearchBar.delegate = self;
    //display the cancel button next to the search bar
    self.mySearchBar.showsCancelButton = YES;
    //add the search bar to the view
    [self.view addSubview:self.mySearchBar];
    

    //
}

//- (id) initWithNibName:(NSString *)nibName bundle:(NSString*)bundleName
//{
//    self = [super initWitNibName:nibName bundle:bundleName];
//    if (self)
//    {
//        
//    }
//    return self;
//}

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

-(void) searchBarSearchButtonClicked: (UISearchBar *) searchBar
{
    self.searchLocation = [[SearchItem alloc] init];
    self.searchLocation.searchQuery = self.mySearchBar.text;
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
                SearchItem *query = [[SearchItem alloc] init];
                query.searchQuery = item.name;
//                    query.position = CLLocationCoordinate2DMake(item.placemark.location.coordinate.latitude, item.placemark.location.coordinate.longitude);
                [self.searchResults addObject:query];
            }
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.view addSubview:self.tableView];
//        [self.tableView reloadData];

    }];
}

-(void)showResultsTable
{
 
}
#pragma Table View Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchResults count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    SearchItem *item = (SearchItem*)[self.searchResults objectAtIndex:indexPath.row];
    cell.textLabel.text = item.searchQuery;
//    cell.textLabel.text = @"foo";
    return cell;
}

@end




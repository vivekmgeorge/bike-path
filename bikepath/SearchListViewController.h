//
//  SearchListViewController.h
//  bikepath
//
//  Created by Farheen Malik on 8/16/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchItem.h"

@interface SearchListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate>

@property SearchItem *searchLocation;

@end

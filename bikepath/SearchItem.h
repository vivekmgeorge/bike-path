//
//  SearchItem.h
//  bikepath
//
//  Created by Farheen Malik on 8/15/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SearchItem : NSObject

@property NSString *searchQuery;
@property (readonly) NSDate *creationDate;

@end

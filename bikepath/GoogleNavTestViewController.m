//
//  GoogleNavTestView Controller.m
//  bikepath
//
//  Created by Farheen Malik on 8/18/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import "GoogleNavTestViewController.h"

@implementation GoogleNavTestViewController

//@synthesize launchNav;

- (void)loadView {
    
    //allocate the view
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    
    //set the view's background color
    self.view.backgroundColor = [UIColor whiteColor];
    
    //create the button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    //set the position of the button
    button.frame = CGRectMake(100, 170, 100, 30);
    
    //set the button's title
    [button setTitle:@"Click Me!" forState:UIControlStateNormal];
    
    //listen for clicks
    [button addTarget:self action:@selector(buttonPressed)
     forControlEvents:UIControlEventTouchUpInside];
    
    //add the button to the view
    [self.view addSubview:button];
}

-(void)buttonPressed {
    NSLog(@"Button Pressed!");
    NSURL *testURL = [NSURL URLWithString:@"comgooglemaps-x-callback://"];
    if ([[UIApplication sharedApplication] canOpenURL:testURL]) {
        NSString *directionsRequest = @"comgooglemaps-x-callback://?daddr=John+F.+Kennedy+International+Airport,+Van+Wyck+Expressway,+Jamaica,+New+York&x-success=sourceapp://?resume=true&x-source=AirApp";
        NSURL *directionsURL = [NSURL URLWithString:directionsRequest];
        [[UIApplication sharedApplication] openURL:directionsURL];
    } else {
        NSLog(@"Can't use comgooglemaps-x-callback:// on this device.");
    }
}

// https://developers.google.com/maps/documentation/ios/urlscheme#add_navigation_to_your_app
//NSURL *testURL = [NSURL URLWithString:@"comgooglemaps-x-callback://"];
//if ([[UIApplication sharedApplication] canOpenURL:testURL]) {
//    NSString *directionsRequest = @"comgooglemaps-x-callback://" +
//    @"?daddr=John+F.+Kennedy+International+Airport,+Van+Wyck+Expressway,+Jamaica,+New+York" +
//    @"&x-success=sourceapp://?resume=true&x-source=AirApp";
//    NSURL *directionsURL = [NSURL URLWithString:directionsRequest];
//    [[UIApplication sharedApplication] openURL:directionsURL];
//} else {
//    NSLog(@"Can't use comgooglemaps-x-callback:// on this device.");
//}
@end

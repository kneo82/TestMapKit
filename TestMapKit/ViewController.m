//
//  ViewController.m
//  TestMapKit
//
//  Created by Admin on 21/03/15.
//  Copyright (c) 2015 IDAPGroup. All rights reserved.
//


#import "ViewController.h"
#import <AFNetworking.h>

#define METERS_PER_MILE 1609.344

@interface ViewController () 

@end

@implementation ViewController

#pragma mark -
#pragma mark Class methods

#pragma mark -
#pragma mark Initializations and Deallocations

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    #ifdef __IPHONE_8_0
        if(IS_OS_8_OR_LATER) {
            // Use one or the other, not both. Depending on what you put in info.plist
            CLLocationManager *locationManager = [[CLLocationManager alloc] init];
            [locationManager requestWhenInUseAuthorization];
        }
    #endif
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 39.281516;
    zoomLocation.longitude= -76.580806;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5 *METERS_PER_MILE);
    [self.mapView setRegion:viewRegion animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark -
#pragma mark Accessors

#pragma mark -
#pragma mark Public

- (IBAction)onRefresh:(id)sender{
    // 1
    MKCoordinateRegion mapRegion = [_mapView region];
    CLLocationCoordinate2D centerLocation = mapRegion.center;
    
    // 2
    NSString *locationParam = [NSString stringWithFormat:@"within_circle(location_1, %f, %f, %f)",
                                                           centerLocation.latitude,
                                                           centerLocation.longitude,
                                                           0.5*METERS_PER_MILE];
    
    NSDictionary *params = @{@"$where" : locationParam};

     NSString *url = @"https://data.baltimorecity.gov/resource/3i3v-ibrt.json";

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseString = responseObject;
        NSLog(@"Response: %@", responseString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark -
#pragma mark Private

@end

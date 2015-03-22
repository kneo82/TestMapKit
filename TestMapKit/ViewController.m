//
//  ViewController.m
//  TestMapKit
//
//  Created by Admin on 21/03/15.
//  Copyright (c) 2015 IDAPGroup. All rights reserved.
//


#import "ViewController.h"
#import <AFNetworking.h>

#import "MyLocation.h"

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
        
        [self plotCrimePositions:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark -
#pragma mark Private

- (void)plotCrimePositions:(id)responseData {
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        [_mapView removeAnnotation:annotation];
    }
    
    for (NSDictionary *item in responseData) {
        NSDictionary *location = item[@"location_1"];
        
        NSNumber * latitude = [NSDecimalNumber decimalNumberWithString:location[@"latitude"]];
        NSNumber * longitude = [NSDecimalNumber decimalNumberWithString:location[@"longitude"]];
        NSString * crimeDescription = item[@"chargedescription"];
        NSString * address = item[@"arrestlocation"];

        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latitude.doubleValue;
        coordinate.longitude = longitude.doubleValue;
        MyLocation *annotation = [[MyLocation alloc] initWithName:crimeDescription address:address coordinate:coordinate] ;
        [_mapView addAnnotation:annotation];
    }
}

#pragma mark -
#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[MyLocation class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            UIImage *image = [UIImage imageNamed:@"arrest"];
            annotationView.image = image;// [UIImage imageNamed:@"arrest"];//here we use a nice image instead of the default pins
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}

@end

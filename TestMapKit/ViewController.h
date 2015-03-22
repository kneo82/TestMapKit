//
//  ViewController.h
//  TestMapKit
//
//  Created by Admin on 21/03/15.
//  Copyright (c) 2015 IDAPGroup. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface ViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>
@property(nonatomic, retain) IBOutlet MKMapView *mapView;
@property(nonatomic, retain) CLLocationManager *locationManager;
- (IBAction)onRefresh:(id)sender;

@end


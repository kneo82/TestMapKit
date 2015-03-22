//
//  MyLocation.h
//  TestMapKit
//
//  Created by Admin on 22/03/15.
//  Copyright (c) 2015 IDAPGroup. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>

@interface MyLocation : NSObject <MKAnnotation>

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;
- (MKMapItem*)mapItem;

@end

//
//  MapController.h
//  CookingApp
//
//  Created by Christopher Harris on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>

#define METERS_PER_MILE 1609.344

@interface MapController : UIViewController <MKMapViewDelegate>
{
    CLLocationManager *locationManager;
    IBOutlet MKMapView *map;
}

@property (retain, nonatomic) CLLocationManager *locationManager;
@property (retain, nonatomic) IBOutlet UILabel *locationLabelOne;
@property (retain, nonatomic) IBOutlet UILabel *locationLabelTwo;
@property (nonatomic, retain) IBOutlet MKMapView *map;

@end

//
//  MapController.m
//  CookingApp
//
//  Created by Christopher Harris on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "MapController.h"

@implementation MapController

@synthesize locationManager;
@synthesize locationLabelOne;
@synthesize locationLabelTwo;
@synthesize map;

- (id)init
{
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self buildMap];
    [self setLocationManager:[[CLLocationManager alloc] init]];
    [locationManager setDelegate:(id)self];
    [locationManager setDistanceFilter:kCLDistanceFilterNone]; 
    [locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [locationManager startUpdatingLocation];
    [map setShowsUserLocation:YES];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

- (void)buildMap
{
    map = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, STD_WIDTH, 367)];
    [map setDelegate:self];
    [map setShowsUserLocation:YES];
    [map setZoomEnabled:YES];
    [map setScrollEnabled:YES];
    [map setUserInteractionEnabled:YES];
    [self.view addSubview:map];
}


-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"Did update user location: %f,%f", userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    [map setCenterCoordinate:userLocation.location.coordinate];
    [self setUserRegion:userLocation];
    [self getDefaultPinData];
}

- (void)setUserRegion:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region;
    region.center.latitude = userLocation.coordinate.latitude;
    region.center.longitude = userLocation.coordinate.longitude;
    region.span.longitudeDelta = 0.05;
    region.span.latitudeDelta = 0.05;
    [map setRegion:region];
}

- (void)getDefaultPinData
{
    NSString *string_url = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&sensor=false"];
    //NSString *encoded_string_url = [string_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:string_url]];
    [request setTimeoutInterval:30.0f];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request
                     queue:queue
                     completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                         if(!error) {
                             [self parseGData:data];
                         } else {
                             NSLog(@"***** Error: %@", error);
                         }
     }];
}

- (void)parseGData:(NSData *)data
{
    NSError *error;
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if(error){
        NSLog(@"***** Error: %@", error);
        return;
    }
    NSLog(@"%@",jsonData);
    
}

-(void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    NSLog(@"Will start loading map");
}

-(void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    NSLog(@"Did finish loading map");    
}

-(void)mapViewWillStartLocatingUser:(MKMapView *)mapView
{
    NSLog(@"Will start locating user");
}

-(void)mapViewDidStopLocatingUser:(MKMapView *)mapView
{
    NSLog(@"Did stop locating user");
}

-(void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    NSLog(@"Did fail loading map");
}

-(void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied){
        NSLog(@"User refused location services");
    } else {
        NSLog(@"Did fail to locate user with error: %@", error.description);    
    }    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

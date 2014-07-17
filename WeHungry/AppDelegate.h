//
//  AppDelegate.h
//  WeHungry
//
//  Created by Max Campolo on 7/16/14.
//  Copyright (c) 2014 Maxim Campolo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) CLLocationManager *customLocationManager;
@property (strong,nonatomic) CLLocation *currentUserLocation;

- (void)updateCurrentLocation;
- (void)stopUpdatingCurrentLocation;

@end

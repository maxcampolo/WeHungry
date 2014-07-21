//
//  RestaurantModel.h
//  WeHungry
//
//  Created by Max Campolo on 7/16/14.
//  Copyright (c) 2014 Maxim Campolo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestaurantModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *thumbURL;
@property (nonatomic, strong) NSString *ratingURL;
@property (nonatomic, strong) NSString *yelpURL;
@property (nonatomic, strong) NSString *mobileURL;
@property (nonatomic, strong) NSString *phone;

@end

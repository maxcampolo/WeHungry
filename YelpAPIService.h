//
//  YelpAPIService.h
//  WeHungry
//
//  Created by Max Campolo on 7/16/14.
//  Copyright (c) 2014 Maxim Campolo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthConsumer.h"

@protocol YelpAPIServiceDelegate <NSObject>
-(void)loadResultWithDataArray:(NSArray *)resultArray;
@end

@interface YelpAPIService : NSObject <NSURLConnectionDataDelegate>

@property(nonatomic, strong) NSMutableData *urlRespondData;
@property(nonatomic, strong) NSString *responseString;
@property(nonatomic, strong) NSMutableArray *resultArray;

@property (weak, nonatomic) id <YelpAPIServiceDelegate> delegate;

-(void)searchNearByRestaurantsByFilter:(NSString *)categoryFilter atLatitude:(CLLocationDegrees)latitude
                          andLongitude:(CLLocationDegrees)longitude;
- (void)searchNearByRestaurantsByFilter:(NSString *)categoryFilter andRadiusFilter:(float)radiusFilter atLatitude:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude;

@end

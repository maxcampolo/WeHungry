//
//  YelpAPISearchQueries.h
//  WeHungry
//
//  Created by Max Campolo on 7/21/14.
//  Copyright (c) 2014 Maxim Campolo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YelpAPISearchQueries : NSObject

+ (NSString *)getQueryFromString:(NSString *)searchString;

@end

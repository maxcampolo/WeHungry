//
//  YelpAPISearchQueries.m
//  WeHungry
//
//  Created by Max Campolo on 7/21/14.
//  Copyright (c) 2014 Maxim Campolo. All rights reserved.
//

#import "YelpAPISearchQueries.h"

@implementation YelpAPISearchQueries

NSString *result = nil;

// Takes a search category and transforms it to the proper Yelp request query
+ (NSString *)getQueryFromString:(NSString *)searchString {
    NSString *key = searchString;
    typedef void (^selectedCase)();
    NSDictionary *d = @{
                               @"American" : ^{
                                   result = @"newamerican";
                                   NSLog(@"newAmerican");
                               },
                               @"Barbeque" : ^{
                                   result = @"bbq";
                                   NSLog(@"bbq");
                               },
                               @"Beer Garden" : ^{
                                   result = @"beergarden";
                                   NSLog(@"beergarden");
                               },
                               @"Cafe" : ^{
                                   result = @"cafes";
                                   NSLog(@"cafes");
                               },
                               @"Chicken Wings" : ^{
                                   result = @"chicken_wings";
                                   NSLog(@"chicken_wings");
                               },
                               @"Chinese" : ^{
                                   result = @"chinese";
                                   NSLog(@"chinese");
                               },
                               @"Fast Food" : ^{
                                   result = @"hotdogs";
                                   NSLog(@"hotdogs");
                               },
                               @"French" : ^{
                                   result = @"french";
                                   NSLog(@"french");
                               },
                               @"Greek" : ^{
                                   result = @"greek";
                                   NSLog(@"greek");
                               },
                               @"Italian" : ^{
                                   result = @"italian";
                                   NSLog(@"italian");
                               },
                               @"Japanese" : ^{
                                   result = @"japanese";
                                   NSLog(@"japanese");
                               },
                               @"Mexican" : ^{
                                   result = @"mexican";
                                   NSLog(@"mexican");
                               },
                               @"Pizza" : ^{
                                   result = @"pizza";
                                   NSLog(@"pizza");
                               },
                               @"Pub Food" : ^{
                                   result = @"pubfood";
                                   NSLog(@"pubfood");
                               },
                               @"Salad" : ^{
                                   result = @"salad";
                                   NSLog(@"salad");
                               },
                               @"Sandwiches" : ^{
                                   result = @"sandwiches";
                                   NSLog(@"sandwiches");
                               },
                               @"Steak House" : ^{
                                   result = @"steak";
                                   NSLog(@"steak");
                               },
                               @"Sushi" : ^{
                                   result = @"sushi";
                                   NSLog(@"sushi");
                               },
                               @"Thai" : ^{
                                   result = @"thai";
                                   NSLog(@"thai");
                               },
                               @"Vegan" : ^{
                                   result = @"vegan";
                                   NSLog(@"vegan");
                               }
                               };
    
    if (key != nil) {
        ((selectedCase)d[key])();
    } else {
        result = @"restaurants";
    }
    
    if (result != nil) {
        return result;
    }
    return nil;
}

@end

//
//  ViewController.h
//  WeHungry
//
//  Created by Max Campolo on 7/16/14.
//  Copyright (c) 2014 Maxim Campolo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YelpAPIService.h"
#import "AppDelegate.h"
#import "RestaurantModel.h"
#import "YelpAPISearchQueries.h"
#import "iAd/ADBannerView.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface ViewController : UIViewController <YelpAPIServiceDelegate, UITextFieldDelegate, UIPickerViewDelegate, ADBannerViewDelegate>

#pragma mark UI Properties
@property (strong,nonatomic) IBOutlet UIView *backgroundView;
@property (strong,nonatomic) IBOutlet UIView *buttonView;
@property (strong,nonatomic) IBOutlet UIView *mainView;
@property (strong,nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong,nonatomic) IBOutlet UIButton *mainButton;
@property (strong,nonatomic) IBOutlet UIButton *viewOnYelpButton;
@property (strong,nonatomic) IBOutlet UIButton *callButton;
@property (strong,nonatomic) IBOutlet UIButton *directionsButton;
@property (strong,nonatomic) IBOutlet UILabel *nameLabel;
@property (strong,nonatomic) IBOutlet UILabel *addressLabel;
@property (strong,nonatomic) IBOutlet UIImageView *thumbImage;
@property (strong,nonatomic) IBOutlet UIImageView *ratingImage;
@property (strong,nonatomic) IBOutlet UITextField *categoryField;
@property (strong,nonatomic) IBOutlet UITextField *radiusField;
@property (strong,nonatomic) IBOutlet UILabel *numberOfResultsLabel;
@property (strong,nonatomic) IBOutlet UIActivityIndicatorView *fetchingActivityIndicator;
@property (strong,nonatomic) IBOutlet ADBannerView *adBanner;

@property (nonatomic,assign) UITextField *activeTextField;
@property (nonatomic,strong) UIPickerView *categoryPicker;
@property (nonatomic,strong) UIPickerView *radiusPicker;
@property (nonatomic,strong) NSMutableArray *categoryArray;
@property (nonatomic,strong) NSMutableArray *radiusArray;

#pragma mark Yelp API Properties
@property (strong,nonatomic) YelpAPIService *yelpService;
@property (strong,nonatomic) NSString *searchCriteria;
@property (strong,nonatomic) RestaurantModel *place;

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSMutableArray *placesArray;

- (NSString*) getYelpCategoryFromSearchText;
- (void) findNearByRestaurantsFromYelpbyCategory:(NSString *)categoryFilter andRadius:(NSString *)radiusFilter;

@end

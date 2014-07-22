//
//  ViewController.m
//  WeHungry
//
//  Created by Max Campolo on 7/16/14.
//  Copyright (c) 2014 Maxim Campolo. All rights reserved.
//

#import "ViewController.h"
#import <CoreImage/CoreImage.h>
#import "UIImage+ImageEffects.h"
#import "RestaurantModel.h"
#import "iAd/ADBannerView.h"

@interface ViewController ()

@end

@implementation ViewController

NSArray *places;
bool criteriaUpdated = YES;

#pragma mark IBOutlets

// Action that happens when the main button is pressed
- (IBAction)getRandomPlace:(id)sender {
    [self pickRandomPlace];
}

- (IBAction)viewCurrentOnYelp:(id)sender {
    [self viewCurrentPlaceOnYelp];
}

- (IBAction)getDirectionsButtonTouched:(id)sender {
    [self getDirectionsToCurrentPlace];
}

- (IBAction)callButtonTouched:(id)sender {
    [self callCurrentPlace];
}

#pragma mark Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //Set up view
    [self setupInterfaceAttributes];
    [self setBlurredBackground];
    
    self.place = [[RestaurantModel alloc] init];
    
    // Initialize results array if it isn't already
    if (!self.placesArray) {
        self.placesArray = [[NSMutableArray alloc]init];
    }
    
    // Set up category picker view and radius picker view
    [self populateCategoryArray];
    [self setupPickerViews];
    
    // Set app delegate and update users current location
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self.appDelegate updateCurrentLocation];
    
    // Set message Delegate
    self.categoryField.delegate = self;
    self.radiusField.delegate = self;
    
    // Set iAD banner view delegate and set it to hidden initially
    self.adBanner.delegate = self;
    [self.adBanner setHidden:YES];
    
    // Set notification observer for keyboardWillHide
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    // Add gesture recognizer to scrollview for removing keyboard on tap
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(doRemoveKeyboard)];
    [self.scrollView addGestureRecognizer:tap];
    
    // Move button view up if it is not an iphone 5
    if (IS_IPHONE_5) {
    } else {
        [self.buttonView setFrame:CGRectMake(self.buttonView.frame.origin.x, self.buttonView.frame.origin.y - 40, self.buttonView.frame.size.width, self.buttonView.frame.size.height)];
        [self.mainView setFrame:CGRectMake(self.mainView.frame.origin.x, self.mainView.frame.origin.y - 10, self.mainView.frame.size.width, self.mainView.frame.size.height)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UI Methods

// Method to set up interface with attributes
- (void) setupInterfaceAttributes {
    [self.mainButton.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.mainButton.layer setBorderWidth:1.0];
    [self.viewOnYelpButton.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.viewOnYelpButton.layer setBorderWidth:1.0];
    [self.directionsButton.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.directionsButton.layer setBorderWidth:1.0];
    [self.callButton.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.callButton.layer setBorderWidth:1.0];
    [self.categoryField.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.categoryField.layer setBorderWidth:1.0];
    [self.radiusField.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.radiusField.layer setBorderWidth:1.0];
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"All" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:.5] }];
    self.categoryField.attributedPlaceholder = str;
    
    [self.fetchingActivityIndicator setHidden:YES];
}

// Set up picker views for text fields
- (void) setupPickerViews {
    // Setting up the category picker
    self.categoryPicker =[[UIPickerView alloc]init];
    [self.categoryPicker setTag:1];
    self.categoryPicker.delegate=self;
    self.categoryPicker.dataSource=self;
    self.categoryPicker.showsSelectionIndicator=YES;
    [self.categoryField setInputView:self.categoryPicker];
    
    //Setting up the range picker
    self.radiusPicker = [[UIPickerView alloc]init];
    [self.radiusPicker setTag:0];
    self.radiusPicker.delegate=self;
    self.radiusPicker.dataSource = self;
    self.radiusPicker.showsSelectionIndicator = YES;
    [self.radiusField setInputView:self.radiusPicker];
    [self.radiusPicker selectRow:4 inComponent:0 animated:NO];
}

// Method to blur the background image
- (void)setBlurredBackground {
    
    UIImage *image = [self imageWithImage:self.backgroundImage.image scaledToSize:CGSizeMake(640, 1136)];
    image = [image applyLightEffect];
    [self.backgroundImage setImage:image];
    
}

// Method to reduce the size of an image
- (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

// Method to get random object from array
- (RestaurantModel*) getRandomFromArray:(NSArray*)array {
    if (!array.count == 0) {
        uint32_t rnd = arc4random_uniform([array count]);
        RestaurantModel *randomRestaurant = [array objectAtIndex:rnd];
        return randomRestaurant;
    }else {
        NSLog(@"No results");
        [self.mainButton setTitle:@"No results :(" forState:UIControlStateNormal];
        return nil;
    }
    return nil;
}

// IBAction for picking a random place --> calls set place method or updates list
- (void) pickRandomPlace {
    if (!criteriaUpdated) {
        [self setPlace];
        criteriaUpdated = NO;
    } else if ([self.categoryField hasText]){
        [self findNearByRestaurantsFromYelpbyCategory:self.categoryField.text andRadius:self.radiusField.text];
        criteriaUpdated = NO;
    } else {
        [self findNearByRestaurantsFromYelpbyCategory:nil andRadius:self.radiusField.text];
        criteriaUpdated = NO;
    }
}

// Picks a random place from the array and sets the UI attributes
- (void) setPlace {
    self.place = [self getRandomFromArray:self.placesArray];
    [self.nameLabel setText:self.place.name];
    [self.addressLabel setText:self.place.address];
    
    // Get the thumbnail and rating images on background queue
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *thumbImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.place.thumbURL]];
        NSData *ratingImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.place.ratingURL]];
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self.thumbImage setImage:[UIImage imageWithData:thumbImageData]];
            [self.ratingImage setImage:[UIImage imageWithData:ratingImageData]];
            // Resize the thumbnail, blur it, and set it to background
            if ([UIImage imageWithData:thumbImageData]) {
                UIImage *blurThumb = [self imageWithImage:[UIImage imageWithData:thumbImageData] scaledToSize:CGSizeMake(640, 1136)];
                blurThumb = [blurThumb applyLightEffect];
                [self.backgroundImage setImage:blurThumb];
            }
        });
    });
    //[self.placesArray removeObject:place];   // TO- DO --> THIS IS NOT A STRING, IT'S A RESTAURANTMODEL
}

// Method for viewing the current place on yelp when the yelp button is pressed
- (void) viewCurrentPlaceOnYelp {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:self.place.mobileURL]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.place.mobileURL]];
    }
}

// method for getting directions to current place in maps app when directions button is pressed
- (void) getDirectionsToCurrentPlace {
    NSString *addrString = [NSString stringWithFormat:@"http://maps.apple.com/?q=%@", self.place.address];
    NSString* webStringURL = [addrString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *addrURL = [NSURL URLWithString:webStringURL];
    if (self.place.address != NULL ) {
        if([[UIApplication sharedApplication]canOpenURL:addrURL]) {
            [[UIApplication sharedApplication] openURL:addrURL];
        }
    }
}

// Method for calling current place when call button is pressed
- (void) callCurrentPlace {
    NSString *phoneString = [NSString stringWithFormat:@"tel://%@", self.place.phone];
    NSURL *phoneURL = [NSURL URLWithString:phoneString];
    if(self.place.phone != NULL) {
        if([[UIApplication sharedApplication]canOpenURL:phoneURL]) {
            [[UIApplication sharedApplication] openURL:phoneURL];
        }
    }
}

# pragma mark picker delegates
- (void) populateCategoryArray {
    self.categoryArray = @[@"American", @"Barbeque", @"Beer Garden", @"Cafe", @"Chicken Wings", @"Chinese", @"Fast Food", @"French", @"Greek", @"Italian", @"Japanese", @"Mexican", @"Pizza", @"Pub Food", @"Salad", @"Sandwiches",@"Steak House", @"Sushi", @"Thai", @"Vegan"];
    
    if (!self.radiusArray) {
        self.radiusArray = [[NSMutableArray alloc]init];
    }
    for (int i = 0; i < 25; i++) {
        [self.radiusArray addObject:[NSString stringWithFormat:@"%i", i+1]];
    }
}

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    // Radius picker view tag is 0
    if (pickerView.tag == 0) {
        return 1;
    }
    else return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    // Radius picker view tag is 0
    if (pickerView.tag == 0) {
        return self.radiusArray.count;
    } else {
        return self.categoryArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    // Radius picker view tag is 0
    if (pickerView.tag == 0) {
        return self.radiusArray[row];
    } else {
        return self.categoryArray[row];
    }
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    // Radius picker view tag is 0
    if (pickerView.tag == 0) {
        [self.radiusField setText:self.radiusArray[row]];
    } else {
        [self.categoryField setText:self.categoryArray[row]];
    }
    criteriaUpdated = YES;
}

#pragma mark Yelp API methods

- (NSString*) getYelpCategoryFromSearchText {
    // This is where we will get the category (if there is one) from the filter
    return nil;
}

- (void) findNearByRestaurantsFromYelpbyCategory:(NSString *)categoryFilter andRadius:(NSString *)radiusFilter{
    // Category filter being null is taken care of in YelpAPIService - in that case just top results are returned
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied && self.appDelegate.currentUserLocation && self.appDelegate.currentUserLocation.coordinate.latitude) {
        // Remove objects from array and set UI contents to nil
        [self.placesArray removeAllObjects];
        [self.nameLabel setText:nil];
        [self.thumbImage setImage:nil];
        [self.ratingImage setImage:nil];
        [self.addressLabel setText:nil];
        [self.mainButton setTitle:@"Fetching..." forState:UIControlStateNormal];
        
        // Start activity indicator
        [self.fetchingActivityIndicator startAnimating];
        [self.fetchingActivityIndicator setHidden:NO];
        
        self.yelpService = [[YelpAPIService alloc]init];
        self.yelpService.delegate = self;
        
        self.searchCriteria = [YelpAPISearchQueries getQueryFromString:categoryFilter];
        [self.yelpService searchNearByRestaurantsByFilter:[self.searchCriteria lowercaseString] andRadiusFilter:radiusFilter atLatitude:self.appDelegate.currentUserLocation.coordinate.latitude andLongitude:self.appDelegate.currentUserLocation.coordinate.longitude];
    } else {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Location is Disabled" message:@"Enable it in settings and try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
    }
}

#pragma mark Yelp API Delegate
-(void)loadResultWithDataArray:(NSArray *)resultArray {
    self.placesArray = [resultArray mutableCopy];
    [self.mainButton setTitle:nil forState:UIControlStateNormal];
    [self.fetchingActivityIndicator stopAnimating];
    [self.fetchingActivityIndicator setHidden:YES];
    [self.numberOfResultsLabel setText:[NSString stringWithFormat:@"%@ results",[[NSNumber numberWithLong:self.placesArray.count] stringValue]]];
    [self setPlace];
}

#pragma mark Text Field Delegates

// Set active text field
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeTextField = textField;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    self.activeTextField = nil;
}

// Responds to UIKeyboardWillHide Notifcation
- (void) keyboardWillHide:(NSNotification *)notification {
    [self doRemoveKeyboard];
}

// Resign first responder when done button is pressed
- (IBAction)dismissKeyboard:(id)sender
{
    [self.activeTextField resignFirstResponder];
}

- (IBAction)textChanged:(id)sender {
    criteriaUpdated = YES;
}

// Resign first responder when backgroundview is tapped
-(void) doRemoveKeyboard {
    [self.activeTextField resignFirstResponder];
}

#pragma mark iAd banner view delegates
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    if (self.adBanner.hidden == NO) {
        [self.adBanner setHidden:YES];
    }
    NSLog(@"bannerview did not receive any banner due to %@", error);
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner{
    NSLog(@"bannerview was selected");
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{
    return YES;
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    if (self.adBanner.hidden == YES) {
        [self.adBanner setHidden:NO];
    }
    NSLog(@"banner was loaded");
}



@end

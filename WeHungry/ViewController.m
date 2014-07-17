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

@interface ViewController ()

@end

@implementation ViewController

NSArray *places;

- (IBAction)getRandomPlace:(id)sender {
    [self pickRandomPlace];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    [self setBlurredBackground];
    
   places = [NSArray arrayWithObjects:@"Qdoba", @"Primantis", @"Brueggers", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
- (NSString*) getRandomFromArray:(NSArray*)array {
    uint32_t rnd = arc4random_uniform([array count]);
    NSString *randomObject = [array objectAtIndex:rnd];
    return randomObject;
}

- (void) pickRandomPlace {
    NSString* place = [self getRandomFromArray:places];
    [self.mainButton setTitle:place forState:UIControlStateNormal];
}


@end

//
//  WallViewController.h
//  FindMyFriends
//
//  Created by Yung Dai on 2015-05-13.
//  Copyright (c) 2015 Yung Dai. All rights reserved.
//

#import <UIKit/UIKit.h>


// required frameworks for this view
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

// required classes for loging out
// Facebook Framework's required API's
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "LoginViewController.h"

// Parse Framework's API inheritence
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>

@class WallViewController;

@protocol WallViewControllerDelegate <NSObject>

- (void)wallViewControllerWantsToPresentSettings:(WallViewController *)controller;

@end

@interface WallViewController : UIViewController <LoginViewControllerDelegate, WallViewControllerDelegate>


@property (weak, nonatomic) id<WallViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIButton *logoutButton;


- (IBAction)logoutButtonPressed:(id)sender;

@end

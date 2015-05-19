//
//  FindMyFriendsWallViewController.h
//  FindMyFriends
//
//  Created by Yung Dai on 2015-05-12.
//  Copyright (c) 2015 Yung Dai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@class FindMyFriendsWallViewController;

@protocol WallViewControllerDelegate <NSObject>

- (void)wallViewControllerWantsToPresentSettings:(FindMyFriendsWallViewController *)controller;

@end

@interface FindMyFriendsWallViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) IBOutlet MKMapView *mapView;



@end

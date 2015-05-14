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

@class WallViewController;

@protocol WallViewControllerDelegate <NSObject>

- (void)wallViewControllerWantsToPresentSettings:(WallViewController *)controller;

@end

@interface WallViewController : UIViewController


@property (weak, nonatomic) id<WallViewControllerDelegate> delegate;

@end

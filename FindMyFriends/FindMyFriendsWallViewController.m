//
//  FindMyFriendsWallViewController.m
//  FindMyFriends
//
//  Created by Yung Dai on 2015-05-12.
//  Copyright (c) 2015 Yung Dai. All rights reserved.
//

#import "FindMyFriendsWallViewController.h"

// importing the constants values
#import "Constants.h"

@interface FindMyFriendsWallViewController ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;

@property (nonatomic, strong) MKCircle *circleOverlay;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, assign) BOOL mapPinsPlaced;
@property (nonatomic, assign) BOOL mapPannedSinceLocationUpdate;



@property (nonatomic, strong) NSMutableArray *allPosts;


@end


// when a new locaiton is set we post a notifcation
@implementation FindMyFriendsWallViewController

- (void)setCurrentLocation:(CLLocation *)currentLocation {
    if (self.currentLocation == currentLocation) {
        return;
    }
        _currentLocation = currentLocation;
        
        dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter]postNotificationName:CurrentLocationDidChangeNotification
                                                           object: nil
                                                         userInfo:@{kLocationKey : currentLocation}];
               });
         
}



// The CoreLocation object CLLocationManager, has a delegate method that is called
// when the location changes. This is where we will post the notification
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    [locations lastObject];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:CurrentLocationDidChangeNotification
                                                 object:nil];
}

@end

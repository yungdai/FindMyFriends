//
//  Constants.h
//  FindMyFriends
//
//  Created by Yung Dai on 2015-05-12.
//  Copyright (c) 2015 Yung Dai. All rights reserved.
//

#ifndef FindMyFriends_Constants_h
#define FindMyFriends_Constants_h

static double FeetToMeters(double feet) {
    return  feet * 0.30488;
}

static double MetersToFeet(double meters) {
    return meters * 3.281;
}

static double MetersToKilometers(double meters) {
    return meters / 1000.0;
}


// Parse API key constants:
static NSString * const ParsePostsClassName = @"Posts";
static NSString * const ParsePostUserKey = @"user";
static NSString * const ParsePostUsernameKey = @"username";
static NSString * const ParseTextKey = @"text";
static NSString * const ParsePostLocationKey = @"name";

// NSNotification userInfo keys:
static NSString * const kFilterDistanceKey = @"filterDistance";
static NSString * const kLocationKey = @"location";

// Notificaiton names:
static NSString * const FilterDistanceDidChangeNotification = @"FilterDistanceDidChangeNotification";
static NSString * const CurrentLocationDidChangeNotification = @"CurrentLocationDidChangeNotification";
static NSString * const PostCreateNotificiation = @"PostCreatedNotification";

// UI strings:
static NSString * const kWallCantViewPost = @"Can't view post! Get closer.";

// NSUserDefaults
static NSString * const UserDefaultsFilderDistanceKey = @"filterDistance";

typedef double LocationAccuracy;


#endif

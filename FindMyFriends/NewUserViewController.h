//
//  NewUserViewController.h
//  FindMyFriends
//
//  Created by Yung Dai on 2015-05-12.
//  Copyright (c) 2015 Yung Dai. All rights reserved.
//

#import <UIKit/UIKit.h>

// Facebook API required API's
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

// Parse API inheritence
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>

@class NewUserViewController;

@protocol NewUserViewControllerDelegate <NSObject>

- (void)newUserViewControllerDidiSignup:(NewUserViewController *)controller;

@end


@interface NewUserViewController : UIViewController

@property (weak, nonatomic) id<NewUserViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *passwordAgainField;
@property (strong, nonatomic) IBOutlet UITextField *emailAddressField;

@end

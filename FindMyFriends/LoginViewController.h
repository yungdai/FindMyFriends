//
//  LoginViewController.h
//  FindMyFriends
//
//  Created by Yung Dai on 2015-05-12.
//  Copyright (c) 2015 Yung Dai. All rights reserved.
//

#import <UIKit/UIKit.h>


// start setup of my own delegate/protocol
// create my own protocol called LoginViewControllerDelegate
@class LoginViewController;

// define a protocol that delegates can adopt to be notified of a successful login or sign up:
@protocol LoginViewControllerDelegate <NSObject>

- (void)loginViewControllerDidLogin:(LoginViewController *)controller;

@end

@interface LoginViewController : UIViewController <UITextFieldDelegate>

// create the property for the LoginViewControllerDelegate
@property (weak, nonatomic) id<LoginViewControllerDelegate> delegate;


// end setup of my own delegate/protocol



// properties for the different types of text fields
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIView *faceBookLogin;
@property (strong, nonatomic) IBOutlet UIImageView *userImage;



@end

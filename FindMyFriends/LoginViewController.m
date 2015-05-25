//
//  LoginViewController.m
//  FindMyFriends
//
//  Created by Yung Dai on 2015-05-12.
//  Copyright (c) 2015 Yung Dai. All rights reserved.
//

#import "LoginViewController.h"

// adding in the NewUser and ActivityView  to be used
#import "NewUserViewController.h"
#import "WallViewController.h"


// Facebook Framework's required API's
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

// Parse Framework's API inheritence
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>

@interface LoginViewController ()

// declare my delegates
<UITextFieldDelegate, NewUserViewControllerDelegate, LoginViewControllerDelegate, FBSDKLoginButtonDelegate>



@end



@implementation LoginViewController



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [self returnUserDefaults];
    
    if ([PFUser currentUser] && // Check if user is cached
        
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) { // Check if user is linked to Facebook
        NSLog(@"User is cached!");
        // if the user is linked with facebook then show the view!
        [self presentWallViewControllerAnimated:YES];
        
    } else if ([FBSDKAccessToken currentAccessToken]) {
        NSLog(@"User access is granted through Facebook");
        // got to the main app if the FBSDKacebookAccessToken is equal to the currentAccessToken
        
//        [self loadFaceBookData];
        [self presentWallViewControllerAnimated:YES];
        
    } else {
        //        [self loadData];
    }
    
    
    
}

- (void)returnUserDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDefaults objectForKey:@"name"];
    NSString *objectID = [userDefaults objectForKey:@"objectID"];
    
    
}

- (NSUserDefaults *)returnUserFacebookDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return userDefaults;
}


// when the Facebook Login/Logout Button is pressed
- (IBAction)faceBookButtonPressed:(id)sender {
    [self loadFaceBookData];
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    
    NSLog(@"%@",result);
    NSLog(@"%@",error);
    
    
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    [self logOut];
}

- (void)loadFaceBookData {
    
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"email", @"public_profile", @"user_location", @"access_token"];

    
    // logging wiht PFUser using Facebook (this is a parse API to use Facebook)
    // Login PFUser using Facebook
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (!user) {

            NSLog(@"Uh oh. The user cancelled the Facebook login.");
  
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            
        } else {
            NSLog(@"User logged in through Facebook!");
            [self presentWallViewControllerAnimated:YES];
        }
        
        // If the user is not linked with the parse user link the parse user with Facebook
        if (![PFFacebookUtils isLinkedWithUser:user]) {
            [PFFacebookUtils linkUserInBackground:user withReadPermissions:nil block:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"Woohoo, user is linked with Facebook!");
                }
            }];
            
        }
        
    }];
    
    FBSDKAccessToken *facebookAccessToken = [FBSDKAccessToken currentAccessToken];
    [PFFacebookUtils logInInBackgroundWithAccessToken:facebookAccessToken block:^(PFUser *user, NSError *error) {
        if (!user) {
            
            NSLog(@"Uh oh. There was an error logging in.");

        } else {
            NSLog(@"User logged in through Facebook!");
            [user setObject:facebookAccessToken forKey:@"facebookeAccessToken"];
        }
    }];
    
    // Request new Publish Permissions
    [PFFacebookUtils logInInBackgroundWithPublishPermissions:@[ @"publish_actions" ] block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
            [self presentLoginViewControllerAnimated:YES];
        } else {
            NSLog(@"User now has publish permissions!");
            FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:nil];
            [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    // get the dictionary with the user's Facebook data
                    NSDictionary *userData = (NSDictionary *)result;
                    
                    NSString *facebookID = userData[@"id"];
                    NSString *first_name = userData[@"first_name"];
                    NSString *last_name = userData[@"last_name"];
                    NSString *location = userData[@"location"][@"name"];
                    NSString *gender = userData[@"gender"];
                    NSString *name = userData[@"name"];
                    NSString *timezone = userData[@"timezone"];
                    NSString *locale = userData[@"locale"];
                    
                    // get the facebook access token
                    NSString *facebookAccessToken = [FBSDKAccessToken currentAccessToken].tokenString;
                    // NSUserDefault setting of the facebookAccessToken
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:facebookID forKey:@"id"];
                    [userDefaults setObject:first_name forKey:@"first_name"];
                    [userDefaults setObject:last_name forKey:@"last_name"];
                    [userDefaults setObject:location forKey:@"location"];
                    [userDefaults setObject:gender forKey:@"gender"];
                    [userDefaults setObject:name forKey:@"name"];
                    [userDefaults setObject:timezone forKey:@"timezone"];
                    [userDefaults setObject:locale forKey:@"locale"];
                    [userDefaults setObject:facebookAccessToken forKey:@"faceBookAccessToken"];
                    
                    // save the facebook information to the NSUserDefaults
                    [userDefaults synchronize];
                    
                    
                    if ([[userDefaults objectForKey:@"facebookeAccessToken"] isEqualToString:facebookAccessToken]) {
                        // set my user session to be active because the accessToken matches
                        
                        
                    } else {
                        // the stored NSUserDefault token doesn't match with my current to token.  I will store my current tokent back into NSUserDefaults

                    }
                    
                    
                    // save all Facebook information to Prase
                    [user setObject:first_name forKey:@"first_name"];
                    [user setObject:last_name forKey:@"last_name"];
                    [user setObject:location forKey:@"location"];
                    [user setObject:gender forKey:@"gender"];
                    [user setObject:name forKey:@"name"];
                    [user setObject:timezone forKey:@"timezone"];
                    [user setObject:locale forKey:@"locale"];
                    [user setObject:facebookAccessToken forKey:@"facebookAccessToken"];

                    
                    
                    // URL should point to https://graph.facebook.com/{facebookId}/picture?type=large&return_ssl_resources=1
                    // ask Facebook Graph API for the picture
                    // set up the UIImage variable for the facebook image
                    NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
                    
                    // the the request and store it as NSData
                    NSData *facebookPhoto = [[NSData alloc] initWithContentsOfURL:pictureURL];
                    
                    
                    // set the userImage UIImage on my storyboard to that data
                    self.userImage.image = [UIImage imageWithData:facebookPhoto];
                    
                    
                    // send my facebook photo to parse
                    [user setObject:facebookPhoto forKey:@"facebookPhoto"];
                    
                    // send all user objects to Parse asychonously
                    [user saveInBackground];

                    
                }
                [self presentWallViewControllerAnimated:YES];
            }];
        }
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
   
}





// when I press the login button these actions will take place
- (IBAction)loginButtonPressed:(id)sender {
    
    // run the dismissKeyboard method
    [self dismissKeyboard];
    // run the processFieldEntries
    [self processFieldEntries];
    
}

- (void)loginViewControllerDidLogin:(LoginViewController *)controller {
    
    //[self presentWallViewControllerAnimated:YES];
}

// get the username text, store it in the app delegate for now
- (void)processFieldEntries {
    

    NSString *userName = self.usernameField.text;
    NSString *password = self.passwordField.text;
    NSString *noUsernameText = @"username";
    NSString *noPasswordText = @"password";
    NSString *errorText = @"No";
    NSString *errorTextJoin = @" or ";
    NSString *errorTextEnding = @" entered";
    BOOL textError = NO;
    
    // Messaging nil will return 0, so these checks impicity check for nil text.
    if (userName.length == 0 || password.length == 0 ) {
        textError = YES;
        
        // set up the keyboard for the first field missing input
        if (password.length == 0) {
            // if the passwordField length is 0 then show the keyboard
            [self.passwordField becomeFirstResponder];
        }
            // if the usernameField length is 0 then show the keyboard
        if (userName.length == 0 ) {
            [self.usernameField becomeFirstResponder];
        }
    }
    
    // if the userName entered text box length is 0
    if ([userName length] == 0 ) {
        textError = YES;
        errorText = [errorText stringByAppendingString:noUsernameText];
    }
    
    // if the password entered text box length is 0
    if ([password length] == 0 ) {
        textError = YES;
        if ([userName length] == 0) {
            errorText = [errorText stringByAppendingString:errorTextJoin];
        }
        errorText = [errorText stringByAppendingString:noPasswordText];
    }
    
    // if there textError is YES show up an an UIAlertView with the appropriate alerts
    if (textError) {
        errorText = [errorText stringByAppendingString:errorTextEnding];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:errorText message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    
    //
    // set up presistence of this Parse User
    // Everything looks good because all the code above passes; now try to log in
    [PFUser logInWithUsernameInBackground:userName password:password block:^(PFUser *user, NSError *error) {
        
        if (user) {
            NSLog(@"User has logged in");
            
            // if the user logs in make sure you save his login information to the user defaults for persistent login.
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:userName forKey:@"username"];
            [userDefaults setObject:password forKey:@"password"];
            [userDefaults setObject:user.objectId forKey:@"objectID"];
            [userDefaults setObject:user.sessionToken forKey:@"sessionToken"];
            
            // save the user information into the APP (NSUserDefaults)
            [userDefaults synchronize];
            
            [self loginViewControllerDidLogin:self];
            
        } else {
            // didn't get a user.
            NSLog(@"%s didn't get a user!", __PRETTY_FUNCTION__);
            
            NSString *alertTitle = nil;
            
            if (error) {
                // the usename or password is probably wrong.
                alertTitle = @"Couldn't log in:\nThe username or password were wrong.";
            }
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
            [alertView show];
            
            // Bring the keyboard back up, because they'll probably need to change something.
            [self.usernameField becomeFirstResponder];
            
        }
        
    }];
    
}



// when a user new user signs up (this is part of the required NewUserViewController Delegate/Protocol)
- (void)newUserViewControllerDidiSignup:(NewUserViewController *)controller {
    
    //assign self as the delegate for the logingViewControllerDidLogin
    [self.delegate loginViewControllerDidLogin:self];
    //signup successful
}


// When the app delegate sets up the LoginViewController it can set itself up as the delegate for that view controller.
- (void)presentLoginViewControllerAnimated:(BOOL)animated {
    NSLog(@"Sending you to the loging screen");
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    [self presentViewController:loginViewController animated:YES completion:nil];
}

- (void)presentWallViewControllerAnimated:(BOOL)animated {
    NSLog(@"Ah yyyeeeah, I gots the call");
    WallViewController *wallViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WallViewController"];
    [self presentViewController:wallViewController animated:YES completion:nil];
}


// When the LoginViewController instantiates and presents the NewUserViewController, it sets itself up as the delegate so it can be notified when a user signs up:
- (void)presentNewUserViewControllerAnimated:(BOOL)animated {
    NSLog(@"Presenting you the New User Screen");
    NewUserViewController *newUserViewController  = [[NewUserViewController alloc] init];
    [self presentLoginViewControllerAnimated:newUserViewController];
    
}




// this method dismisses the keyboard
- (void)dismissKeyboard {
    
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Navigation

//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    [segue destinationViewController];
//
//}


- (void)logOut {
    [PFUser logOut]; // log out
    NSLog(@"User has logged out");
}


@end

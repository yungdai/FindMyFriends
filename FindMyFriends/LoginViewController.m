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
#import "ActivityView.h"
#import "WallViewController.h"


// Facebook Framework's required API's
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

// Parse Framework's API inheritence
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>

@interface LoginViewController ()

// declare my delegates
<UITextFieldDelegate, NewUserViewControllerDelegate, LoginViewControllerDelegate, WallViewControllerDelegate>

// declare properties for the implimentation

// declare properties for a view that I show programatically
// variable to contain if I can or cannot see the activityView
@property (assign, nonatomic) BOOL activityViewVisible;
// the actual UI View for activityView property
@property (strong, nonatomic) UIView *activityView;



@end



@implementation LoginViewController

// method to deallocate the NSNotificaiton Controller
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Facebook API setup
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc]init];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        // need to tell the API that I need view did load

    } else {
        [self _loadData];
        
    }
    
    [self _loadData];
    
    //  requesting and setting the user data from Facebook and sending the data to Parse

    

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(dismissKeyboard)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [self registerForKeyboardNotifications];

}

- (void)_loadData {
    
    
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"email", @"public_profile", @"user_location", @"access_token"];
    
    // set up activityView
    self.activityViewVisible = YES;

    
    // logging wiht PFUser using Facebook (this is a parse API to use Facebook)
    // Login PFUser using Facebook
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (!user) {
            // Hid the activity view
            self.activityViewVisible = NO;
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
            
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
        } else {
            NSLog(@"User logged in through Facebook!");
            
            
        }
        

        
        // Log In (create/update currentUser) with FBSDKAccessToken
   
        
        
        
        
        // If the user is not linked with the parse user link the parse user with Facebook
        if (![PFFacebookUtils isLinkedWithUser:user]) {
            [PFFacebookUtils linkUserInBackground:user withReadPermissions:nil block:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"Woohoo, user is linked with Facebook!");
                }
            }];
        } else {
            
            
        }
        
        
    }];
    
    FBSDKAccessToken *accessToken = [FBSDKAccessToken currentAccessToken];
    [PFFacebookUtils logInInBackgroundWithAccessToken:accessToken block:^(PFUser *user, NSError *error) {
        if (!user) {
            
            NSLog(@"Uh oh. There was an error logging in.");
        } else {
            NSLog(@"User logged in through Facebook!");
            [user setObject:accessToken forKey:@"currentAccessToken"];
        }
    }];
    
    // Request new Publish Permissions
    [PFFacebookUtils logInInBackgroundWithPublishPermissions:@[ @"publish_actions" ] block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
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
                    
                    if ([[userDefaults objectForKey:@"facebookeAccessToken"] isEqualToString:facebookAccessToken]) {
                        // set my user session to be active because the accessToken matches
                        
                        
                    } else {
                        // the stored NSUserDefault token doesn't match with my current to token.  I will store my current tokent back into NSUserDefaults
                        [userDefaults setObject:facebookAccessToken forKey:@"faceBookAccessToken"];
                    }
                    
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
                    
                    
                    // take the request and turn it into NSURLRequest
                    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];
                    
                    // the the request and store it as NSData
                    NSData *facebookPhoto = [[NSData alloc]initWithContentsOfURL:pictureURL];
                    
                    
                    // set the userImage UIImage on my storyboard to that data
                    self.userImage.image = [UIImage imageWithData:facebookPhoto];
                    
                    
                    // send my facebook photo to parse
                    [user setObject:facebookPhoto forKey:@"facebookPhoto"];
                    
                    // send all user objects to Parse asychonously
                    [user saveInBackground];
                    [NSURLConnection sendAsynchronousRequest:urlRequest
                                                       queue:[NSOperationQueue mainQueue]
                                           completionHandler:
                     ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                         if (connectionError == nil && data != nil) {
                             // Set the image in the imageView
                             // ...
                         }
                     }];
                    
                    
                    
                }
                [self loginViewControllerDidLogin:self];
            }];
        }
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    if ([PFUser currentUser] && // Check if user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) { // Check if user is linked to Facebook
            [self presentWallViewControllerAnimated:YES];
        
//        LoginViewController *controller = [[LoginViewController alloc] init];
//        logInController.fields = (PFLogInFieldsUsernameAndPassword
//                                  | PFLogInFieldsFacebook
//                                  | PFLogInFieldsDismissButton);
//        [self presentViewController:controller animated:YES];
    }
}

- (void)_logOut {
    [PFUser logOut]; // log out
    NSLog(@"User has logged out");
}

// when I press the login button these actions will take place
- (IBAction)loginButtonPressed:(id)sender {
    
    // run the dismissKeyboard method
    [self dismissKeyboard];
    // run the processFieldEntries
    [self processFieldEntries];
    
}

- (void)loginViewControllerDidLogin:(LoginViewController *)controller {
    [self presentWallViewControllerAnimated:YES];
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
    
    

    
    // Everything looks good because all the code above passes; now try to log in

    
    [PFUser logInWithUsernameInBackground:userName password:password block:^(PFUser *user, NSError *error) {
        
        if (user) {
            NSLog(@"User has logged in");
            [self loginViewControllerDidLogin:self];
            
        } else {
            // didn't get a user.
            NSLog(@"%s didn't get a user!", __PRETTY_FUNCTION__);
            
            NSString *alertTitle = nil;
            
            if (error) {
                // the usename or password is probably wrong.
                alertTitle = @"Couldn't log in:\nThe username or password were wrong.";
            }
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:alertTitle
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
- (void)presentLoginViewController:(NewUserViewController *)controller {
    LoginViewController *viewController = [[LoginViewController alloc]initWithNibName:nil
                                                                               bundle:nil];
    viewController.delegate = self;
    [self.navigationController setViewControllers:@[ viewController ] animated:NO];
    
}



// When the LoginViewController instantiates and presents the NewUserViewController, it sets itself up as the delegate so it can be notified when a user signs up:
- (void)presentNewUserViewController {
    NewUserViewController *viewController  = [[NewUserViewController alloc]initWithNibName:nil
                                                                                    bundle:nil];
    
    viewController.delegate = self;
    [self.navigationController presentViewController:viewController
                                            animated:YES
                                          completion:nil];
    
}




// this method dismisses the keyboard
- (void)dismissKeyboard {
    
    [self.view endEditing:YES];
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    
}

- (void)keyboardWillHide:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];


}

- (IBAction)loginWithFacebookPressed:(id)sender {
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)presentWallViewControllerAnimated:(BOOL)animated {
    WallViewController *wallViewController = [[WallViewController alloc]init];
    wallViewController.delegate = self;
    //[self.navigationController setViewControllers:@[ wallViewController ] animated:animated];
    [self presentViewController:wallViewController animated:true completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

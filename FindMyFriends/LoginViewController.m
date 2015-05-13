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

// Facebook API required API's
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

// Parse API inheritence
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>

@interface LoginViewController ()

// declare my delegates
<UITextFieldDelegate, NewUserViewControllerDelegate, LoginViewControllerDelegate>

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
        // User is logged in, do work such as go to next view controller.
    }
    
    //  requeting and setting the user data from Facebook
    [self _loadData];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(dismissKeyboard)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [self registerForKeyboardNotifications];

}

- (void)_loadData {
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:nil];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // get the dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            NSString *name = userData[@"name"];
            NSString *location = userData[@"locaiton"][@"name"];
            NSString *gender = userData[@"gender"];
            NSString *birthday = userData[@"birthday"];
            NSString *relationship = userData[@"relationship_status"];
            
        
            // URL should point to https://graph.facebook.com/{facebookId}/picture?type=large&return_ssl_resources=1
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];
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
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    if ([PFUser currentUser] && // Check if user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) { // Check if user is linked to Facebook

        
//        LoginViewController *controller = [[LoginViewController alloc] init];
//        logInController.fields = (PFLogInFieldsUsernameAndPassword
//                                  | PFLogInFieldsFacebook
//                                  | PFLogInFieldsDismissButton);
//        [self presentViewController:controller animated:YES];
    }
}

- (void)_logOut {
    [PFUser logOut]; // log out
}

// when I press the login button these actions will take place
- (IBAction)loginButtonPressed:(id)sender {
    
    // run the dismissKeyboard method
    [self dismissKeyboard];
    // run the processFieldEntries
    [self processFieldEntries];
    
}

// when I press the login with Facebook Button these actions will take place
- (IBAction)loginWithFacebookButtonPressed:(id)sender {
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"email", @"public_profile", @"user_location"];

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
        
        
        // If the user is not linked with the parse user link the parse user with Facebook
        if (![PFFacebookUtils isLinkedWithUser:user]) {
            [PFFacebookUtils linkUserInBackground:user withReadPermissions:nil block:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"Woohoo, user is linked with Facebook!");
                }
            }];
        }
        
        
    }];
    
    
    // Request new Publish Permissions
    [PFFacebookUtils logInInBackgroundWithPublishPermissions:@[ @"publish_actions" ] block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else {
            NSLog(@"User now has publish permissions!");
        }
    }];
    
    
}
    



// get the username text, store it in the app delegate for now
- (void)processFieldEntries {
    
    PFUser *user = [PFUser user];
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
    
    // setup the activityView
    self.activityViewVisible = YES;
    
    [PFUser logInWithUsernameInBackground:userName password:password block:^(PFUser *user, NSError *error) {
        self.activityViewVisible = NO;
        
        if (user) {
            [self.delegate loginViewControllerDidLogin:self];
            
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
            
            
            
            
        }
    }];
    // Bring the keyboard back up, because they'll probably need to change something.
    [self.usernameField becomeFirstResponder];
    
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

// The app delegate can implement the required delegate method to display the main view controller
- (void) loginViewControllerDidLogin:(LoginViewController *)controller {
    // private method to display the main view controller
//    [self presentWallViewControllerAnimated: YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  WallViewController.m
//  FindMyFriends
//
//  Created by Yung Dai on 2015-05-13.
//  Copyright (c) 2015 Yung Dai. All rights reserved.
//

#import "WallViewController.h"
#import "LoginViewController.h"

// Facebook Framework's required API's
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

// Parse Framework's API inheritence
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>

@interface WallViewController () 

@end

@implementation WallViewController

/*- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"initialised");
    }
    return self;
}*/

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
   // _view.backgroundColor = [UIColor blueColor];
//    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
//    [FBSDKLoginButton class];
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
-(void)loginViewControllerDidLogin:(LoginViewController *)controller {
    
}
- (IBAction)logoutButtonPressed:(id)sender {
    [PFUser logOut];
//    LoginViewController *viewController = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
    NSLog(@"I've sent you to the login screen");
    [self presentLoginViewControllerAnimated:YES];
}

- (void)presentLoginViewControllerAnimated:(BOOL)animated {
    // Go to the welcome screen and have them log in or create an account.
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    [self presentViewController:loginViewController animated:YES completion:nil];
}


@end

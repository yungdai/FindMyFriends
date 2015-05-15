//
//  AppDelegate.m
//  FindMyFriends
//
//  Created by Yung Dai on 2015-05-12.
//  Copyright (c) 2015 Yung Dai. All rights reserved.
//

#import "AppDelegate.h"

// add facebook SDK
// Parse Facebook  setup
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <Parse/Parse.h>

// constant file variables
#import "Constants.h"

// the different view controllers
#import "LoginViewController.h"
#import "WallViewController.h"


@interface AppDelegate ()<LoginViewControllerDelegate, WallViewControllerDelegate>

@end

@implementation AppDelegate

// Facaebook SDK methods

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Parse setApplicationId:@"WTIpjvmocLnKmjegvp4Z1CHNnbP0IMKwjvJoUPqH" clientKey:@"CfIcbjiWafImIzBiiHBsK4BFGLaEgyd4QWFoPrPI"];
    [PFUser enableRevocableSessionInBackground];
    [FBSDKLoginButton class];
    
    // get the facebook access toke
    
    if ([PFUser currentUser]) {
        
        // present the wall viewcontroller right away if you are already logged in
        [self presentWallViewControllerAnimated:NO];
        
    } else {
        
        // if not then you will be presented with the login page
        [self presentLoginViewController];

    }
    

    
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
    
    // Override point for customization after application launch.
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
    
    
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}


// after you have logged in preset the WallViewController
- (void)loginViewControllerDidLogin:(LoginViewController *)controller {
    [self presentWallViewControllerAnimated:YES];
}

- (void)presentLoginViewController {
    // Go to the welcome screen and have them log in or create an account.
    LoginViewController *viewController = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
    viewController.delegate = self;
    [self.navigationController setViewControllers:@[ viewController ] animated:NO];
}


- (void)presentWallViewControllerAnimated:(BOOL)animated {
    WallViewController *wallViewController = [[WallViewController alloc] init];
    wallViewController.delegate = self;
    [self.navigationController setViewControllers:@[ wallViewController ] animated:animated];
}

//- (void)settingsViewControllerDidLogout:(SettingsViewController *)controller {
//    [controller dismissViewControllerAnimated:YES completion:nil];
//    [self presentLoginViewController];
//}



// WallViewController

//- (void)presentWallViewControllerAnimated:(BOOL)animated {
//    WallViewController *wallViewController = [[wallViewController alloc] initWithNibName:nil bundle:nil];
//    wallViewController.delegate = self;
//    [self.navigationController setViewControllers:@[ wallViewController ] animated:animated];
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}



- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end

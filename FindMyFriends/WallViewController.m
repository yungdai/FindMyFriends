//
//  WallViewController.m
//  FindMyFriends
//
//  Created by Yung Dai on 2015-05-13.
//  Copyright (c) 2015 Yung Dai. All rights reserved.
//

#import "WallViewController.h"
#import "LoginViewController.h"



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
    
    LoginViewController *viewController = [[LoginViewController alloc] initWithNibName:nil bundle:nil];

    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)presentLoginViewController {
    // Go to the welcome screen and have them log in or create an account.
    LoginViewController *viewController = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
    viewController.delegate = self;
    [self.navigationController setViewControllers:@[ viewController ] animated:NO];
}


@end

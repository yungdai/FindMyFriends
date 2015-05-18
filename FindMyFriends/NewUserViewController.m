//
//  NewUserViewController.m
//  FindMyFriends
//
//  Created by Yung Dai on 2015-05-12.
//  Copyright (c) 2015 Yung Dai. All rights reserved.
//

#import "NewUserViewController.h"
#import "WallViewController.h"


@interface NewUserViewController ()<UITextFieldDelegate, UIScrollViewDelegate, WallViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *createAccountButton;




@end



@implementation NewUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createAccountButtonPressed:(id)sender {
    [self dismissKeyboard];
    [self processFieldEntries];
    
}

- (IBAction)cancelButtonPressed:(id)sender {
}


// if this view appears
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.usernameField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.usernameField) {
        [self.passwordField becomeFirstResponder];
    }
    if (textField == self.passwordField) {
        [self.passwordAgainField becomeFirstResponder];
    }
    if (textField == self.passwordAgainField) {
        [self.passwordAgainField resignFirstResponder];
        [self processFieldEntries];
    }
    
    if (textField == self.emailAddressField) {
        [self.emailAddressField resignFirstResponder];
    }
    
    return YES;
}

- (void)processFieldEntries {
    
    // setup the fields for the sign up page
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    NSString *passwordAgain = self.passwordAgainField.text;
    NSString *emailAddress = self.emailAddressField.text;
    
    NSString *errorText = @"Please ";
    NSString *usernameBlankText = @"enter a username";
    NSString *passwordBlankText = @"enter a password";
    NSString *emailBlankText = @"enter an email address";
    NSString *joinText = @", and ";
    NSString *passwordMismatchText = @"enter the same password twice";
    
    BOOL textError = NO;

    
    // Messaging nil will return 0, so these checks implicitly check for nil text.
    if (username.length == 0 || password.length == 0 || passwordAgain.length == 0 || emailAddress.length == 0) {
        textError = YES;
        
        // Set up the keyboard for the first field missing input:
        if (passwordAgain.length == 0) {
            [self.passwordAgainField becomeFirstResponder];
        }
        if (password.length == 0) {
            [self.passwordField becomeFirstResponder];
        }
        if (username.length == 0) {
            [self.usernameField becomeFirstResponder];
        }
        
        if (emailAddress.length ==0) {
            [self.emailAddressField becomeFirstResponder];
        }
        
        if (username.length == 0) {
            errorText = [errorText stringByAppendingString:usernameBlankText];
        }
        
        if (password.length == 0 || passwordAgain.length == 0) {
            if (username.length == 0) { // We need some joining text in the error:
                errorText = [errorText stringByAppendingString:joinText];
            }
            errorText = [errorText stringByAppendingString:passwordBlankText];
        }
        
        if (emailAddress.length == 0) {
            errorText = [errorText stringByAppendingString:emailBlankText];
        }
    } else if ([password compare:passwordAgain] != NSOrderedSame) {
        // We have non-zero strings.
        // Check for equal password strings.
        textError = YES;
        errorText = [errorText stringByAppendingString:passwordMismatchText];
        [self.passwordField becomeFirstResponder];
    }
    
    if (textError) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:errorText message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }

    // Everything looks good; try to log in.
    
    // Call into an object somewhere that has code for setting up a user.
    // The app delegate cares about this, but so do a lot of other objects.
    // For now, do this inline.

    PFUser *user = [PFUser user];
    user.username = username;
    user.password = password;
    user.email = emailAddress;
    

    
    
    // if the user logs in make sure you save his login information to the user defaults for persistent login.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:user.username forKey:@"username"];
    [userDefaults setObject:user.password forKey:@"password"];
    [userDefaults setObject:user.objectId forKey:@"objectID"];
    [userDefaults synchronize];
    
    
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error){

        // if there is an error
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[error userInfo][@"error"]
                                                               message:nil
                                                              delegate:self
                                                     cancelButtonTitle:nil
                                                     otherButtonTitles:@"OK", nil];
            [alertView show];
            // bring the keyboard back in case the user needs to change something
            [self.usernameField becomeFirstResponder];
            return;
            }
        
        [self.delegate newUserViewControllerDidiSignup:self];
    }];
}


// methods to define the keyboards

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}





- (void)presentWallViewControllerAnimated:(BOOL)animated {
    WallViewController *wallViewController = [[WallViewController alloc]init];
    wallViewController.delegate = self;
    [self presentViewController:wallViewController animated:true completion:nil];
}


- (void)newUserViewControllerDidiSignup:(NewUserViewController *)controller {
     [self presentWallViewControllerAnimated:YES];
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

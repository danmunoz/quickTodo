//
//  LoginViewController.m
//  QuickTODO
//
//  Created by Daniel Munoz on 3/4/14.
//  Copyright (c) 2014 GreenCraft. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "RegistrationViewController.h"
#import "MainListViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (nonatomic, strong) LoginViewController *loginViewController;
@property (nonatomic, strong) MainListViewController *mainListViewController;
@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.activityIndicator setHidden:YES];
    [self.activityIndicator setHidesWhenStopped:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [tap setDelegate:self];
    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard{
    if ([self.usernameTextField isFirstResponder]) {
        [self.usernameTextField resignFirstResponder];
    }
    else if ([self.passwordTextField isFirstResponder]) {
        [self.passwordTextField resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    NSLog(@"Aaaand we're loggin in!");
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
    if ([self validateFields]) {
        [self.loginButton setEnabled:NO];
        [PFUser logInWithUsernameInBackground:self.usernameTextField.text password:self.passwordTextField.text block:^(PFUser *user, NSError *error) {
        [self.activityIndicator stopAnimating];
            if (user) {
                NSLog(@"Logged in!");
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setBool:YES forKey:@"loggedIn"];
                [defaults setObject:self.usernameTextField.text forKey:@"email"];
                [defaults synchronize];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccessful" object:self];
            } else {
                NSLog(@"%@",error);
                [self.loginButton setEnabled:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed." message:@"Invalid Username and/or Password." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
            }
        }];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter email and password" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
    
}

- (BOOL)validateFields{
    if ([self.usernameTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"LoginToRegistration"]) {
        self.loginViewController = segue.destinationViewController;
    }
}
@end

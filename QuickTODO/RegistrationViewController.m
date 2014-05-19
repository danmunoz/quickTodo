//
//  RegistrationViewController.m
//  QuickTODO
//
//  Created by Daniel Munoz on 3/4/14.
//  Copyright (c) 2014 GreenCraft. All rights reserved.
//

#import "RegistrationViewController.h"
#import "MainListViewController.h"
#import <Parse/Parse.h>

#define ALPHA                   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define NUMERIC                 @"1234567890"
#define EMAIL_SYMBOLS           @"@.-_"
#define ALPHA_NUMERIC           ALPHA NUMERIC
#define SPACE                   @" "
#define ALPHA_SPACES            ALPHA SPACE
#define EMAIL                   EMAIL_SYMBOLS ALPHA_NUMERIC SPACE

@interface RegistrationViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordValidationTextField;


@property (nonatomic, strong) MainListViewController *mainListViewController;
@end

@implementation RegistrationViewController

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
    [self.activityIndicator setHidesWhenStopped:YES];
    [self.emailTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)register:(id)sender {
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
    [self.registerButton setEnabled:NO];
    PFUser *newUser = [PFUser user];
    newUser.username = self.emailTextField.text;
    newUser.password = self.passwordTextField.text;
    newUser.email = self.emailTextField.text;
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [self.registerButton setEnabled:YES];
            [self.activityIndicator stopAnimating];
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
        } else {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:YES forKey:@"loggedIn"];
            [defaults setObject:self.emailTextField.text forKey:@"email"];
            [defaults synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccessful" object:self];
        }
    }];
}

#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *finalText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSCharacterSet *unacceptedInput = nil;
    unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:ALPHA_SPACES] invertedSet];
    int maxLength = 50;
    if (textField == self.emailTextField || textField == self.passwordTextField || textField == self.passwordValidationTextField) {
        unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:EMAIL] invertedSet];
    }
    if (([[string componentsSeparatedByCharactersInSet:unacceptedInput] count] <= 1)) {
        if (textField.text.length <= maxLength) {
            [self validateRequiredFieldsWithEditingTextField:textField andText:finalText];
            return YES;
        }
        else{
            if (range.location < textField.text.length) {
                [self validateRequiredFieldsWithEditingTextField:textField andText:finalText];
                return YES;
            }
            else{
                return NO;
            }
        }
    }
    return  NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self validateRequiredFields];
}

#pragma mark -
#pragma mark Validation Methods

- (BOOL)validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

- (void)validateRequiredFieldsWithEditingTextField:(UITextField *)sender andText:(NSString *)text{
    if (sender == self.emailTextField) {
        if ([text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""] || [self.passwordValidationTextField.text isEqualToString:@""] || ![self.passwordTextField.text isEqualToString:self.passwordValidationTextField.text] || self.passwordTextField.text.length < 6 || self.passwordValidationTextField.text.length < 6) {
            self.registerButton.enabled = NO;
        }
        else{
            if (![self validateEmail:text]) {
                self.registerButton.enabled = NO;
            }
            else{
                self.registerButton.enabled = YES;
            }
        }
    }
    else if(sender == self.passwordTextField){
        if ([self.emailTextField.text isEqualToString:@""] || [text isEqualToString:@""] || [self.passwordValidationTextField.text isEqualToString:@""] || ![text isEqualToString:self.passwordValidationTextField.text] || self.passwordTextField.text.length < 6 || self.passwordValidationTextField.text.length < 6) {
            self.registerButton.enabled = NO;
        }
        else{
            if (![self validateEmail:self.emailTextField.text]) {
                self.registerButton.enabled = NO;
            }
            else{
                self.registerButton.enabled = YES;
            }
        }
    }
    else if(sender == self.passwordValidationTextField){
        if ([self.emailTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""] || [text isEqualToString:@""] || ![self.passwordTextField.text isEqualToString:text] || self.passwordTextField.text.length < 6 || self.passwordValidationTextField.text.length < 6) {
            self.registerButton.enabled = NO;
        }
        else{
            if (![self validateEmail:self.emailTextField.text]) {
                self.registerButton.enabled = NO;
            }
            else{
                self.registerButton.enabled = YES;
            }
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    else if(textField == self.passwordTextField){
        [self.passwordValidationTextField becomeFirstResponder];
    }
    else if(textField == self.passwordValidationTextField){
        if ([self validateFields]) {
            [self register:textField];
            return NO;
        }
    }
    return YES;
}

- (void)validateRequiredFields{
    if ([self.emailTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""] || [self.passwordValidationTextField.text isEqualToString:@""] || ![self.passwordTextField.text isEqualToString:self.passwordValidationTextField.text] || self.passwordTextField.text.length < 6 || self.passwordValidationTextField.text.length < 6) {
        self.registerButton.enabled = NO;
    }
    else{
        if (![self validateEmail:self.emailTextField.text]) {
            self.registerButton.enabled = NO;
        }
        else{
            self.registerButton.enabled = YES;
        }
    }
}

- (BOOL)validateFields{
    if ([self.emailTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""] || [self.passwordValidationTextField.text isEqualToString:@""] || ![self.passwordTextField.text isEqualToString:self.passwordValidationTextField.text] || self.passwordTextField.text.length < 6 || self.passwordValidationTextField.text.length < 6) {
        return NO;
    }
    else{
        if (![self validateEmail:self.emailTextField.text]) {
            return NO;
        }
        else{
            return NO;
        }
    }
}


@end

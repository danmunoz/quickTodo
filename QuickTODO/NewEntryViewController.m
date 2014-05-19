//
//  NewEntryViewController.m
//  QuickTODO
//
//  Created by Daniel Munoz on 3/5/14.
//  Copyright (c) 2014 GreenCraft. All rights reserved.
//

#import "NewEntryViewController.h"
#import <Parse/Parse.h>
#import "TodoItem.h"


@interface NewEntryViewController ()
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *priorityCancelButton;
@property (weak, nonatomic) IBOutlet UIButton *dueDateCancelButton;
@property (weak, nonatomic) IBOutlet UIButton *priorityButton;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
@property (weak, nonatomic) IBOutlet UIButton *dueDateButton;
@property (nonatomic, strong) NSDate *dueDate;
@property (nonatomic) int priority;

@end

@implementation NewEntryViewController

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
    [self.contentTextField becomeFirstResponder];
    self.priority = -1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)cancel:(id)sender {
    if ([self.delegate respondsToSelector:@selector(newEntryViewController:finishedSaving:)]) {
        [self.delegate newEntryViewController:self finishedSaving:NO];
    }
}

- (IBAction)save:(id)sender {
    TodoItem *todoItem = [NSEntityDescription insertNewObjectForEntityForName:@"TodoItem" inManagedObjectContext:self.managedObjectContext];
    NSError *error = nil;
    [todoItem setContent:self.contentTextField.text];
    [todoItem setPriority:[NSNumber numberWithInt:self.priority]];
    [todoItem setCompleted:[NSNumber numberWithBool:NO]];
    if (self.dueDate != nil) {
        [todoItem setDueDate:self.dueDate];
    }
    ZAssert([self.managedObjectContext save:&error], @"Error saving moc: %@\n%@", [error localizedDescription], [error userInfo]);
    if (error == nil) {
        [self saveToParseWithUri:todoItem.objectID.URIRepresentation];
    }
    if ([self.delegate respondsToSelector:@selector(newEntryViewController:finishedSaving:)]) {
        [self.delegate newEntryViewController:self finishedSaving:YES];
    }
}

- (void)saveToParseWithUri:(NSURL *)uri{
    NSLog(@"Saving to Parse.com");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    PFObject *todoObject = [PFObject objectWithClassName:@"TodoItem"];
    todoObject[@"content"] = self.contentTextField.text;
    todoObject[@"priority"] = [NSNumber numberWithInt:self.priority];
    todoObject[@"completed"] = [NSNumber numberWithBool:NO];
    if (self.dueDate != nil) {
        todoObject[@"dueDate"] = self.dueDate;
    }
    todoObject[@"uri"] = uri.relativeString;
    todoObject[@"email"] = [defaults objectForKey:@"email"];
    [todoObject saveEventually];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (![finalString isEqualToString:@""]) {
        self.saveButton.enabled = YES;
    }
    else{
        self.saveButton.enabled = NO;
    }
    return YES;
}

- (IBAction)deleteDueDate:(id)sender {
    self.dueDate = nil;
    self.dueDateButton.selected = NO;
    self.dueDateCancelButton.hidden = YES;
}

- (IBAction)deletePriority:(id)sender {
    self.priority = -1;
    self.priorityButton.selected = NO;
    self.priorityCancelButton.hidden = YES;
}

- (void)dueDateVCDelegate:(DueDateViewController *)controller selectedDate:(NSDate *)date{
    self.dueDate = date;
    self.dueDateButton.selected = YES;
    self.dueDateCancelButton.hidden = NO;
}

- (void)PriorityVCDelegate:(PriorityViewController *)controller returnedPriorityLevel:(int)priorityLevel{
    self.priority = priorityLevel;
    self.priorityButton.selected = YES;
    self.priorityCancelButton.hidden = NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"NewEntryToDate"]) {
        DueDateViewController *dueDateVC = segue.destinationViewController;
        dueDateVC.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"NewEntryToPriority"]) {
        PriorityViewController *priorityVC = segue.destinationViewController;
        priorityVC.delegate = self;
    }
}

@end

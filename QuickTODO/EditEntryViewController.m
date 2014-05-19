//
//  EditEntryViewController.m
//  QuickTODO
//
//  Created by Daniel Munoz on 3/13/14.
//  Copyright (c) 2014 GreenCraft. All rights reserved.
//

#import "EditEntryViewController.h"

@interface EditEntryViewController ()
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
@property (nonatomic, strong) EditOptionsTableViewController *editOptionsVC;
@end

@implementation EditEntryViewController

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
    self.title = @"Edit task";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToOption:) name:@"editOptionSelected" object:nil];
    [self configureFields];
}

- (void)configureFields{
    [self.contentTextField setText:self.todoItem.content];
    
}

- (void)goToOption:(NSNotification *)notification{
    int option = [[[notification userInfo] valueForKey:@"type"] intValue];
    if (option == 0) {
        [self performSegueWithIdentifier:@"EditToDueDate" sender:self];
    }
    else{
        [self performSegueWithIdentifier:@"EditToPriority" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"EditToDueDate"]) {
        DueDateViewController *dueDateVC = segue.destinationViewController;
        dueDateVC.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"EditToPriority"]) {
        PriorityViewController *priorityVC = segue.destinationViewController;
        priorityVC.delegate = self;
    }
    else if([segue.identifier isEqualToString:@"LoadEditOptions"]){
        self.editOptionsVC = segue.destinationViewController;
        [self.editOptionsVC setDate:self.todoItem.dueDate];
        [self.editOptionsVC setPriority:self.todoItem.priority.intValue];
    }
}

- (void)dueDateVCDelegate:(DueDateViewController *)controller selectedDate:(NSDate *)date{
    [self.editOptionsVC configureCellsWithDate:date];
    [self.todoItem setDueDate:date];
}

- (void)PriorityVCDelegate:(PriorityViewController *)controller returnedPriorityLevel:(int)priorityLevel{
    [self.editOptionsVC configureCellsWithPriority:priorityLevel];
    [self.todoItem setPriority:[NSNumber numberWithInt:priorityLevel]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveEdits:(id)sender {
    [self.todoItem setContent:self.contentTextField.text];
    [self.managedObjectContext updatedObjects];
    NSError *saveError = nil;
    ZAssert([self.managedObjectContext save:&saveError], @"Error saving moc: %@\n%@", [saveError localizedDescription], [saveError userInfo]);
    if (saveError != nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:saveError.description delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        [self editParseInfo];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)editParseInfo{
    PFQuery *query = [PFQuery queryWithClassName:@"TodoItem"];
    [query whereKey:@"uri" equalTo:self.todoItem.objectID.URIRepresentation.relativeString];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error) {
            PFObject *todoObject = [objects objectAtIndex:0];
                todoObject[@"content"] = self.todoItem.content;
                todoObject[@"priority"] = self.todoItem.priority;
                todoObject[@"completed"] = [NSNumber numberWithBool:self.todoItem.completed.boolValue];
                if (self.todoItem.dueDate != nil) {
                    todoObject[@"dueDate"] = self.todoItem.dueDate;
                }
                todoObject[@"uri"] = self.todoItem.objectID.URIRepresentation.relativeString;
                [todoObject saveEventually];
                
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

@end

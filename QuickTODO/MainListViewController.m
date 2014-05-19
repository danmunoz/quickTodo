//
//  MainListViewController.m
//  QuickTODO
//
//  Created by Daniel Munoz on 3/5/14.
//  Copyright (c) 2014 GreenCraft. All rights reserved.
//

#import "MainListViewController.h"
#import "AppDelegate.h"
#import "TodoItem.h"


@interface MainListViewController ()
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *addLabel;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) NSFetchedResultsController *currentFetchedResultsController;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsControllerDueDate;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsControllerPriority;


@end

@implementation MainListViewController
@synthesize fetchedResultsController, fetchedResultsControllerDueDate, fetchedResultsControllerPriority;

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
}

- (void)viewWillAppear:(BOOL)animated{
    [self.listTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadTableView{
    self.shouldLoadTableView = YES;
    AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegateTemp.managedObjectContext;
    [self.listTableView reloadData];
}

#pragma mark -
#pragma mark UITableViewDataSource methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"";
    }
    return @"Completed";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegateTemp.managedObjectContext;
    if (self.managedObjectContext == nil) {
        [self.listTableView setHidden:YES];
        self.managedObjectContext = appDelegateTemp.managedObjectContext;
        return 0;
    }
    switch (self.sorting) {
        case SORTING_TYPE_REGULAR:{
            return [[[self fetchedResultsController] sections] count];
        }
            break;
        case SORTING_TYPE_DUE_DATE:{
            return [[[self fetchedResultsControllerDueDate] sections] count];
        }
            break;
        case SORTING_TYPE_PRIORITY:{
            return [[[self fetchedResultsControllerPriority] sections] count];
        }
            break;
        default:
            break;
    }
    return [[[self fetchedResultsController] sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
        if (appDelegateTemp.managedObjectContext == nil) {
            [self.listTableView setHidden:YES];
            return 0;
        }
        self.managedObjectContext = appDelegateTemp.managedObjectContext;
    NSArray *sections = [[self currentFetchedResultsController] sections];
    switch (self.sorting) {
        case SORTING_TYPE_REGULAR:{
            sections = [[self fetchedResultsController] sections];
        }
            break;
        case SORTING_TYPE_DUE_DATE:{
            sections = [[self fetchedResultsControllerDueDate] sections];
        }
            break;
        case SORTING_TYPE_PRIORITY:{
            sections = [[self fetchedResultsControllerPriority] sections];
        }
            break;
        default:
            break;
    }
    id <NSFetchedResultsSectionInfo> sectionInfo = nil;
    sectionInfo = [sections objectAtIndex:section];
    unsigned long numberOfRows = [sectionInfo numberOfObjects];
    if (numberOfRows == 0) {
        [self.listTableView setHidden:YES];
    }
    else{
        [self.listTableView setHidden:NO];
        [self.addButton setHidden:YES];
        [self.addLabel setHidden:YES];
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"todoCell"];
    if (cell == nil) {
        cell = [[ItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"todoCell"];
    }
    TodoItem *item;
    switch (self.sorting) {
        case SORTING_TYPE_REGULAR:{
            item = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        }
            break;
        case SORTING_TYPE_DUE_DATE:{
            item = [[self fetchedResultsControllerDueDate] objectAtIndexPath:indexPath];
        }
            break;
        case SORTING_TYPE_PRIORITY:{
            item = [[self fetchedResultsControllerPriority] objectAtIndexPath:indexPath];
        }
            break;
        default:
            break;
    }
    [cell.content setText:item.content];
    [cell setItemId:[[item objectID] URIRepresentation]];
    [cell setItem:item];
    if ([item.completed boolValue]) {
        [[cell checkMarkButton] setSelected:YES];
    }
    else{
        [[cell checkMarkButton] setSelected:NO];
    }
    if (item.dueDate != nil) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/yyyy"];
        NSString *stringFromDate = [formatter stringFromDate:item.dueDate];
        [cell.dateLabel setText:[NSString stringWithFormat:@"Due: %@", stringFromDate]];
    }
    else{
        [cell.dateLabel setText:@""];
    }
    switch (item.priority.intValue) {
        case 0:
            [cell.priorityImage setImage:[UIImage imageNamed:@"priority_v_l_arrow"]];
            break;
        case 1:
            [cell.priorityImage setImage:[UIImage imageNamed:@"priority_l_arrow"]];
            break;
        case 2:
            [cell.priorityImage setImage:[UIImage imageNamed:@"priority_m_arrow"]];
            break;
        case 3:
            [cell.priorityImage setImage:[UIImage imageNamed:@"priority_h_arrow"]];
            break;
        case 4:
            [cell.priorityImage setImage:[UIImage imageNamed:@"priority_v_h_arrow"]];
            break;
            
        default:
            break;
    }
    [cell setDelegate:self];
    return cell;
}

#pragma mark - ItemCellDelegate Methods

- (void)itemCellDelegate:(ItemCell *)selector changedSelectedState:(BOOL)selected forURI:(NSURL *)uri{
    [self changeSelectedStateOfCellWithUri:uri toNewState:selected];
}

- (void)changeSelectedStateOfCellWithUri:(NSURL*)uri toNewState:(BOOL)state{
    NSFetchRequest * allToDos = [[NSFetchRequest alloc] init];
    [allToDos setEntity:[NSEntityDescription entityForName:@"TodoItem" inManagedObjectContext:self.managedObjectContext]];
    NSPredicate *predicate;
    AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
    
    NSManagedObjectID *objectID = [[appDelegateTemp persistentStoreCoordinator] managedObjectIDForURIRepresentation:uri];
    predicate = [NSPredicate predicateWithFormat:@"self == %@", objectID];

    [allToDos setPredicate:predicate];
    
    NSError * error = nil;
    NSArray * toDos = [self.managedObjectContext executeFetchRequest:allToDos error:&error];
    if (error != nil) {
        NSLog(@"Error not nil: %@", error.description);
    }
    if ([toDos count] > 0) {
        TodoItem *item = [toDos objectAtIndex:0];
        [item setCompleted:[NSNumber numberWithBool:state]];
        [self.managedObjectContext updatedObjects];
        NSError *saveError = nil;
        ZAssert([self.managedObjectContext save:&saveError], @"Error saving moc: %@\n%@", [saveError localizedDescription], [saveError userInfo]);
        if (saveError == nil) {
            [self editParseInfo:item];
        }
    }
}

- (void)editParseInfo:(TodoItem*)todoItem{
    PFQuery *query = [PFQuery queryWithClassName:@"TodoItem"];
    [query whereKey:@"uri" equalTo:todoItem.objectID.URIRepresentation.relativeString];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error) {
            PFObject *todoObject = [objects objectAtIndex:0];
            todoObject[@"completed"] = [NSNumber numberWithBool:todoItem.completed.boolValue];
            [todoObject saveEventually];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}



- (void)newEntryViewController:(NewEntryViewController *)controller finishedSaving:(BOOL)hasSaved{
    if (hasSaved) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSFetchRequest * allToDos = [[NSFetchRequest alloc] init];
    [allToDos setEntity:[NSEntityDescription entityForName:@"TodoItem" inManagedObjectContext:self.managedObjectContext]];
    NSPredicate *predicate;
    switch (self.sorting) {
        case SORTING_TYPE_REGULAR:{
            predicate = [NSPredicate predicateWithFormat:@"content == %@", [[self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row] content]];
        }
            break;
        case SORTING_TYPE_DUE_DATE:{
            predicate = [NSPredicate predicateWithFormat:@"content == %@", [[self.fetchedResultsControllerDueDate.fetchedObjects objectAtIndex:indexPath.row] content]];
        }
            break;
        case SORTING_TYPE_PRIORITY:{
            predicate = [NSPredicate predicateWithFormat:@"content == %@", [[self.fetchedResultsControllerPriority.fetchedObjects objectAtIndex:indexPath.row] content]];
        }
            break;
        default:
            break;
    }
    [allToDos setPredicate:predicate];
    NSError * error = nil;
    NSArray * toDos = [self.managedObjectContext executeFetchRequest:allToDos error:&error];
    TodoItem *item = (TodoItem*)[toDos objectAtIndex:0];
    NSString *uri = item.objectID.URIRepresentation.relativeString;
        [self.managedObjectContext deleteObject:[toDos objectAtIndex:0]];
    NSError *saveError = nil;
    ZAssert([self.managedObjectContext save:&saveError], @"Error saving moc: %@\n%@", [saveError localizedDescription], [saveError userInfo]);
    if (saveError == nil) {
        [self deleteInfoOnParseWithItem:uri];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ItemCell *cell = (ItemCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSManagedObject *managedObject = cell.item;
    [self performSegueWithIdentifier:@"MainToEdit" sender:managedObject];
}

#pragma mark -

- (void)deleteInfoOnParseWithItem:(NSString *)uri{
    PFQuery *query = [PFQuery queryWithClassName:@"TodoItem"];
    [query whereKey:@"uri" equalTo:uri];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error) {
            // Do something with the found objects
            [[objects objectAtIndex:0] deleteInBackground];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ListToNewItem"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        NewEntryViewController *entryViewController = [navigationController viewControllers][0];
        entryViewController.delegate = self;
        entryViewController.managedObjectContext = self.managedObjectContext;
    }
    if ([segue.identifier isEqualToString:@"MainToEdit"]) {
        EditEntryViewController *editViewController = segue.destinationViewController;
        editViewController.managedObjectContext = self.managedObjectContext;
        editViewController.todoItem = (TodoItem *)sender;
    }
}

- (IBAction)add:(id)sender {
    [self performSegueWithIdentifier:@"ListToNewItem" sender:self];
}

- (IBAction)edit:(id)sender {
    [self.listTableView setEditing:!self.listTableView.editing animated:YES];
}


#pragma mark - Fetched results controller
- (NSFetchedResultsController *)fetchedResultsController {
    if (fetchedResultsController) return fetchedResultsController;
    NSManagedObjectContext *moc = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = nil;
    fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"TodoItem"];
    
    NSMutableArray *sortArray = [NSMutableArray array];
    [sortArray addObject:[[NSSortDescriptor alloc] initWithKey:@"completed"
                                                     ascending:YES]];
    [sortArray addObject:[[NSSortDescriptor alloc] initWithKey:@"content"
                                                     ascending:YES]];
    [fetchRequest setSortDescriptors:sortArray];
    
    NSFetchedResultsController *frc = nil;
    frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                              managedObjectContext:moc
                                                sectionNameKeyPath:@"completed"
                                                         cacheName:nil];
    
    [self setFetchedResultsController:frc];
    [[self fetchedResultsController] setDelegate:self];
    NSError *error = nil;
    ZAssert([[self fetchedResultsController] performFetch:&error],
            @"Unresolved error %@\n%@", [error localizedDescription],
            [error userInfo]);
    
    return fetchedResultsController;
}

- (NSFetchedResultsController *)fetchedResultsControllerDueDate {
    if (fetchedResultsControllerDueDate) return fetchedResultsControllerDueDate;
    NSManagedObjectContext *moc = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = nil;
    fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"TodoItem"];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"dueDate"
                                                         ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dueDate != nil  && completed == NO"];
    [fetchRequest setPredicate:predicate];
    NSFetchedResultsController *frc = nil;
    frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                              managedObjectContext:moc
                                                sectionNameKeyPath:nil
                                                         cacheName:nil];
    
    [self setFetchedResultsControllerDueDate:frc];
    [[self fetchedResultsControllerDueDate] setDelegate:self];
    NSError *error = nil;
    ZAssert([[self fetchedResultsControllerDueDate] performFetch:&error], @"Unresolved error %@\n%@", [error localizedDescription], [error userInfo]);
    return fetchedResultsControllerDueDate;
}

- (NSFetchedResultsController *)fetchedResultsControllerPriority {
    NSLog(@"HERE");
    if (fetchedResultsControllerPriority) return fetchedResultsControllerPriority;
    NSManagedObjectContext *moc = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = nil;
    fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"TodoItem"];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"priority" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"priority >= 0 && completed == NO"];
    [fetchRequest setPredicate:predicate];
    NSFetchedResultsController *frc = nil;
    frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                              managedObjectContext:moc
                                                sectionNameKeyPath:nil
                                                         cacheName:nil];
    
    [self setFetchedResultsControllerPriority:frc];
    [[self fetchedResultsControllerPriority] setDelegate:self];
    NSError *error = nil;
    ZAssert([[self fetchedResultsControllerPriority] performFetch:&error], @"Unresolved error %@\n%@", [error localizedDescription], [error userInfo]);
    return fetchedResultsControllerPriority;
}

#pragma mark - NSFetchedResultsControllerDelegate Methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [[self listTableView] beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:sectionIndex]; switch(type) {
        case NSFetchedResultsChangeInsert:
            [[self listTableView] insertSections:indexSet
                            withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [[self listTableView] deleteSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
             break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    NSArray *newArray;
    NSArray *oldArray;
    if (indexPath != nil) {
        oldArray = [NSArray arrayWithObject:indexPath];
    }
    if (newIndexPath != nil) {
        newArray = [NSArray arrayWithObject:newIndexPath];
    }
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [[self listTableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [[self listTableView] deleteRowsAtIndexPaths:oldArray
                                    withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate: {
            ItemCell *cell = nil;
            NSManagedObject *object = nil;
            cell = (ItemCell *)[[self listTableView] cellForRowAtIndexPath:indexPath];
            switch (self.sorting) {
                case SORTING_TYPE_REGULAR:{
                    object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
                }
                    break;
                case SORTING_TYPE_DUE_DATE:{
                    object = [[self fetchedResultsControllerDueDate] objectAtIndexPath:indexPath];
                }
                    break;
                case SORTING_TYPE_PRIORITY:{
                    object = [[self fetchedResultsControllerPriority] objectAtIndexPath:indexPath];
                }
                    break;
                default:
                    break;
            }
            [cell.content setText:[object valueForKey:@"content"]];
            break;
        }
        case NSFetchedResultsChangeMove:
            [[self listTableView] deleteRowsAtIndexPaths:oldArray
                                    withRowAnimation:UITableViewRowAnimationFade];
            [[self listTableView] insertRowsAtIndexPaths:newArray
                                    withRowAnimation:UITableViewRowAnimationFade];
        break; }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [[self listTableView] endUpdates];
}

@end

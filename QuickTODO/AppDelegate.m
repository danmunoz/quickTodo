//
//  AppDelegate.m
//  QuickTODO
//
//  Created by Daniel Munoz on 3/4/14.
//  Copyright (c) 2014 GreenCraft. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "LoginNavigationViewController.h"
#import "MainListNavigationController.h"
#import "MainListViewController.h"

#import "TodoItem.h"
@interface AppDelegate()
@property (nonatomic, strong) MainListViewController *rootVC;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //initializing Core Data Stack
    [self initializeCoreDataStack];
    //setting up Parse
    [Parse setApplicationId:@"48kzhZ288xPQM0lUOgZYEQOOU6rD2NTmor5Kpns4"
                  clientKey:@"uGk9wh0Qi4piiWxXUKtHgZKM97PScpUg1cGhRj39"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    //setting up the notification listeners
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(swapToMainViewAfterLogin) name:@"loginSuccessful" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:@"logout" object:nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:@"loggedIn"]boolValue]) {//logged in
        self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    }
    else {//not logged in
        [self showLoginAnimated:NO];
    }
    return YES;
}

- (void)customizeAppearance{
    UIImage *navBarBg = [[UIImage imageNamed:@"navigation_bar_background"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    // Set the background image for *all* UINavigationBars
    [[UINavigationBar appearance] setBackgroundImage:navBarBg
                                       forBarMetrics:UIBarMetricsDefault];
}

- (void)getItemsForEmail:(NSString *)email{
    PFQuery *query = [PFQuery queryWithClassName:@"TodoItem"];
    [query whereKey:@"email" equalTo:email];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error) {
            // Do something with the found objects
            if ([self storeRetrievedValuesToDB:objects]) {
                NSLog(@"Values from parse in Core Data!");
            }
            else{
                NSLog(@"Error putting parse to core data");
            }
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (BOOL)storeRetrievedValuesToDB:(NSArray *)values{
    for (PFObject *object in values) {
        TodoItem *todoItem = [NSEntityDescription insertNewObjectForEntityForName:@"TodoItem" inManagedObjectContext:self.managedObjectContext];
        NSError *error = nil;
        todoItem.content = object[@"content"];
        [todoItem setPriority:[NSNumber numberWithInt:[[object objectForKey:@"priority"] intValue]]];
        [todoItem setCompleted:[NSNumber numberWithBool:[[object objectForKey:@"completed"] boolValue]]];
        if ([object objectForKey:@"dueDate"] != nil){
            [todoItem setDueDate:object[@"dueDate"]];
        }
        ZAssert([self.managedObjectContext save:&error], @"Error saving moc: %@\n%@", [error localizedDescription], [error userInfo]);
        if (error != nil) {
            NSLog(@"Error while Saving data");
            return NO;
        }
        else{
            object[@"uri"] = todoItem.objectID.URIRepresentation.relativeString;
            [object saveEventually];
        }
    }
    return YES;
}

#pragma mark -
#pragma mark Core Data

- (void)testCoreDataFetch{
    
    NSManagedObjectContext *moc = [self managedObjectContext]; NSFetchRequest *request = [[NSFetchRequest alloc] init]; [request setEntity:[NSEntityDescription entityForName:@"TodoItem"
                                                                                                                                                       inManagedObjectContext:moc]];
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error]; if (error) {
        NSLog(@"Error: %@\n%@", [error localizedDescription], [error userInfo]);
        return; }
    NSLog(@"Objects found: %lu", (unsigned long)results.count);
}


- (void)initializeCoreDataStack {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TODOModel" withExtension:@"momd"];
    ZAssert(modelURL, @"Failed to find model URL");
    NSManagedObjectModel *mom = nil;
    mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    ZAssert(mom, @"Failed to initialize model");
    
    NSPersistentStoreCoordinator *psc = nil;
    psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    ZAssert(psc, @"Failed to initialize persistent store coordinator");
    [self setPersistentStoreCoordinator:psc];
    NSManagedObjectContext *moc = nil;
    NSManagedObjectContextConcurrencyType ccType = NSMainQueueConcurrencyType;
    moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:ccType];
    [moc setPersistentStoreCoordinator:psc];
    [self setManagedObjectContext:moc];

    
    dispatch_queue_t queue = NULL;
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *directoryArray = [fileManager URLsForDirectory:NSDocumentDirectory
                                                      inDomains:NSUserDomainMask];
        NSURL *storeURL = nil;
        storeURL = [directoryArray lastObject];
        storeURL = [storeURL URLByAppendingPathComponent:@"TODOModel.sqlite"];
        NSError *error = nil;
        NSPersistentStore *store = nil;
        store = [psc addPersistentStoreWithType:NSSQLiteStoreType
                                  configuration:nil
                                            URL:storeURL
                                        options:nil
                                          error:&error];
        if (!store) {
            ALog(@"Error adding persistent store to coordinator %@\n%@",
                 [error localizedDescription], [error userInfo]);
            //Present a user facing error￼￼￼
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            DLog(@"Store coordinator added");
        });
    });
}

#pragma mark -
#pragma mark Login/Logout Notifiers

- (void)swapToMainViewAfterLogin{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self getItemsForEmail:[defaults objectForKey:@"email"]];
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:^{
        [self.window setRootViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController]];
    }];
}

- (void)logout{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainListNavigationController *viewController = (MainListNavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"mainController"];
    [self.window setRootViewController:viewController];
    [self showLoginAnimated:NO];
    [self deleteAllContents];
}

- (void)showLoginAnimated:(BOOL)animated{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginNavigationViewController *viewController = (LoginNavigationViewController *)[storyboard instantiateViewControllerWithIdentifier:@"loginNavigationViewController"];
    [self.window makeKeyAndVisible];
    [self.window.rootViewController presentViewController:viewController
                                                 animated:animated
                                               completion:nil];
}

- (void)deleteAllContents{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"loggedIn"];
    [defaults removeObjectForKey:@"email"];
    [defaults synchronize];
    NSFetchRequest * allToDos = [[NSFetchRequest alloc] init];
    [allToDos setEntity:[NSEntityDescription entityForName:@"TodoItem" inManagedObjectContext:self.managedObjectContext]];
    [allToDos setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * toDos = [self.managedObjectContext executeFetchRequest:allToDos error:&error];
    for (NSManagedObject * item in toDos) {
        [self.managedObjectContext deleteObject:item];
    }
    NSError *saveError = nil;
    [self.managedObjectContext save:&saveError];
}

@end

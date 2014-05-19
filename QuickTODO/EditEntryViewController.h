//
//  EditEntryViewController.h
//  QuickTODO
//
//  Created by Daniel Munoz on 3/13/14.
//  Copyright (c) 2014 GreenCraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "TodoItem.h"
#import "DueDateViewController.h"
#import "PriorityViewController.h"
#import "EditOptionsTableViewController.h"

@interface EditEntryViewController : UIViewController<DueDateVCDelegate, PriorityVCDelegate>
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) TodoItem *todoItem;
- (IBAction)saveEdits:(id)sender;
@end

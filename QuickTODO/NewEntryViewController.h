//
//  NewEntryViewController.h
//  QuickTODO
//
//  Created by Daniel Munoz on 3/5/14.
//  Copyright (c) 2014 GreenCraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DueDateViewController.h"
#import "PriorityViewController.h"

@class NewEntryViewController;
@protocol newEntryViewControllerDelegate <NSObject>
@optional
- (void)newEntryViewController:(NewEntryViewController *)controller finishedSaving:(BOOL)hasSaved;

@end

@interface NewEntryViewController : UIViewController<UITextFieldDelegate, DueDateVCDelegate, PriorityVCDelegate>
@property (nonatomic, weak) id<newEntryViewControllerDelegate> delegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)deleteDueDate:(id)sender;
- (IBAction)deletePriority:(id)sender;

@end

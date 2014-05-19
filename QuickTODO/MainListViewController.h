//
//  MainListViewController.h
//  QuickTODO
//
//  Created by Daniel Munoz on 3/5/14.
//  Copyright (c) 2014 GreenCraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMSlideMenuMainViewController.h"
#import "NewEntryViewController.h"
#import "EditEntryViewController.h"
#import "ItemCell.h"
#import "EditEntryViewController.h"

typedef enum{
    SORTING_TYPE_REGULAR=0,
    SORTING_TYPE_DUE_DATE=1,
    SORTING_TYPE_PRIORITY=2
}SORTING_TYPE;

@interface MainListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, newEntryViewControllerDelegate, NSFetchedResultsControllerDelegate, ItemCellDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) BOOL shouldLoadTableView;
@property (nonatomic) SORTING_TYPE sorting;
- (IBAction)add:(id)sender;
- (IBAction)edit:(id)sender;
- (void)reloadTableView;

@end

//
//  EditOptionsTableViewController.h
//  QuickTODO
//
//  Created by Daniel Munoz on 3/13/14.
//  Copyright (c) 2014 GreenCraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditOptionsTableViewController : UITableViewController
@property (nonatomic, strong) NSDate *date;
@property (nonatomic) int priority;
- (void)configureCellsWithDate:(NSDate *)date;
- (void)configureCellsWithPriority:(int)priority;
@end

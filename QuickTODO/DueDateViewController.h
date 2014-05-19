//
//  DueDateViewController.h
//  QuickTODO
//
//  Created by Daniel Munoz on 3/9/14.
//  Copyright (c) 2014 GreenCraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSQCalendarView.h"
@class DueDateViewController;
@protocol DueDateVCDelegate <NSObject>

@optional
- (void)dueDateVCDelegate:(DueDateViewController*)controller selectedDate:(NSDate*)date;

@end

@interface DueDateViewController : UIViewController<TSQCalendarViewDelegate>
@property (nonatomic, weak) id<DueDateVCDelegate> delegate;
- (IBAction)goBack:(id)sender;
- (IBAction)selectDate:(id)sender;
- (IBAction)selectDateFromBar:(id)sender;

@end

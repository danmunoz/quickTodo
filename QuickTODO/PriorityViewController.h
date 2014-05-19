//
//  PriorityViewController.h
//  QuickTODO
//
//  Created by Daniel Munoz on 3/9/14.
//  Copyright (c) 2014 GreenCraft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PriorityViewController;
@protocol PriorityVCDelegate <NSObject>

@optional
- (void)PriorityVCDelegate:(PriorityViewController*)controller returnedPriorityLevel:(int)priorityLevel;

@end
@interface PriorityViewController : UIViewController
@property (nonatomic, weak) id <PriorityVCDelegate> delegate;
- (IBAction)goBack:(id)sender;
- (IBAction)selectPriority:(id)sender;

@end

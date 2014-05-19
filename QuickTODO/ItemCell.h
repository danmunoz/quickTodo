//
//  ItemCell.h
//  QuickTODO
//
//  Created by Daniel Munoz on 3/10/14.
//  Copyright (c) 2014 GreenCraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodoItem.h"
@class ItemCell;
@protocol ItemCellDelegate <NSObject>

@optional
- (void)itemCellDelegate:(ItemCell *)selector changedSelectedState:(BOOL)selected forURI:(NSURL*)uri;

@end
@interface ItemCell : UITableViewCell
@property (nonatomic, weak) id <ItemCellDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIButton *checkMarkButton;
@property (nonatomic, strong) IBOutlet UILabel *content;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UIImageView *priorityImage;
@property (nonatomic, strong) NSURL *itemId;
@property (nonatomic, strong) NSManagedObject *item;
- (IBAction)checkMarkPressed:(id)sender;
@end

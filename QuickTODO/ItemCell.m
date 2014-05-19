//
//  ItemCell.m
//  QuickTODO
//
//  Created by Daniel Munoz on 3/10/14.
//  Copyright (c) 2014 GreenCraft. All rights reserved.
//

#import "ItemCell.h"

@implementation ItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)checkMarkPressed:(id)sender{
    self.checkMarkButton.selected = !self.checkMarkButton.selected;
    if ([self.delegate respondsToSelector:@selector(itemCellDelegate:changedSelectedState:forURI:)]) {
        [self.delegate itemCellDelegate:self changedSelectedState:self.checkMarkButton.selected forURI:self.itemId];
    }
}

@end

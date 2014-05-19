//
//  MainVC.m
//  QuickTODO
//
//  Created by Daniel Munoz on 3/12/14.
//  Copyright (c) 2014 GreenCraft. All rights reserved.
//

#import "MainVC.h"

@interface MainVC ()

@end

@implementation MainVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.leftPanDisabled = YES;
    self.rightPanDisabled = YES;
}

- (NSString *)segueIdentifierForIndexPathInLeftMenu:(NSIndexPath *)indexPath{
    NSString *identifier;
    switch (indexPath.row) {
        case 0:{
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithLong:indexPath.row] forKey:@"type"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"sortByDueDate" object:self userInfo:userInfo];
            identifier = @"MenuToMain";
        }
            break;
        case 1:{
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithLong:indexPath.row] forKey:@"type"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"sortByDueDate" object:self userInfo:userInfo];
            identifier = @"MenuToMain";
        }
            break;
        case 2:{
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithLong:indexPath.row] forKey:@"type"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"sortByDueDate" object:self userInfo:userInfo];
            identifier = @"MenuToMain";
        }
            break;
        case 3://logout
            [self logout];
            break;
        default:
            break;
    }
    return identifier;
}

- (void)logout{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"loggedIn"];
    [defaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:self];
}

- (void)configureLeftMenuButton:(UIButton *)button{
    CGRect frame = button.frame;
    frame.origin = (CGPoint){0,0};
    frame.size = (CGSize){18,12};
    button.frame = frame;
    [button setImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];
}

- (CGFloat)leftMenuWidth{
    return 180;
}

@end

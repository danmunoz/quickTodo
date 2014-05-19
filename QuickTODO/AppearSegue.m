//
//  AppearSegue.m
//  QuickTODO
//
//  Created by Daniel Munoz on 3/4/14.
//  Copyright (c) 2014 GreenCraft. All rights reserved.
//

#import "AppearSegue.h"

@implementation AppearSegue

- (void) perform {
    UIViewController *src = (UIViewController *) self.sourceViewController;
    UIViewController *dst = (UIViewController *) self.destinationViewController;
    [dst.view setFrame:CGRectMake(0, 0, 768, 955)];
    [UIView transitionFromView:src.view toView:dst.view duration:1 options:UIViewAnimationOptionTransitionNone completion:nil];
}

@end

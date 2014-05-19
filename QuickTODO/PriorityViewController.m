//
//  PriorityViewController.m
//  QuickTODO
//
//  Created by Daniel Munoz on 3/9/14.
//  Copyright (c) 2014 GreenCraft. All rights reserved.
//

#import "PriorityViewController.h"

@interface PriorityViewController ()
@property (weak, nonatomic) IBOutlet UIButton *veryHighButton;
@property (weak, nonatomic) IBOutlet UIButton *highButton;
@property (weak, nonatomic) IBOutlet UIButton *mediumButton;
@property (weak, nonatomic) IBOutlet UIButton *lowButton;
@property (weak, nonatomic) IBOutlet UIButton *veryLowButton;

@end

@implementation PriorityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)selectPriority:(id)sender {
    if (sender == self.veryHighButton) {
        if ([self.delegate respondsToSelector:@selector(PriorityVCDelegate:returnedPriorityLevel:)]) {
            [self.delegate PriorityVCDelegate:self returnedPriorityLevel:4];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (sender == self.highButton) {
        if ([self.delegate respondsToSelector:@selector(PriorityVCDelegate:returnedPriorityLevel:)]) {
            [self.delegate PriorityVCDelegate:self returnedPriorityLevel:3];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (sender == self.mediumButton) {
        if ([self.delegate respondsToSelector:@selector(PriorityVCDelegate:returnedPriorityLevel:)]) {
            [self.delegate PriorityVCDelegate:self returnedPriorityLevel:2];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (sender == self.lowButton) {
        if ([self.delegate respondsToSelector:@selector(PriorityVCDelegate:returnedPriorityLevel:)]) {
            [self.delegate PriorityVCDelegate:self returnedPriorityLevel:1];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (sender == self.veryLowButton) {
        if ([self.delegate respondsToSelector:@selector(PriorityVCDelegate:returnedPriorityLevel:)]) {
            [self.delegate PriorityVCDelegate:self returnedPriorityLevel:0];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
@end

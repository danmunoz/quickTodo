//
//  MenuViewController.m
//  QuickTODO
//
//  Created by Daniel Munoz on 3/12/14.
//  Copyright (c) 2014 GreenCraft. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()
@property (nonatomic, strong) MainListViewController *mainListVC;
@property (nonatomic) int option;
@end

@implementation MenuViewController

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
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars=NO;
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableWithSorting:) name:@"sortByDueDate" object:nil];
	// Do any additional setup after loading the view.
}

- (void)reloadTableWithSorting:(NSNotification *)notification{
    int option = [[[notification userInfo] valueForKey:@"type"] intValue];
    self.option = option;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UINavigationController *navigationController = segue.destinationViewController;
    self.mainListVC = [navigationController viewControllers][0];
    [self.mainListVC setSorting:self.option];
}
@end

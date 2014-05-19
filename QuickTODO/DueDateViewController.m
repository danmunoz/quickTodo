//
//  DueDateViewController.m
//  QuickTODO
//
//  Created by Daniel Munoz on 3/9/14.
//  Copyright (c) 2014 GreenCraft. All rights reserved.
//

#import "DueDateViewController.h"
#import "TSQCalendarRowCell.h"
@interface DueDateViewController ()
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *selectBarButton;
@property (weak, nonatomic) UIView *calendarView;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic) BOOL dateIsSelected;
@end

@implementation DueDateViewController

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
    self.dateIsSelected = NO;    
    TSQCalendarView *calendarView = [[TSQCalendarView alloc] init];
    calendarView.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    calendarView.rowCellClass = [TSQCalendarRowCell class];
    calendarView.firstDate = [NSDate date];
    calendarView.lastDate = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * 365 * 5];
    calendarView.backgroundColor = [UIColor colorWithRed:0.84f green:0.85f blue:0.86f alpha:1.0f];
    calendarView.pagingEnabled = YES;
    CGFloat onePixel = 1.0f / [UIScreen mainScreen].scale;
    calendarView.contentInset = UIEdgeInsetsMake(0.0f, onePixel, 0.0f, onePixel);
    calendarView.delegate = self;
    self.calendarView = calendarView;
    CGRect frame = self.view.bounds;
    frame.size = CGSizeMake(frame.size.width, frame.size.height-67);
    frame.origin = CGPointMake(frame.origin.x, frame.origin.y+67);
    self.calendarView.frame = frame;
    [self.view addSubview:self.calendarView];
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

- (IBAction)selectDate:(id)sender {
    if ([self.delegate respondsToSelector:@selector(dueDateVCDelegate:selectedDate:)]) {
        [self.delegate dueDateVCDelegate:self selectedDate:self.selectedDate];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)selectDateFromBar:(id)sender {
    if ([self.delegate respondsToSelector:@selector(dueDateVCDelegate:selectedDate:)]) {
        [self.delegate dueDateVCDelegate:self selectedDate:self.selectedDate];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)calendarView:(TSQCalendarView *)calendarView didSelectDate:(NSDate *)date{
    self.selectedDate = date;
    [self.selectButton setEnabled:YES];
    [self.selectBarButton setEnabled:YES];
}
@end

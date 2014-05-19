//
//  EditOptionsTableViewController.m
//  QuickTODO
//
//  Created by Daniel Munoz on 3/13/14.
//  Copyright (c) 2014 GreenCraft. All rights reserved.
//

#import "EditOptionsTableViewController.h"

@interface EditOptionsTableViewController ()

@end

@implementation EditOptionsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self configureCellsWithDate:self.date andPriority:self.priority];
}

- (void)configureCellsWithDate:(NSDate *)date andPriority:(int)priority{
    self.date = date;
    self.priority = priority;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSString *stringFromDate = [formatter stringFromDate:self.date];
    UITableView *tv = self.tableView;
    UITableViewCell *cell = [tv cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell.detailTextLabel setText:stringFromDate];

    cell = [tv cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    switch (self.priority) {
        case -1:
            [cell.detailTextLabel setText:@""];
            break;
        case 0:
            [cell.detailTextLabel setText:@"Very low"];
            break;
        case 1:
            [cell.detailTextLabel setText:@"Low"];
            break;
        case 2:
            [cell.detailTextLabel setText:@"Medium"];
            break;
        case 3:
            [cell.detailTextLabel setText:@"High"];
            break;
        case 4:
            [cell.detailTextLabel setText:@"Very high"];
            break;
        default:
            break;
    }
}

- (void)configureCellsWithDate:(NSDate *)date{
    self.date = date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSString *stringFromDate = [formatter stringFromDate:self.date];
    UITableView *tv = self.tableView;
    UITableViewCell *cell = [tv cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell.detailTextLabel setText:stringFromDate];
}

- (void)configureCellsWithPriority:(int)priority{
    self.priority = priority;
    UITableView *tv = self.tableView;
    UITableViewCell *cell = [tv cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    switch (self.priority) {
        case -1:
            [cell.detailTextLabel setText:@""];
            break;
        case 0:
            [cell.detailTextLabel setText:@"Very low"];
            break;
        case 1:
            [cell.detailTextLabel setText:@"Low"];
            break;
        case 2:
            [cell.detailTextLabel setText:@"Medium"];
            break;
        case 3:
            [cell.detailTextLabel setText:@"High"];
            break;
        case 4:
            [cell.detailTextLabel setText:@"Very high"];
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //add dictionary with the proper values being passed, too tired
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithLong:indexPath.row] forKey:@"type"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"editOptionSelected" object:self userInfo:userInfo];

}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

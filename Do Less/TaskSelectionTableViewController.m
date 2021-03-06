//
//  TaskTableViewController.m
//  Do Less
//
//  Created by Roc on 13-5-16.
//  Copyright (c) 2013年 Roc. All rights reserved.
//

#import "Task.h"
#import "TaskSelectionTableViewController.h"
#import "Common.h"

@interface TaskSelectionTableViewController ()

@property (strong, nonatomic) Task *model;

@end

@implementation TaskSelectionTableViewController

#pragma mark - Getter & Setter

- (Task *)model
{
    if (!_model) {
        _model = [[Task alloc] init];
    }
    return _model;
}

#pragma mark - View Controller

- (void)viewDidLoad
{
    [super viewDidLoad];

//    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    self.navigationController.navigationBar.barTintColor = [Common themeColors][self.navBarColorIndex];

    self.tableView.backgroundColor = [UIColor whiteColor];

   [[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(eventStoreChanged:)
                                             name:EKEventStoreChangedNotification
                                           object:self.model.eventStore];
}

- (void)eventStoreChanged:(NSNotification *)notification
{
    [self.tableView reloadData];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.model.lists count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *tasks = [self.model tasksWithSection:section];
    return [tasks count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    EKCalendar *list = self.model.lists[section];
    NSArray *tasks = [self.model tasksInList:list];
    return [tasks count] == 0 ? nil : list.title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setDoesRelativeDateFormatting:YES];
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Task" forIndexPath:indexPath];
    EKReminder *task = [self.model taskWithIndexPath:indexPath];

    cell.textLabel.text = task.title;

    // Dispaly task's due date if available
    if (task.dueDateComponents) {
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *dueDate = [gregorian dateFromComponents:task.dueDateComponents];

        cell.detailTextLabel.text = [dateFormatter stringFromDate:dueDate];
    } else {
        cell.detailTextLabel.text = @"";
    }

    // Show the checkmark if the task has been selected
    if ([self.todayTasks indexOfObject:task] == NSNotFound) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }

    return cell;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        EKReminder *task = [self.model taskWithIndexPath:indexPath];
//
//        NSError *error;
//        if ([self.model.eventStore removeReminder:task commit:YES error:&error]) {
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
//        } else {
//            [Common alert:[error localizedDescription]];
//        }
//    }
//}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    self.selectedTask = [self.model taskWithIndexPath:indexPath];

    [self performSegueWithIdentifier:@"BackToTasksToday" sender:self];
}

@end

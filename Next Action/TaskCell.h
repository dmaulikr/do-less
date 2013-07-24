//
//  TaskCell.h
//  tasklabel
//
//  Created by Roc on 13-7-17.
//  Copyright (c) 2013年 Roc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskCell : UITableViewCell

// The completing status of the task cell
@property (nonatomic, getter = isCompleted) BOOL completed;

// Mark the task cell as completed
- (void)setCompleted:(BOOL)completed animated:(BOOL)animated;

@end

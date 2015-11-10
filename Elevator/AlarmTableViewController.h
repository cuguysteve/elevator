//
//  AlarmTableViewController.h
//  Elevator
//
//  Created by user on 15/11/10.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Alarm.h"

@interface AlarmTableViewController : UITableViewController

- (void) updateAlarmList:(NSArray*)array;
@property NSInteger sn;
@property NSArray* alarmList;

@end

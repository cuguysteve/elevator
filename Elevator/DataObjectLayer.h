//
//  DataObject.h
//  Elevator
//
//  Created by user on 15/8/26.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeneralTableViewController.h"
#import "ElevatorObject.h"

@interface DataObjectLayer : NSObject

@property GeneralTableViewController* generalTable;


- (ElevatorObject*) requestBySn:(NSString*) sn;
- (void) requestAlertList;
- (void) requestWarningList;
- (void) requestNormalList;
- (void) requestAllList;


@end

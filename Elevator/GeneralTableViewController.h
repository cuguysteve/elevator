//
//  GeneralTableViewController.h
//  Elevator
//
//  Created by user on 15/8/26.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GeneralTableViewController : UITableViewController

@property (copy) NSArray* allList;
@property (copy) NSArray* normalList;
@property (copy) NSArray* warningList;
@property (copy) NSArray* alertList;
- (void) updateAlert:(NSArray*)array;
- (void) updateWarning:(NSArray*)array;
- (void) updateNormal:(NSArray*)array;
- (void) updateAll:(NSArray*)array;

@end

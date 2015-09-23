//
//  MapViewController.h
//  Elevator
//
//  Created by 王小猴 on 15/9/22.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeneralTableViewController.h"

@interface MapViewController : UIViewController

@property GeneralTableViewController* generalTable;
- (void) refreshAnnotations;

@end

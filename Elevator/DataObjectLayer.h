//
//  DataObject.h
//  Elevator
//
//  Created by user on 15/8/26.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ElevatorObject.h"

@interface DataObjectLayer : NSObject

- (ElevatorObject*) requestBySn:(NSString*) sn;
- (NSArray*) requestAlertList;
- (NSArray*) requestWarningList;
- (NSArray*) requestAllList;

- (void)initData;

//for test Json
- (NSString*) requestTest;

@end

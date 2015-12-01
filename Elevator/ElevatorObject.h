//
//  ElevatorObject.h
//  Elevator
//
//  Created by user on 15/8/26.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

enum ElevatorStatus {
    ALERTING,
    WARNING,
    NORMAL
};

@interface ElevatorObject : NSObject <NSCopying, NSCoding>

@property NSString* sn;
@property NSString* address;
@property int status;
@property NSString* contactPerson;
@property NSString* contactNumber;
@property NSString* problem;
@property NSString* date;
@property NSString* vendor;
@property NSString* model;
@property double longtitude;
@property double latitude;

@end

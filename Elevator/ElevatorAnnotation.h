//
//  ElevatorAnnotation.h
//  Elevator
//
//  Created by 王小猴 on 15/9/23.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>
#import <UIKit/UIImage.h>
#import "ElevatorObject.h"

@interface ElevatorAnnotation : NSObject<MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic,copy) UIImage *image;
@property ElevatorObject* elevator;

@end

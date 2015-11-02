//
//  DataObject.m
//  Elevator
//
//  Created by user on 15/8/26.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "DataObjectLayer.h"

@implementation DataObjectLayer

- (NSString*)filePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"documentsDirectory%@",documentsDirectory);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *plistFile = [documentsDirectory stringByAppendingPathComponent:@"data.plist"];
    // 创建
    if (![fileManager fileExistsAtPath:plistFile]) {
        [fileManager createFileAtPath:plistFile contents:nil attributes:nil];
    }
    return plistFile;
}

// test Json using Gerrit REST API
- (NSString*) requestTest{
    NSError *error;
    
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://gerrit.ericsson.se/projects/?n=1"]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSString* json = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"response is %@",json);
    NSData* newResponse  = [[json substringFromIndex:5]dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *projDic = [NSJSONSerialization JSONObjectWithData:newResponse options:NSJSONReadingAllowFragments error:&error];

    NSLog(@"字典里面的内容为--》%@", projDic );
    NSLog(@"error is %@", error);

    return [[NSString alloc]initWithFormat:@"id is %@, state is %@", 1,1];

}

- (ElevatorObject*) requestBySn:(NSString*) sn{
    ElevatorObject* result = [[ElevatorObject alloc]init];
    
    return result;
}

- (NSArray*) requestAlertList{
    NSError *error;
    
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://146.11.25.2:53101/do/?GetStatus0=1"]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSMutableArray* array = [[NSMutableArray alloc]init];
    
    if (response == nil) {
        return array;
    }
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *projDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
    
    NSEnumerator* enumkey = [projDic keyEnumerator];
    
    for (NSString* ob in enumkey){
        ElevatorObject* el = [[ElevatorObject alloc]init];
        el.sn = ob.intValue;
        NSDictionary* eldic = [projDic objectForKey:ob];
        NSString* alarm = [eldic objectForKey:@"Alarm"];
        switch (alarm.intValue) {
            case 0:
                el.status = ALERTING;
                break;
            case 1:
                el.status = WARNING;
                break;
            case 2:
                el.status = NORMAL;
                break;
            default:
                break;
        }
        
        el.contactNumber = [eldic objectForKey:@"contact number"];
        el.contactPerson = [eldic objectForKey:@"contact person"];
        el.address = [eldic objectForKey:@"Location"];
        el.vendor = [eldic objectForKey:@"Ven"];
        el.model = [eldic objectForKey:@"Model"];
        NSString* longtitude = [eldic objectForKey:@"Longit"];
        el.longtitude = longtitude.doubleValue;
        NSString* latitude = [eldic objectForKey:@"Latit"];
        el.latitude = latitude.doubleValue;
        el.date = [eldic objectForKey:@"ConTime"];
        [array addObject:el];
        
    }
    
    return array;
}

- (NSArray*) requestWarningList{
    NSError *error;
    
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://146.11.25.2:53101/do/?GetStatus1=1"]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSMutableArray* array = [[NSMutableArray alloc]init];
    
    if (response == nil) {
        return array;
    }
    
    NSDictionary *projDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
    
    NSEnumerator* enumkey = [projDic keyEnumerator];
    
    for (NSString* ob in enumkey){
        ElevatorObject* el = [[ElevatorObject alloc]init];
        el.sn = ob.intValue;
        NSDictionary* eldic = [projDic objectForKey:ob];
        NSString* alarm = [eldic objectForKey:@"Alarm"];
        switch (alarm.intValue) {
            case 0:
                el.status = ALERTING;
                break;
            case 1:
                el.status = WARNING;
                break;
            case 2:
                el.status = NORMAL;
                break;
            default:
                break;
        }
        
//        el.contactNumber = [eldic objectForKey:@"contact number"];
//        el.contactPerson = [eldic objectForKey:@"contact person"];
        el.address = [eldic objectForKey:@"Location"];
        el.vendor = [eldic objectForKey:@"Ven"];
        el.model = [eldic objectForKey:@"Model"];
        NSString* longtitude = [eldic objectForKey:@"Longit"];
        el.longtitude = longtitude.doubleValue;
        NSString* latitude = [eldic objectForKey:@"Latit"];
        el.latitude = latitude.doubleValue;
        el.date = [eldic objectForKey:@"ConTime"];
        [array addObject:el];
        
    }
    
    return array;
//    return [array sortedArrayUsingComparator:^(ElevatorObject* obj1,ElevatorObject* obj2){
//        if (obj1.date < obj2.date) {
//            return NSOrderedAscending;
//        };
//        if (obj1.date > obj2.date) {
//            return NSOrderedDescending;
//        };
//        return NSOrderedSame;
//    }];
}

- (NSArray*) requestNormalList{
    NSError *error;
    
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://146.11.25.2:53101/do/?GetStatus2=1"]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    
    NSMutableArray* array = [[NSMutableArray alloc]init];
    
    if (response == nil) {
        return array;
    }
    NSDictionary *projDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
    
    NSEnumerator* enumkey = [projDic keyEnumerator];
    
    for (NSString* ob in enumkey){
        ElevatorObject* el = [[ElevatorObject alloc]init];
        el.sn = ob.intValue;
        NSDictionary* eldic = [projDic objectForKey:ob];
        NSString* alarm = [eldic objectForKey:@"Alarm"];
        switch (alarm.intValue) {
            case 0:
                el.status = ALERTING;
                break;
            case 1:
                el.status = WARNING;
                break;
            case 2:
                el.status = NORMAL;
                break;
            default:
                break;
        }
        
        el.contactNumber = [eldic objectForKey:@"contact number"];
        el.contactPerson = [eldic objectForKey:@"contact person"];
        el.address = [eldic objectForKey:@"Location"];
        el.vendor = [eldic objectForKey:@"Ven"];
        el.model = [eldic objectForKey:@"Model"];
        NSString* longtitude = [eldic objectForKey:@"Longit"];
        el.longtitude = longtitude.doubleValue;
        NSString* latitude = [eldic objectForKey:@"Latit"];
        el.latitude = latitude.doubleValue;
        el.date = [eldic objectForKey:@"ConTime"];
        [array addObject:el];
        
    }
    
    return array;
}


- (NSArray*) requestAllList{
    NSError *error;
    
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://146.11.25.2:53101/do/?GetAll=1"]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *projDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
    
    NSLog(@"字典里面的内容为--》%@", projDic );
    NSLog(@"error is %@", error);
    
    NSMutableArray* array = [[NSMutableArray alloc]init];
    
    // test用代码
//    ElevatorObject* el = [[ElevatorObject alloc]init];
//    
//    NSDictionary* eldic = projDic;
//    NSString* alarm = [eldic objectForKey:@"Alarm"];
//    switch (alarm.intValue) {
//        case 1:
//            el.status = ALERTING;
//            break;
//        case 2:
//            el.status = WARNING;
//            break;
//        case 3:
//            el.status = NORMAL;
//            break;
//        default:
//            break;
//    }
//    el.sn = 1;
//    el.vendor = [eldic objectForKey:@"Ven"];
//    el.model = [eldic objectForKey:@"Model"];
//    NSString* longtitude = [eldic objectForKey:@"Longit"];
//    el.longtitude = longtitude.doubleValue;
//    NSString* latitude = [eldic objectForKey:@"Latit"];
//    el.latitude = latitude.doubleValue;
//    el.date = [eldic objectForKey:@"ConTime"];
//    [array addObject:el];
//    array sortedArrayUsingComparator:^NSComparisonResult(ElevatorObject* obj1, ElevatorObject* obj2) {
//        return obj1.status<obj2.status;
//    }

    
    // 正式代码
    NSEnumerator* enumkey = [projDic keyEnumerator];
    
    for (NSString* ob in enumkey){
        ElevatorObject* el = [[ElevatorObject alloc]init];
        el.sn = ob.intValue;
        NSDictionary* eldic = [projDic objectForKey:ob];
        NSString* alarm = [eldic objectForKey:@"Status"];
        switch (alarm.intValue) {
            case 0:
                el.status = ALERTING;
                break;
            case 1:
                el.status = WARNING;
                break;
            case 2:
                el.status = NORMAL;
                break;
            default:
                break;
        }

        el.contactNumber = [eldic objectForKey:@"contact number"];
        el.contactPerson = [eldic objectForKey:@"contact person"];
        el.address = [eldic objectForKey:@"Location"];
        el.vendor = [eldic objectForKey:@"Ven"];
        el.model = [eldic objectForKey:@"Model"];
        NSString* longtitude = [eldic objectForKey:@"Longit"];
        el.longtitude = longtitude.doubleValue;
        NSString* latitude = [eldic objectForKey:@"Latit"];
        el.latitude = latitude.doubleValue;
        el.date = [eldic objectForKey:@"ConTime"];
        [array addObject:el];

    }
//    [array sortedArrayUsingComparator:^NSComparisonResult(ElevatorObject* obj1, ElevatorObject* obj2) {
//        return obj1.status < obj2.status;
//    }];
    
    return array;
    
}

//- (void)initData{
//    NSString* path = [self filePath];
//    
//    NSMutableData *data = [[NSMutableData alloc] init];
//    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
//    
//    NSMutableArray* array = [[NSMutableArray alloc]init];
//    
//    ElevatorObject* object1 = [[ElevatorObject alloc]init];
//    object1.sn = 1;
//    object1.status = WARNING;
//    object1.address = @" shanghai changening district";
//    object1.contactNumber = @"13666666666";
//    object1.contactPerson = @"steve";
//    
//    ElevatorObject* object2 = [[ElevatorObject alloc]init];
//    object2.sn = 2;
//    object2.status = ALERTING;
//    object2.address = @" shanghai putuo district";
//    object2.contactNumber = @"13888888888";
//    object2.contactPerson = @"jobs";
//    
//    [array addObject:object1];
//    [array addObject:object2];
//    
//    [archiver encodeObject:array forKey:@"elevatorList"];
//    [archiver finishEncoding];
//    [data writeToFile:path atomically:NO];
//}

@end

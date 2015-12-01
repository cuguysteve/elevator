//
//  DataObject.m
//  Elevator
//
//  Created by user on 15/8/26.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "DataObjectLayer.h"

NSString* allElevatorUrl = @"http://192.168.0.116:8080/do/?GetAll=1";
NSString* alertElevatorUrl = @"http://192.168.0.116:8080/do/?GetStatus0=1";
NSString* warningElevatorUrl = @"http://192.168.0.116:8080/do/?GetStatus1=1";
NSString* normalElevatorUrl = @"http://192.168.0.116:8080/do/?GetStatus2=1";
NSString* alarmListUrl = @"http://192.168.0.116:8080/do/?GetParameter=1";

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

- (ElevatorObject*) requestBySn:(NSString*) sn{
    ElevatorObject* result = [[ElevatorObject alloc]init];
    
    return result;
}

- (void) requestAlertList{
    
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:alertElevatorUrl]];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://127.0.0.1:8000/getalert/"]];
    
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *  data, NSURLResponse *  response, NSError *  error) {
        
        //    [array sortedArrayUsingComparator:^NSComparisonResult(ElevatorObject* obj1, ElevatorObject* obj2) {
        //        return obj1.status < obj2.status;
        //    }];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.generalTable updateAlert:[self decodeElevatorArrayFromData:data Response:response]];
        });
        
    }];
    [task resume];
}

- (void) requestWarningList{

    
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:warningElevatorUrl]];
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *  data, NSURLResponse *  response, NSError *  error) {
        
        //    [array sortedArrayUsingComparator:^NSComparisonResult(ElevatorObject* obj1, ElevatorObject* obj2) {
        //        return obj1.status < obj2.status;
        //    }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.generalTable updateWarning:[self decodeElevatorArrayFromData:data Response:response]];
        });
    }];
    [task resume];
}



- (void) requestNormalList{
    
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:normalElevatorUrl]];
    
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
        
        //    [array sortedArrayUsingComparator:^NSComparisonResult(ElevatorObject* obj1, ElevatorObject* obj2) {
        //        return obj1.status < obj2.status;
        //    }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.generalTable updateNormal:[self decodeElevatorArrayFromData:data Response:response]];
        });
    }];
    [task resume];
}


- (void) requestAllList{
    
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:allElevatorUrl]];
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
        
        //    [array sortedArrayUsingComparator:^NSComparisonResult(ElevatorObject* obj1, ElevatorObject* obj2) {
        //        return obj1.status < obj2.status;
        //    }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.generalTable updateAll:[self decodeElevatorArrayFromData:data Response:response]];
        });
    }];
    [task resume];
    
}


- (NSArray*) decodeElevatorArrayFromData:(NSData* )data Response:(NSURLResponse*)response{

    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSError* error = nil;
    
    NSMutableArray* array = [[NSMutableArray alloc]init];
    
    if (data == nil) {
        return array;
    }
    
    NSDictionary *projDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
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
        el.sn = ob;
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
    
    return array;
}

- (void) requestAlarmListBySn:(NSInteger) sn{
//    NSString *url = [NSString stringWithFormat:@"http:// do?BootStrap=1%ld", (long)sn];
//    NSString *url = @"http://146.11.25.2:53101/do?BootStrap=1";
//    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//    NSURLSession* session = [NSURLSession sharedSession];
//    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:alarmListUrl]];
    
//    NSURLResponse* response = [[NSURLResponse alloc]init];
//    NSError* error = nil;
//    
//    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
//    NSMutableArray* array = [[NSMutableArray alloc]init];
//    
//    NSDictionary *projDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//    NSEnumerator* it = [projDic keyEnumerator];
//    
//    for (NSString* key in it) {
//        NSDictionary* alarmdic = [projDic objectForKey:key];
//        Alarm* alarm = [[Alarm alloc]init];
//        alarm.level = [[alarmdic objectForKey:@"Alarm"] intValue];
//        alarm.date = [alarmdic objectForKey:@"Datetime"];
//        [array addObject:alarm];
//    }
//    
//    
//    [self.alarmTable updateAlarmList:array];
    
    
    NSURLSession* session = [NSURLSession sharedSession];

    
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        NSMutableArray* array = [[NSMutableArray alloc]init];
        
        NSDictionary *projDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSEnumerator* it = [projDic keyEnumerator];
        
        for (NSString* key in it) {
            NSDictionary* alarmdic = [projDic objectForKey:key];
            Alarm* alarm = [[Alarm alloc]init];
            alarm.level = [[alarmdic objectForKey:@"Alarm"] intValue];
            alarm.date = [alarmdic objectForKey:@"Datetime"];
            [array addObject:alarm];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.alarmTable updateAlarmList:array];
            
        });
        
    }];
    [task resume];
    
}

@end

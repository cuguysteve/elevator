//
//  ElevatorObject.m
//  Elevator
//
//  Created by user on 15/8/26.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "ElevatorObject.h"

@implementation ElevatorObject

- (BOOL)isEqual:(id)object{
    if ([object isKindOfClass:[self class]]) {
        ElevatorObject* comp = (ElevatorObject*)object;
        BOOL result =  (comp.sn == _sn && [comp.address isEqualToString:_address]);
        return result;
//
//        return (comp.sn == _sn && comp.status == _status
//        && comp.address == _address && comp.contactNumber == _contactNumber
//        && comp.contactPerson == _contactPerson && comp.date == _date);
    }
    return false;
}

- (NSUInteger)hash{
    return [_address hash];
}

- (id)copyWithZone:(NSZone *)zone{
    ElevatorObject* result = [[[self class] allocWithZone:zone]init];
    return result;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInt:self.sn forKey:@"SnKey"];
    [aCoder encodeInt:self.status forKey:@"StatusKey"];
    [aCoder encodeObject:self.address forKey:@"AddressKey"];
    [aCoder encodeObject:self.contactNumber forKey:@"ContactKey"];
    [aCoder encodeObject:self.contactPerson forKey:@"PersonKey"];
    [aCoder encodeObject:self.date forKey:@"Date"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        _sn = [aDecoder decodeIntForKey:@"SnKey"];
        _status = [aDecoder decodeIntForKey:@"StatusKey"];
        _address = [aDecoder decodeObjectForKey:@"AddressKey"];
        _contactNumber = [aDecoder decodeObjectForKey:@"ContactKey"];
        _contactPerson = [aDecoder decodeObjectForKey:@"PersonKey"];
        _date = [aDecoder decodeObjectForKey:@"Date"];
    }
    return self;
}// NS_DESIGNATED_INITIALIZER

@end

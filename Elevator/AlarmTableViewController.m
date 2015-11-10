//
//  AlarmTableViewController.m
//  Elevator
//
//  Created by user on 15/11/10.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "AlarmTableViewController.h"
#import "DataObjectLayer.h"

@interface AlarmTableViewController (){
    DataObjectLayer* _ol;
}

@end

@implementation AlarmTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _ol = [[DataObjectLayer alloc]init];
    _ol.alarmTable = self;
    [_ol requestAlarmListBySn:self.sn];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) updateAlarmList:(NSArray*)array{
    self.alarmList = array;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.alarmList.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"alarmIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"alarmIdentifier"];
    }
    Alarm* alarm = self.alarmList[indexPath.row];
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"Alarm level: %d",  alarm.level];
    cell.detailTextLabel.text = [[NSString alloc]initWithFormat:@" Alarm time: %@",alarm.date ];
    NSNumber* fontSize = @12;
    cell.textLabel.font = [cell.textLabel.font fontWithSize:fontSize.floatValue];
    
    return cell;
}
@end

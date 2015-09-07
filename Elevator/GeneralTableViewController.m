//
//  GeneralTableViewController.m
//  Elevator
//
//  Created by user on 15/8/26.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "GeneralTableViewController.h"
#import "DetailTableViewController.h"
#import "DataObjectLayer.h"

@interface GeneralTableViewController ()

@property NSArray* elevatorList;
@property DataObjectLayer* ol;
@property NSTimer* timer;
- (void)timerFired;

@end

@implementation GeneralTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ol = [[DataObjectLayer alloc]init];
//    [self.ol initData];
    self.elevatorList = [self.ol requestAllList];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    if(self.timer){
        NSLog(@"timer is created");
    }
}

- (void)timerFired{
    NSLog(@" timerFired");
    self.elevatorList = [self.ol requestAllList];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.elevatorList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"reuseIdentifier"];
    }
    
    ElevatorObject* elevator = self.elevatorList[indexPath.row];
    
    if (elevator.status == 0) {
        cell.imageView.image = [UIImage imageNamed:@"alert"];

    }else if (elevator.status ==1){
        cell.imageView.image = [UIImage imageNamed:@"warning"];
    }else if (elevator.status ==2){
        cell.imageView.image = [UIImage imageNamed:@"normal"];

    }
    
    cell.textLabel.text = elevator.address;
    cell.detailTextLabel.text = [[NSString alloc]initWithFormat:@" Call %@ via %@",elevator.contactPerson,elevator.contactNumber ];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSNumber* fontSize = @12;
    cell.textLabel.font = [cell.textLabel.font fontWithSize:fontSize.floatValue];
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailTableViewController* de = [[DetailTableViewController alloc] init];
    ElevatorObject* ob = self.elevatorList[indexPath.row];
    de.sn = ob.sn;
    [[self navigationController]pushViewController:de animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

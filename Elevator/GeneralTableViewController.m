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
#import "MapViewController.h"

@interface GeneralTableViewController (){
    DetailTableViewController* details;
    MapViewController* map;
    
}
- (IBAction)presentInMap:(id)sender;


@property DataObjectLayer* ol;
@property NSTimer* timer;
- (void)timerFired;

@end

@implementation GeneralTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ol = [[DataObjectLayer alloc]init];
//    [self.ol initData];
    self.normalList = [self.ol requestNormalList];
    self.warningList = [self.ol requestWarningList];
    self.alertList = [self.ol requestAlertList];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    if(self.timer){
        NSLog(@"timer is created");
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([segue.identifier isEqualToString:@"DetailsSegue"])
    {
        NSLog(@"go to details view");
        details = (DetailTableViewController *)segue.destinationViewController;
    }
    else if ([segue.identifier isEqualToString:@"presentInMap"]){
        NSLog(@"go to map view");
        map = (MapViewController *)segue.destinationViewController;
        map.generalTable = self;
    }
}

- (void)timerFired{
    NSLog(@"timerFired");
    NSArray* newAlertList = [self.ol requestAlertList];
    bool showAlert = false;
    NSMutableString* message = [[NSMutableString alloc]init];

    
    for(ElevatorObject* ob in [newAlertList objectEnumerator]){
        if ([self.alertList containsObject:ob]) {
            continue;
        }
        showAlert = true;
        [message appendFormat:@"Alert: %@ \n",ob.address];
    }

// Using Local Notification when app is in background mode
//        UILocalNotification* not = [[UILocalNotification alloc]init];
//        if (not) {
//            [[UIApplication sharedApplication] cancelAllLocalNotifications];
//            not.alertBody = [[NSString alloc]initWithFormat:@"new alert: %@",ob.address];
//            not.alertAction = NSLocalizedString(@"Please check", nil);
//            not.soundName = UILocalNotificationDefaultSoundName;
//            not.applicationIconBadgeNumber++;
//        }
//        [[UIApplication sharedApplication]presentLocalNotificationNow:not];
        
        
    if (showAlert) {
        UIAlertView* alert  = [[UIAlertView alloc]initWithTitle:@"new alert" message:message delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alert show];
    }

    
    self.alertList = newAlertList;
    self.warningList = [self.ol requestWarningList];
    self.normalList = [self.ol requestNormalList];
    [self.tableView reloadData];
    map.refreshAnnotations;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return [self.alertList count];
    }else if(section ==1){
        return [self.warningList count];
    }else{
        return [self.normalList count];
    }
    return 0;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"Alert List";
    }else if(section ==1){
        return @"Warning List";
    }else{
        return @"Normal List";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"reuseIdentifier"];
    }
    ElevatorObject* elevator = nil;
    if (indexPath.section == 0) {
            elevator = self.alertList[indexPath.row];
            cell.imageView.image = [UIImage imageNamed:@"alert"];

    }else if(indexPath.section == 1){
            elevator = self.warningList[indexPath.row];
            cell.imageView.image = [UIImage imageNamed:@"warning"];
    }else{
//        if ([self.normalList count]==0) {
//            cell.textLabel.text = @"None";
//            cell.imageView.image = nil;
//            cell.detailTextLabel.text = nil;
//            return  cell;
//        }else{
            elevator = self.normalList[indexPath.row];
            cell.imageView.image = [UIImage imageNamed:@"normal"];
//        }
    }
    
    // Configure the cell...
    cell.textLabel.text = elevator.address;
    cell.detailTextLabel.text = [[NSString alloc]initWithFormat:@" Status change time: %@",elevator.date ];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSNumber* fontSize = @12;
    cell.textLabel.font = [cell.textLabel.font fontWithSize:fontSize.floatValue];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"DetailsSegue" sender:nil];
    
    ElevatorObject* ob = nil;
    if (indexPath.section == 0) {
        ob = self.alertList[indexPath.row];
    }else if(indexPath.section ==1){
        ob = self.warningList[indexPath.row];
    }else{
        ob = self.normalList[indexPath.row];
    }
    if (ob == nil) {
        return;
    }
    
    details.elevator = ob;
    
//    [[self navigationController]pushViewController:de animated:YES];
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

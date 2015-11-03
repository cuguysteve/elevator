//
//  DetailTableViewController.m
//  Elevator
//
//  Created by user on 15/8/28.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "DetailTableViewController.h"


@interface DetailTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *manufactor;
@property (weak, nonatomic) IBOutlet UILabel *sn;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *contactPerson;
@property (weak, nonatomic) IBOutlet UIButton *switchButton;
@property (weak, nonatomic) IBOutlet UILabel *contactNumber;
- (IBAction)callContact:(id)sender;
- (IBAction)stopElevator:(id)sender;

@end

@implementation DetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _address.text = _elevator.address;
    _manufactor.text = @"";
    _sn.text = [NSString stringWithFormat:@"%d",_elevator.sn];
    switch (_elevator.status) {
        case 0:
             _status.text = @"Alarm";
            break;
        case 1:
            _status.text = @"Warning";
            break;
        case 2:
            _status.text = @"Normal";
            break;
        default:
            break;
    }
    _date.text = _elevator.date;
    _contactNumber.text = _elevator.contactNumber;
    _contactPerson.text = _elevator.contactPerson;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)callContact:(id)sender{
    NSString* tel = [NSString stringWithFormat:@"tel://%@", self.elevator.contactNumber ];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
    NSURL* telURL = [NSURL URLWithString:tel];
    UIWebView *mCallWebview = [[UIWebView alloc] init] ;
    [self.view addSubview:mCallWebview];
    [mCallWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
}

- (IBAction)stopElevator:(id)sender {
    
    if ([_switchButton.titleLabel.text  isEqual: @"Stop Elevator"]) {
        NSError *error;
        
        //加载一个NSURL对象
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://146.11.25.2:53101/do/?GetAll=1"]];
        //将请求的url数据放到NSData对象中
        NSHTTPURLResponse* resp = [[NSHTTPURLResponse alloc]init];
        
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:nil];
        
        
        _status.text = @"Stopped";
        dispatch_async(dispatch_get_main_queue(), ^{
            _switchButton.titleLabel.text = @"Start Elevator";
            [_switchButton.titleLabel setNeedsDisplay];
        });

    }else{

        _status.text = @"Normal";

        dispatch_async(dispatch_get_main_queue(), ^{
            _switchButton.titleLabel.text = @"Stop Elevator";
            [_switchButton.titleLabel setNeedsDisplay];
        });
        
    }
    
    
    
}

#pragma mark - Table view data source

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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

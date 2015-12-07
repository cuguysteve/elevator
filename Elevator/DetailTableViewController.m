//
//  DetailTableViewController.m
//  Elevator
//
//  Created by user on 15/8/28.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "DetailTableViewController.h"
#import "AlarmTableViewController.h"
#import "GeneralTableViewController.h"


NSString* stopElevatorUrl = @"http://192.168.0.116:8080/do/?Contrl={%22SN%22:%22SN370032783%22,%22Action%22:%22STOP%22}";
NSString* startElevatorUrl = @"http://192.168.0.116:8080/do/?Contrl={%22SN%22:%22SN370032783%22,%22Action%22:%22RUN,3,2%22}";

@interface DetailTableViewController (){
    AlarmTableViewController* alarmTable;
}
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *manufactor;
@property (weak, nonatomic) IBOutlet UILabel *sn;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *contactPerson;

- (IBAction)valueChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *contactNumber;
- (IBAction)callContact:(id)sender;

@end

@implementation DetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _address.text = _elevator.address;
    _manufactor.text = @"";
    _sn.text = _elevator.sn;
    switch (_elevator.status) {
        case 2:
             _status.text = @"Alarm";
            break;
        case 1:
            _status.text = @"Warning";
            break;
        case 0:
            _status.text = @"Normal";
            break;
        default:
            break;
    }
    _date.text = _elevator.date;
    _contactNumber.text = _elevator.contactNumber;
    _contactPerson.text = _elevator.contactPerson;
    _contactNumber.text = @"13564244632";
    _contactPerson.text = @"Steve";

    
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

- (IBAction)valueChanged:(id)sender {
    UISwitch* sw = (UISwitch*)sender;
    if(sw.isOn){
        switch (_elevator.status) {
            case 2:
                _status.text = @"Alarm";
                break;
            case 1:
                _status.text = @"Warning";
                break;
            case 0:
                _status.text = @"Normal";
                break;
            default:
                break;
        }
    }else{
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:stopElevatorUrl]];
        NSURLSession* session = [NSURLSession sharedSession];
        NSURLSessionDataTask* task =  [session dataTaskWithRequest:request];
        [task resume];
        _status.text = @"Stopped";
    }
}

- (IBAction)alarmHistory:(id)sender {
    [self performSegueWithIdentifier:@"alarmDetails" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"alarmDetails"])
    {
        NSLog(@"go to details view");
        alarmTable = ( AlarmTableViewController*)segue.destinationViewController;
        alarmTable.sn = self.elevator.sn;
    }

}

@end

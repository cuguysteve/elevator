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

- (IBAction)valueChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *contactNumber;
- (IBAction)callContact:(id)sender;

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

- (IBAction)valueChanged:(id)sender {
    UISwitch* sw = (UISwitch*)sender;
    if(sw.isOn){
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
    }else{
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://stopelevatorurl"]];
        NSURLSession* session = [NSURLSession sharedSession];
        NSURLSessionDataTask* task =  [session dataTaskWithRequest:request];
        [task resume];
        _status.text = @"Stopped";
    }
}
@end

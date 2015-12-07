//
//  MapViewController.m
//  Elevator
//
//  Created by 王小猴 on 15/9/22.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MKMapView.h>
#import "ElevatorAnnotation.h"
#import "ElevatorObject.h"
#import "DetailTableViewController.h"


@interface MapViewController ()<CLLocationManagerDelegate>{
    CLGeocoder *_geocoder;
    CLLocationManager *_locationManager;
    CLLocation *_location;
    MKMapView *_mapView;
    NSMutableArray* annotations;
    ElevatorAnnotation* _pointAnno;
}
@property (weak, nonatomic) IBOutlet UIButton *zoomIn;
@property (weak, nonatomic) IBOutlet UIButton *zoomOut;

- (IBAction)zoomInMap:(id)sender;
- (IBAction)zoomOutMap:(id)sender;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    [self initGui];
    
    NSLog(@"viewDidLoad exit");
}

- (void)initGui{
    CGRect rect=[UIScreen mainScreen].bounds;
    _mapView=[[MKMapView alloc]initWithFrame:rect];
    [self.view addSubview:_mapView];
    
    self.zoomIn.layer.borderWidth = 1;
    self.zoomOut.layer.borderWidth = 1;
    
    [self.view bringSubviewToFront:self.zoomIn];
    [self.view bringSubviewToFront:self.zoomOut];
    //设置代理
    _mapView.delegate=self;
    //请求定位服务
    _locationManager=[[CLLocationManager alloc]init];
    if(![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse){
        [_locationManager requestWhenInUseAuthorization];
    }
    [_locationManager startUpdatingLocation];
    //用户位置追踪(用户位置追踪用于标记用户当前位置，此时会调用定位服务)
    _mapView.userTrackingMode=MKUserTrackingModeFollow;
    
    //设置地图类型
    _mapView.mapType=MKMapTypeStandard;
    
    _geocoder = [[CLGeocoder alloc]init];

//    [self getCoordinateByAddress:@"上海市天山西路1068号A栋"];
    
//    [self getCoordinateByAddress:@"No. 1068 Tianshan West Road , shanghai , china"];
    
    
    annotations = [[NSMutableArray alloc]init];
    
    [self refreshAnnotations];
}

- (void) refreshAnnotations{
    [_mapView removeAnnotations:annotations];
    
    for(ElevatorObject* tmp  in self.generalTable.allList){
        bool exist = false;
        for (ElevatorAnnotation* temp in annotations) {
            if(temp.elevator == tmp){
                exist = true;
            }
        }
        if (exist) {
            break;
        }
        ElevatorAnnotation* ann = [[ElevatorAnnotation alloc]init];
        
        ann.coordinate = (CLLocationCoordinate2D){tmp.latitude-0.006,tmp.longtitude-0.0065};
        ann.title = tmp.address;
        ann.subtitle = tmp.contactNumber;
        switch (tmp.status) {
            case ALERTING:
                
                ann.image = [UIImage imageNamed:@"redann"];
                break;
            case WARNING:
                
                ann.image = [UIImage imageNamed:@"yellowann"];
                break;
            case NORMAL:
                
                ann.image = [UIImage imageNamed:@"greenann"];
                break;
            default:
                break;
        }
        ann.elevator = tmp;

        [annotations addObject:ann];
        [_mapView addAnnotation: ann];
        
//        CLGeocoder* _geocoder2 = [[CLGeocoder alloc]init];
//        
//        [_geocoder2 geocodeAddressString:tmp.address completionHandler:^(NSArray *placemarks, NSError *error) {
//            //取得第一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
//            if ([placemarks count] == 0) {
//                NSLog(@"Cannot find the address for annotation");
//                return;
//            }
//            CLPlacemark *placemark=[placemarks firstObject];
//            
//            CLRegion *region=placemark.region;//区域
//            NSDictionary *addressDic= placemark.addressDictionary;//详细地址信息字典,包含以下部分信息
//            NSLog(@"位置:%@,区域:%@,详细信息:%@",_location,region,addressDic);
//            
//            ElevatorAnnotation* ann = [[ElevatorAnnotation alloc]init];
//            ann.coordinate = placemark.location.coordinate;
//            ann.title = tmp.address;
//            ann.subtitle = tmp.contactNumber;
//            ann.image = [UIImage imageNamed:@"redann"];
//            [annotations addObject:ann];
//            [_mapView addAnnotation: ann];
//            
//        }];
    }
}
//
//-(void)addAnnotation{
//    CLLocationCoordinate2D location1=CLLocationCoordinate2DMake(39.95, 116.35);
//    ElevatorAnnotation *annotation1=[[ElevatorAnnotation alloc]init];
//    annotation1.title=@"CMJ Studio";
//    annotation1.subtitle=@"Kenshin Cui's Studios";
//    annotation1.coordinate=location1;
//    [_mapView addAnnotation:annotation1];
//    
//    CLLocationCoordinate2D location2=CLLocationCoordinate2DMake(39.87, 116.35);
//    ElevatorAnnotation *annotation2=[[ElevatorAnnotation alloc]init];
//    annotation2.title=@"Kenshin&Kaoru";
//    annotation2.subtitle=@"Kenshin Cui's Home";
//    annotation2.coordinate=location2;
//    [_mapView addAnnotation:annotation2];
//}


-(void)getCoordinateByAddress:(NSString *)address{
    //地理编码
    [_geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        //取得第一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
        if ([placemarks count] == 0) {
            NSLog(@"Cannot find the address");
            return;
        }
        CLPlacemark *placemark=[placemarks firstObject];
        
        _location=placemark.location;//位置
        CLRegion *region=placemark.region;//区域
        NSDictionary *addressDic= placemark.addressDictionary;//详细地址信息字典,包含以下部分信息
        NSLog(@"位置:%@,区域:%@,详细信息:%@",_location,region,addressDic);
//        [_mapView setCenterCoordinate:_location.coordinate];
        [_mapView setRegion:MKCoordinateRegionMakeWithDistance(_location.coordinate, 750, 750) animated:true];
    }];
}

-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    //反地理编码
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        NSLog(@"详细信息:%@",placemark.addressDictionary);
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)zoomInMap:(id)sender {
    
    [_mapView setRegion:MKCoordinateRegionMake(_mapView.region.center,MKCoordinateSpanMake(_mapView.region.span.longitudeDelta/2,_mapView.region.span.longitudeDelta/2)) animated:true];
}

- (IBAction)zoomOutMap:(id)sender {
    
    [_mapView setRegion:MKCoordinateRegionMake(_mapView.region.center,MKCoordinateSpanMake(_mapView.region.span.longitudeDelta*2,_mapView.region.span.longitudeDelta*2)) animated:true];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location=[locations firstObject];
    //取出第一个位置
    CLLocationCoordinate2D coordinate=location.coordinate;
    //位置坐标
    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
//    [_mapView setCenterCoordinate:coordinate];
    [_mapView setRegion:MKCoordinateRegionMakeWithDistance(coordinate, 750, 750) animated:true];
    
    //如果不需要实时定位，使用完即使关闭定位服务
    [_locationManager stopUpdatingLocation];
}

#pragma mark - 地图控件代理方法
#pragma mark 显示大头针时调用，注意方法中的annotation参数是即将显示的大头针对象
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    //由于当前位置的标注也是一个大头针，所以此时需要判断，此代理方法返回nil使用默认大头针视图
    if ([annotation isKindOfClass:[ElevatorAnnotation class]]) {
        static NSString *key1=@"AnnotationKey1";
        MKAnnotationView *annotationView=[_mapView dequeueReusableAnnotationViewWithIdentifier:key1];
        //如果缓存池中不存在则新建
        if (!annotationView) {
            annotationView=[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:key1];
            
            
            
            // add a detail disclosure button to the callout which will open a new view controller page or a popover
            
            //
            
            // note: when the detail disclosure button is tapped, we respond to it via:
            
            //       calloutAccessoryControlTapped delegate method
            
            //
            
            // by using "calloutAccessoryControlTapped", it's a convenient way to find out which annotation was tapped
            
            //
            _pointAnno = annotation;
            
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            
            [rightButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            annotationView.rightCalloutAccessoryView = rightButton;
            annotationView.canShowCallout=true;//允许交互点击
            annotationView.calloutOffset=CGPointMake(0, 1);//定义详情视图偏移量
            annotationView.leftCalloutAccessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_classify_cafe.png"]];//定义详情左侧视图
        }
        
        //修改大头针视图
        //重新设置此类大头针视图的大头针模型(因为有可能是从缓存池中取出来的，位置是放到缓存池时的位置)
        annotationView.annotation=annotation;
        annotationView.image=((ElevatorAnnotation *)annotation).image;//设置大头针视图的图片
        
        return annotationView;
    }else {
        return nil;
    }
}

//#pragma mark 选中大头针时触发
////点击一般的大头针KCAnnotation时添加一个大头针作为所点大头针的弹出详情视图
//-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
//
//    [self performSegueWithIdentifier:@"DetailsSegue" sender:nil];
//
//}
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    
//    if ([segue.identifier isEqualToString:@"DetailsSegue"])
//    {
//        NSLog(@"go to details view");
//        details = (DetailTableViewController *)segue.destinationViewController;
//    }
//
//}
- (void)buttonAction:(id)sender

{
    
    DetailTableViewController *detailViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"detailTableView"];
    
    detailViewController.edgesForExtendedLayout = UIRectEdgeNone;
    
    detailViewController.modalPresentationStyle = UIModalPresentationPopover;
    detailViewController.elevator = _pointAnno.elevator;
    
    UIPopoverPresentationController *presentationController = detailViewController.popoverPresentationController;
    
    
    
    // display popover from the UIButton (sender) as the anchor
    
    presentationController.sourceRect = [sender frame];
    
    UIButton *button = (UIButton *)sender;
    
    presentationController.sourceView = button.superview;
    
    
    
    presentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    
    
    
    // not required, but useful for presenting "contentVC" in a compact screen so that it
    
    // can be dismissed as a full screen view controller)
    
    //
//    
//    presentationController.delegate = self;
    
    [[self navigationController]pushViewController:detailViewController animated:YES];
    
//    [self presentViewController:detailViewController animated:YES completion:^{
//        
//        //.. done
//        
//    }];
    
}



@end

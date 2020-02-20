//
//  SystemMapController.m
//  BaseProject
//
//  Created by ZSXJ on 2017/6/22.
//  Copyright © 2017年 WYJ. All rights reserved.
//

// 系统的地图
#import "SystemMapController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "CustomPinAnnotationView.h"
#import "MyAnnotation.h"

#import "SystemMapAnnotationManager.h"


@interface SystemMapController ()<MKMapViewDelegate>
{
    CLLocationManager *_locationManager;
    MKMapView *_mapView;
}
@property (nonatomic,retain) NSMutableArray *locationArray;
@end

@implementation SystemMapController


- (void)didReceiveMemoryWarning {
    
    switch (_mapView.mapType) {
        case MKMapTypeHybrid:
        {
            _mapView.mapType = MKMapTypeStandard;
        }
            
            break;
        case MKMapTypeStandard:
        {
            _mapView.mapType = MKMapTypeHybrid;
        }
            
            break;
        default:
            break;
    }
    _mapView.mapType = MKMapTypeStandard;
    _mapView.showsUserLocation = NO;
    [_mapView.layer removeAllAnimations];
    [_mapView removeAnnotations:_mapView.annotations];
    [_mapView removeOverlays:_mapView.overlays];
    [_mapView removeFromSuperview];
    _mapView.delegate = nil;
    _mapView = nil;
    
    [super didReceiveMemoryWarning];
}
- (void)dealloc {
    switch (_mapView.mapType) {
        case MKMapTypeHybrid:
        {
            _mapView.mapType = MKMapTypeStandard;
        }
            
            break;
        case MKMapTypeStandard:
        {
            _mapView.mapType = MKMapTypeHybrid;
        }
            
            break;
        default:
            break;
    }
    _mapView.mapType = MKMapTypeStandard;
    _mapView.showsUserLocation = NO;
    [_mapView.layer removeAllAnimations];
    [_mapView removeAnnotations:_mapView.annotations];
    [_mapView removeOverlays:_mapView.overlays];
    [_mapView removeFromSuperview];
    _mapView.delegate = nil;
    _mapView = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    地图视图
    [self mapViewInit];
    
    
    // 定位授权
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.distanceFilter = 200;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager stopUpdatingLocation];
}



- (void)mapViewInit {
    CGFloat SW = [UIScreen mainScreen].bounds.size.width;
    CGFloat SH = [UIScreen mainScreen].bounds.size.height;
    _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(40, 70, SW - 80, SH - 160)];

    //指南针
    _mapView.showsCompass = YES;
    //比例尺
    _mapView.showsPointsOfInterest = YES;
    
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    _mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    
    [self.view addSubview:_mapView];
    
    // class UIImageView
    UIView *view1 = [_mapView.subviews objectAtIndex:1];
    view1.alpha = 0;
    
    // class MKAttributionLabel
    UIView *view2 = [_mapView.subviews objectAtIndex:2];
    view2.alpha = 0;
    
    
    NSLog(@"%@",[view1 class]);
    NSLog(@"%@",[view2 class]);
    
//    
//    //设置追踪定位模式
//    [self.mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
//    
//    //设定定位的最小更新距离 （默认为kCLDistanceFilterNone，会提示任何移动）
//    self.mapView.distanceFilter = 100;
//    
//    //显示用户位置
//    self.mapView.showsUserLocation = YES;
//    
//    //设置缩放级别
//    [self.mapView setZoomLevel:14 animated:YES];

}

- (void)loadData{
    
    self.locationArray = [SystemMapAnnotationManager getAnnotationArray];
    
    //    核心代码
    [_mapView addAnnotations:self.locationArray];
    
}

#pragma mark ------ delegate

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [_mapView removeFromSuperview];
    [self.view addSubview:_mapView];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    userLocation.title  =@"你好";
    
    _mapView.centerCoordinate = userLocation.coordinate;
    
    [_mapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.3, 0.3)) animated:YES];
    
    [_locationManager stopUpdatingLocation];
    _mapView.showsUserLocation = NO;
    //    如果在ViewDidLoad中调用  添加大头针的话会没有掉落效果  定位结束后再添加大头针才会有掉落效果
    [self loadData];
    
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    return [SystemMapAnnotationManager mapView:mapView viewForAnnotation:annotation];
}


- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views{
    
    //    获得mapView的Frame
    CGRect visibleRect = [mapView annotationVisibleRect];
    
    for (MKAnnotationView *view in views) {
        
        CGRect endFrame = view.frame;
        CGRect startFrame = endFrame;
        startFrame.origin.y = visibleRect.origin.y - startFrame.size.height;
        view.frame = startFrame;
        [UIView beginAnimations:@"drop" context:NULL];
        [UIView setAnimationDuration:1];
        view.frame = endFrame;
        [UIView commitAnimations];
        
        
    }
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSLog(@"点击了查看详情");
}
@end

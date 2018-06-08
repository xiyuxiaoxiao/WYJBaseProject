//
//  MapController.m
//  OmniChannelClient
//
//  Created by ZSXJ on 2017/6/23.
//  Copyright © 2017年 ZSXJ. All rights reserved.
//

#import "MapController.h"
#import "MapData.h"
#import "CustomMAPointAnnotation.h"
@interface MapController ()<MAMapViewDelegate,AMapSearchDelegate,AMapLocationManagerDelegate>

@property (nonatomic, strong)   MAMapView *mapView;
@property (nonatomic, strong)   AMapLocationManager *locationManager;
@property (nonatomic, strong)   CLLocation *currentLocation;
@end

@implementation MapController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    self.mapView = [MapData mapViewWithFrame:CGRectMake(0, 0, w, h)];
    self.mapView.delegate = self;
    
    [self.view addSubview:self.mapView];
    self.locationManager            = [MapData mapLocationManager];
    self.locationManager.delegate   = self;
    
    [self.locationManager startUpdatingLocation];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)addAnnomation {
    [self.mapView addAnnotations:[MapData getAnnotationArray]];
}

#pragma mark - Map delagete
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
    
    self.currentLocation = location;
    NSLog(@"地理位置：%@",location);
    
    [self.locationManager stopUpdatingLocation];
    self.mapView.centerCoordinate = location.coordinate;
    
    
    [self addAnnomation];
}

#pragma mark 返回大头针View
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    
    return [MapData mapView:mapView viewForAnnotation:annotation];
}

-(void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    
}

@end

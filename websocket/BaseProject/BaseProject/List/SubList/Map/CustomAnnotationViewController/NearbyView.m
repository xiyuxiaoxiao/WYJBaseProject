//
//  NearbyView.m
//  BigMedicineBottle
//
//  Created by lanou3g on 15/6/23.
//  Copyright (c) 2015年 wyj. All rights reserved.
//

#import "NearbyView.h"

#define buttonSpace 20 //间距
#define buttonWH 30
#define buttonXofFirst ([UIScreen mainScreen].bounds.size.width - (buttonWH + buttonSpace) * 4)
#define buttonY ([UIScreen mainScreen].bounds.size.height - 150)

@implementation NearbyView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addAllView];
    }
    return self;
}

-(void)addAllView
{
    [self initMapView];
    [self creatMapButton];
}

-(void)initMapView
{
    [AMapServices sharedServices].apiKey = APIKey;
    
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
//    self.mapView.delegate = self;
    [self addSubview:self.mapView];
    
    //指南针
    self.mapView.compassOrigin = CGPointMake(self.mapView.compassOrigin.x, 22);
    //比例尺
    self.mapView.scaleOrigin = CGPointMake(self.mapView.scaleOrigin.x, 22);
    
    
    //设置追踪定位模式
    [self.mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    
    //设定定位的最小更新距离 （默认为kCLDistanceFilterNone，会提示任何移动）
    self.mapView.distanceFilter = 100;
    
    //显示用户位置
    self.mapView.showsUserLocation = YES;
    
    //设置缩放级别
    [self.mapView setZoomLevel:14 animated:YES];

    
}

-(void)creatMapButton
{
    //我的位置
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(buttonXofFirst, buttonY, buttonWH, buttonWH);
    [button setBackgroundImage:[UIImage imageNamed:@"btn_map_locate.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(mapLocationButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.mapView addSubview:button];
    
    //查看所有信息
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    searchButton.frame = CGRectMake(CGRectGetMaxX(button.frame) + buttonSpace, buttonY, buttonWH, buttonWH);
    [searchButton setBackgroundImage:[UIImage imageNamed:@"iconfont-list.png"] forState:UIControlStateNormal];
    [self.mapView addSubview:searchButton];
    
    self.myLocationButton = button;
    self.searchButton = searchButton;
    
    
    //------放大按钮
    UIButton *zoomInButton = [UIButton buttonWithType:UIButtonTypeSystem];
    zoomInButton.frame = CGRectMake(CGRectGetMaxX(searchButton.frame) + buttonSpace, buttonY, buttonWH, buttonWH);
    [zoomInButton setBackgroundImage:[UIImage imageNamed:@"iconfont-fangda.png"] forState:UIControlStateNormal];
    [zoomInButton addTarget:self action:@selector(zoomIn:) forControlEvents:(UIControlEventTouchUpInside)];
  
    //-----缩小按钮
    UIButton *zoomOutButton = [UIButton buttonWithType:UIButtonTypeSystem];
    zoomOutButton.frame = CGRectMake(CGRectGetMaxX(zoomInButton.frame) + buttonSpace, buttonY, buttonWH, buttonWH);
    [zoomOutButton setBackgroundImage:[UIImage imageNamed:@"iconfont-suoxiao.png"] forState:UIControlStateNormal];
    [zoomOutButton addTarget:self action:@selector(zoomOut:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.mapView addSubview:zoomInButton];
    [self.mapView addSubview:zoomOutButton];
}

#pragma mark 回到中心
-(void)mapLocationButtonAction:(UIButton *)sender
{
    //地图
    if (self.mapView.userTrackingMode != MAUserTrackingModeFollow) {
        [self.mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    }
}

-(void)zoomIn:(UIButton *)sender
{
    self.mapView.zoomLevel = (self.mapView.zoomLevel + 1) < 19 ? (self.mapView.zoomLevel + 1) : 19;
}
-(void)zoomOut:(UIButton *)sender
{
    self.mapView.zoomLevel = (self.mapView.zoomLevel - 1) > 3 ? (self.mapView.zoomLevel - 1) : 3;
}
@end

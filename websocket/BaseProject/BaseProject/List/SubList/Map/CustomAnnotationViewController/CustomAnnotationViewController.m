//
//  CustomAnnotationViewController.m
//  BaseProject
//
//  Created by ZSXJ on 2017/6/20.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "CustomAnnotationViewController.h"
#import "NearbyView.h"

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import <AMapLocationKit/AMapLocationKit.h>

#import "CustomAnnotationView.h"
#import "CustomMAPointAnnotation.h"

@interface CustomAnnotationViewController ()<MAMapViewDelegate,AMapSearchDelegate,AMapLocationManagerDelegate>

@property(strong,nonatomic)NearbyView *rootView;
@property(strong,nonatomic)AMapSearchAPI *search;

@property(strong,nonatomic)CLLocation *currentLocation;
@property(strong,nonatomic)CLLocation *endLocation;
@property(strong,nonatomic)NSArray *polyLines;


@property(strong,nonatomic)AMapLocationManager *locationManager;

@end

@implementation CustomAnnotationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rootView = [[NearbyView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.rootView.mapView.delegate = self;
    self.view = self.rootView;
    
    
    //初始化searh
    self.search             = [[AMapSearchAPI alloc] init];
    self.search.delegate    = self;
    
    
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate           = self;
    self.locationManager.distanceFilter     = 200;
    [self.locationManager startUpdatingLocation];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self addAnnotation];
}

- (void)addAnnotation {
    NSMutableArray *annotationArray = [self.class getAnnotationArray];
    
    int i = 0;
    for (MAPointAnnotation *annotation in annotationArray) {
//        [self.rootView.mapView addAnnotation:annotation];
        [self.rootView.mapView performSelector:@selector(addAnnotation:) withObject:annotation afterDelay:0.15*i];
        i++;
    }
    
    // 设置第一个点为中心点
    CustomMAPointAnnotation *annotation     = annotationArray[0];
    self.rootView.mapView.centerCoordinate  = annotation.coordinate;
}

#pragma mark 地图回调

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    self.currentLocation = location;
    NSLog(@"地理位置：%@",location);
    
    //暂停更新，如果后面有点击事件更新位置 需要判断是否打开
    //    self.mapView.showsUserLocation = NO;
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
}


#pragma mark 返回大头针View
-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[CustomMAPointAnnotation class]]) {
        //重用机制
        static NSString *resultIdefine = @"CustomAnnotationView";
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:resultIdefine];
        
        if (annotationView == nil) {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:resultIdefine];
            
            //弹出一个气泡 禁止后才会调用自定义的 
            annotationView.canShowCallout   = NO;
            annotationView.draggable        = YES;
            annotationView.calloutOffset    = CGPointMake(0, -5);
            
        }
        // 一开始就显示气泡
        annotationView.selected = YES;
        
        CustomMAPointAnnotation *customAnnotation = (CustomMAPointAnnotation *)annotation;
        annotationView.orderInfo = customAnnotation.otherInfo;
        
        
        // 动画效果
        CGRect endFrame = annotationView.frame;

        annotationView.frame = CGRectMake(endFrame.origin.x, endFrame.origin.y - 500.0, endFrame.size.width, endFrame.size.height);
        
        [UIView beginAnimations:@"drop" context:NULL];
        [UIView setAnimationDuration:0.45];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        [annotationView setFrame:endFrame];
        
        [UIView commitAnimations];
        
        return annotationView;
    }
    return nil;
}

#pragma mark 大头针点击

-(void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    MAPointAnnotation *annomation = view.annotation;
    
    //点击发起路径规划请求
    
    AMapWalkingRouteSearchRequest *navi = [[AMapWalkingRouteSearchRequest alloc] init];
    
    
    //    AMapNavigationSearchRequest *request = [[AMapNavigationSearchRequest alloc] init];
    //    //规划类型：步行
    //    request.searchType = AMapSearchType_NaviWalking;
    navi.origin = [AMapGeoPoint locationWithLatitude:self.currentLocation.coordinate.latitude longitude:self.currentLocation.coordinate.longitude];
    
    navi.destination = [AMapGeoPoint locationWithLatitude:annomation.coordinate.latitude longitude:annomation.coordinate.longitude];
    
    self.endLocation = [[CLLocation alloc] initWithLatitude:annomation.coordinate.latitude longitude:annomation.coordinate.longitude];
    
    //发起路径搜索请求
    [self.search AMapWalkingRouteSearch:navi];
}

#pragma mark 路径规划回调

- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response {
    
    if (response.route == nil) {
        return;
    }
    //通过AMapNavigationSearchResponse对象处理搜索结果
    [self.rootView.mapView removeOverlays:self.polyLines];
    self.polyLines = nil;
    
    //只显示一条路径
    self.polyLines = [self polyLinesForPath:response.route.paths[0]];
    
    [self.rootView.mapView addOverlays:self.polyLines];
    
    [self.rootView.mapView showAnnotations:@[self.endLocation,self.rootView.mapView.userLocation] animated:YES];
}


//获得polyline数组
-(NSArray *)polyLinesForPath:(AMapPath *)path
{
    if (path == nil || path.steps.count == 0) {
        return nil;
    }
    NSMutableArray *polylines = [NSMutableArray array];
    [path.steps enumerateObjectsUsingBlock:^(AMapStep *step, NSUInteger idx, BOOL *stop) {
        NSUInteger count = 0;
        
        CLLocationCoordinate2D *coordinates = [self coordinatesForString:step.polyline coordinateCount:&count parseToken:@";"];
        MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordinates count:count];
        
        [polylines addObject:polyline];
        
        free(coordinates);
        coordinates = NULL;
    }];
    return polylines;
}


//（经纬度）字符串解析
-(CLLocationCoordinate2D *)coordinatesForString:(NSString *)string coordinateCount:(NSUInteger *) coordinateCount parseToken:(NSString *)token
{
    if (string == nil) {
        return NULL;
    }
    if (token == nil) {
        token = @",";
    }
    NSString *str = @"";
    //只要不是" ，"都转化为“ ，”然后分割
    if(![token isEqualToString:@","]) {
        str = [string stringByReplacingOccurrencesOfString:token withString:@","];
    } else {
        str = [NSString stringWithString:string];
    }
    NSArray *compent = [str componentsSeparatedByString:@","];
    NSUInteger count = [compent count] / 2;
    if (*coordinateCount == 0) {
        *coordinateCount = count;
    }
    //设置地址 和大小 在传出去，外面调用的时候可以通过地址和大小拿出
    CLLocationCoordinate2D *coordinates = (CLLocationCoordinate2D *)malloc(count *sizeof(CLLocationCoordinate2D));
    for (int i = 0; i < count; i ++) {
        coordinates[i].longitude = [[compent objectAtIndex:2 * i] doubleValue];
        coordinates[i].latitude = [[compent objectAtIndex:2 * i + 1] doubleValue];
    }
    return coordinates;
}


#pragma mark overLine的回调

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    
    if ([overlay isKindOfClass:[MAPolyline class]]) {
        
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth    = 4.f;
        polylineRenderer.strokeColor  = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.6];
        polylineRenderer.lineJoinType = kMALineJoinRound;
        polylineRenderer.lineCapType  = kMALineCapRound;
        
        return polylineRenderer;
        
    }
    return nil;
}

- (CGSize)offsetToContainRect:(CGRect)innerRect inRect:(CGRect)outerRect
{
    CGFloat nudgeRight = fmaxf(0, CGRectGetMinX(outerRect) - (CGRectGetMinX(innerRect)));
    CGFloat nudgeLeft = fminf(0, CGRectGetMaxX(outerRect) - (CGRectGetMaxX(innerRect)));
    CGFloat nudgeTop = fmaxf(0, CGRectGetMinY(outerRect) - (CGRectGetMinY(innerRect)));
    CGFloat nudgeBottom = fminf(0, CGRectGetMaxY(outerRect) - (CGRectGetMaxY(innerRect)));
    return CGSizeMake(nudgeLeft ?: nudgeRight, nudgeTop ?: nudgeBottom);
}

#pragma mark - 创建经纬度点
+ (NSMutableArray *)getAnnotationArray {
    NSMutableArray *annotationArray  = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        CustomMAPointAnnotation *annotation = [[CustomMAPointAnnotation alloc] init];
        
        CGFloat latidute    = 39.97721104213634;
        CGFloat longitude   = 116.36991900000002;
        
        if (i == 1) latidute    += 0.01;
        if (i == 2) latidute    -= 0.01;
        if (i == 3) longitude   += 0.01;
        if (i == 4) longitude   -= 0.01;
        
        annotation.coordinate = CLLocationCoordinate2DMake(latidute, longitude);
        annotation.title = @"AutoNavi";
        annotation.subtitle = @"CustomAnnotationView";
        
        NSString *trade_no = [NSString stringWithFormat:@"%d%d%d%d",i,i,i,i];
        annotation.otherInfo = @{@"trade_no":trade_no,
                                 @"platform":@"饿了么",
                                 @"status":@"待配送",
                                 @"name":@"高圆圆",
                                 @"portraitName":@"yuanyuan"};
        
        [annotationArray addObject:annotation];
    }
    return annotationArray;
}

@end

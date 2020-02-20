//
//  MapData.m
//  OmniChannelClient
//
//  Created by ZSXJ on 2017/6/23.
//  Copyright © 2017年 ZSXJ. All rights reserved.
//

#import "MapData.h"

#define APIKeyMap @"16b27fcb3a295e1c1ea4e240d0713f1c"

@implementation MapData

/*
     compassOrigin:          指南针
     scaleOrigin:            比例尺
     setUserTrackingMode:    设置追踪定位模式
     showsUserLocation:      显示用户位置
     distanceFilter:         设定定位的最小更新距离 （默认为kCLDistanceFilterNone，会提示任何移动）
     setZoomLevel:           设置缩放级别
 
*/

+ (MAMapView *)mapViewWithFrame:(CGRect)frame {
    
    [AMapServices sharedServices].apiKey = APIKeyMap;

    MAMapView *mapView = [[MAMapView alloc] initWithFrame:frame];

    mapView.compassOrigin       = CGPointMake(mapView.compassOrigin.x, 22);
    mapView.scaleOrigin         = CGPointMake(mapView.scaleOrigin.x, 22);
    mapView.distanceFilter      = 100;
    mapView.showsUserLocation   = YES;
    [mapView setZoomLevel:14 animated:YES];
    [mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    
    return mapView;
}


+ (AMapLocationManager *)mapLocationManager {
    
    AMapLocationManager *locationManager = [[AMapLocationManager alloc] init];
//    locationManager.delegate = self;
    locationManager.distanceFilter  = 200;
    return locationManager;
}



+ (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout               = YES;
        annotationView.animatesDrop                 = YES;
        annotationView.draggable                    = YES;
        annotationView.rightCalloutAccessoryView    = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        annotationView.image = [UIImage imageNamed:@"iconfont-biaoji"];
        
        return annotationView;
    }
    
    return nil;
}


+ (NSMutableArray *)getAnnotationArray {
    return [self getAnnotationArrayByCustomMAPointAnnotation];
}
+ (NSMutableArray *)getAnnotationArrayByCustomMAPointAnnotation {
    NSMutableArray *annotationArray  = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
//        CustomMAPointAnnotation *annotation = [[CustomMAPointAnnotation alloc] init];
        
        CGFloat latidute    = 39.97721104213634;
        CGFloat longitude   = 116.36991900000002;
        
        if (i == 1) latidute    += 0.01;
        if (i == 2) latidute    -= 0.01;
        if (i == 3) longitude   += 0.01;
        if (i == 4) longitude   -= 0.01;
        
//        annotation.coordinate = CLLocationCoordinate2DMake(latidute, longitude);
//        
//        NSString *trade_no      = [NSString stringWithFormat:@"%d%d%d%d",i,i,i,i];
//        annotation.otherInfo    = @{@"trade_no":trade_no,
//                                 @"platform":@"饿了么",
//                                 @"status":@"待配送",
//                                 @"name":@"高圆圆",
//                                 @"portraitName":@"yuanyuan"};
//        annotation.title        = annotation.otherInfo[@"platform"];
//        annotation.subtitle     = annotation.otherInfo[@"trade_no"];
//        [annotationArray addObject:annotation];
        
        
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(latidute, longitude);
        pointAnnotation.title = @"方恒国际";
        pointAnnotation.subtitle = @"阜通东大街6号";
        [annotationArray addObject:pointAnnotation];
    }
    return annotationArray;
}

@end

//
//  MapData.h
//  OmniChannelClient
//
//  Created by ZSXJ on 2017/6/23.
//  Copyright © 2017年 ZSXJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "CustomMAPointAnnotation.h"
@interface MapData : NSObject

+ (MAMapView *)mapViewWithFrame:(CGRect)frame;
+ (AMapLocationManager *)mapLocationManager;
+ (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation;
+ (NSMutableArray *)getAnnotationArray;

@end

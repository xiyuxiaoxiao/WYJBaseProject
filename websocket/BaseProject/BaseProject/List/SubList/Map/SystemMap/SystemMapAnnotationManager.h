//
//  SystemMapAnnotationManager.h
//  BaseProject
//
//  Created by ZSXJ on 2017/6/23.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SystemMapAnnotationManager : NSObject

+ (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation;

+ (NSMutableArray *)getAnnotationArray;
@end

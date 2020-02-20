//
//  SystemMapAnnotationManager.m
//  BaseProject
//
//  Created by ZSXJ on 2017/6/23.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "SystemMapAnnotationManager.h"
#import "MyAnnotation.h"
#import "CustomPinAnnotationView.h"

@implementation SystemMapAnnotationManager

+ (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    return [self customPinAnnotationViewMapView:mapView viewForAnnotation:annotation];
    
    return nil;
}

+ (MKAnnotationView *)customPinAnnotationViewMapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if (NO == [annotation isKindOfClass:[MyAnnotation class]]) {
        return nil;
    }
    
    CustomPinAnnotationView *annotationView = (CustomPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"otherAnnotationView"];
    if (annotationView == nil) {
        annotationView = [[CustomPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"otherAnnotationView"];
        annotationView.canShowCallout   = NO;
        annotationView.draggable        = YES;
        annotationView.calloutOffset    = CGPointMake(0, -5);
    }
    
//    [annotationView setSelected:YES animated:NO];
    MyAnnotation *myAnnotation = annotation;
    annotationView.orderInfo = myAnnotation.otherInfo;
    
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


+ (MKAnnotationView *)mKAnnotationViewMapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKPointAnnotation class]])  {
        MKAnnotationView *view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@""];
        view.image = [UIImage imageNamed:@"iconfont-biaoji"];
        view.canShowCallout = YES;
        return view;
    }
    return nil;
}

// 返回 MKPinAnnotationView
+ (MKAnnotationView *)mKPinAnnotationViewMapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        
        MKPinAnnotationView *customPinView = (MKPinAnnotationView*)[mapView
                                                                    dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!customPinView){
            // If an existing pin view was not available, create one.
            customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                            reuseIdentifier:@"CustomPinAnnotationView"];
        }
        //iOS9中用pinTintColor代替了pinColor
        customPinView.pinColor = MKPinAnnotationColorPurple;
        customPinView.animatesDrop = YES;
        customPinView.canShowCallout = YES;
        
        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
        rightButton.backgroundColor = [UIColor grayColor];
        [rightButton setTitle:@"查看详情" forState:UIControlStateNormal];
        customPinView.rightCalloutAccessoryView = rightButton;
        
        // Add a custom image to the left side of the callout.（设置弹出起泡的左面图片）
        UIImageView *myCustomImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-biaoji"]];
        customPinView.leftCalloutAccessoryView = myCustomImage;
        return customPinView;
    }
    
    return nil;
}

+ (NSMutableArray *)getAnnotationArray {
    return [self getAnnotationArrayByMyAnnotation];
}
+ (NSMutableArray *)getAnnotationArrayByMyAnnotation {
    NSMutableArray *annotationArray  = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        MyAnnotation *annotation = [[MyAnnotation alloc] init];
        
        CGFloat latidute    = 39.97721104213634;
        CGFloat longitude   = 116.36991900000002;
        
        CGFloat space = 0.01;
        if (i == 1) latidute    += space;
        if (i == 2) latidute    -= space;
        if (i == 3) longitude   += space;
        if (i == 4) longitude   -= space;
        
        annotation.coordinate = CLLocationCoordinate2DMake(latidute, longitude);
        
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



+ (NSMutableArray *)getAnnotationArrayMKPointAnnotation {
    NSMutableArray *annotationArray  = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.title = @"重庆理工大学";
        annotation.subtitle = [NSString stringWithFormat:@"%d%d%d%d",i,i,i,i];
        
        CGFloat latidute    = 39.97721104213634;
        CGFloat longitude   = 116.36991900000002;
        
        CGFloat space = 0.01;
        if (i == 1) latidute    += space;
        if (i == 2) latidute    -= space;
        if (i == 3) longitude   += space;
        if (i == 4) longitude   -= space;
        
        annotation.coordinate = CLLocationCoordinate2DMake(latidute, longitude);
        
        [annotationArray addObject:annotation];
    }
    return annotationArray;
}

@end

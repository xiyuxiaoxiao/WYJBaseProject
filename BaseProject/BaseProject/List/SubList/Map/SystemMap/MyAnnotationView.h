//
//  CustomPinAnnotationView.h
//  BaseProject
//
//  Created by ZSXJ on 2017/6/22.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "MyAnnotation.h"
@interface MyAnnotationView : MKAnnotationView

@property (nonatomic, strong) UIImage *portrait;
@property (nonatomic, copy)   NSString *name;
@property (nonatomic, strong) UIView *calloutView;

@property (nonatomic, strong) NSDictionary *orderInfo;

@end

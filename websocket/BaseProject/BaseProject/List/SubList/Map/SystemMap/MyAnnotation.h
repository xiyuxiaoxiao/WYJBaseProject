//
//  MyAnnotation.h
//  BaseProject
//
//  Created by ZSXJ on 2017/6/22.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

//注意导入框架

#import <MapKit/MapKit.h>

/**
 *  大头针枚举
 */
typedef NS_ENUM(NSInteger,PinType) {
    /**
     *  超市
     */
    SUPER_MARKET = 0,
    /**
     *  火场
     */
    CREMATORY,
    /**
     *  景点
     */
    INTEREST,
};

//该模型是大头针模型 所以必须实现协议MKAnnotation协议 和CLLocationCoordinate2D中的属性coordinate
@interface MyAnnotation : NSObject<MKAnnotation>

@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong)   NSDictionary *otherInfo;

@end

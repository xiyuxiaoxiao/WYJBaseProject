//
//  MapSkipManager.m
//  OmniChannelClient
//
//  Created by ZSXJ on 2017/5/23.
//  Copyright © 2017年 ZSXJ. All rights reserved.
//

#import "MapSkipManager.h"
#import <MapKit/MapKit.h>
#import "AppDelegate.h"
#import "NSString+NSString.h"
@implementation MapSkipManager


/*
 
 iOS9 开发可能会出现安装了某地图，但是检查不到已经安装！！！
 
 这时候就需要在plist文件配置白名单了
 <key>LSApplicationQueriesSchemes</key>
 <array>
 　　 <string>baidumap</string>       //百度
 　　<string>iosamap</string>         // 高德
 　　<string>comgooglemaps</string>   //谷歌
 
 </array>
 
 */

//CGFloat latitude = 39.97721104213634;
//CGFloat longitude = 116.36991900000002;

+ (void)skipMapAppWithOrderInfo:(NSDictionary *)info {
    NSString *latitude = [info objectForKey:@"latitude"];
    NSString *longitude = [info objectForKey:@"longitude"];
    
    if ([NSString judgeIsEmptyWithString:latitude] || [NSString judgeIsEmptyWithString:longitude]) {
        // 目的地坐标无效 无地址所以无法打开
        return;
    }
    
    MapSkipManager *ma = [[MapSkipManager alloc] init];
    ma.latitude = [latitude floatValue];
    ma.longitude = [longitude floatValue];
    ma.desAddress = [info objectForKey:@"adr"];
    if ([NSString judgeIsEmptyWithString:ma.desAddress]) {
        ma.desAddress = @"目的地";
    }
    [ma skipMapApp];
}

- (void)skipMapApp {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *xitongMapAction = [UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self skipSystemMap];
        
    }];
    [alert addAction:xitongMapAction];
    
    
    UIAlertAction *baiduAction = [UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self skipBaiduMap];
    }];
    BOOL baiduMapCanOpen=[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]];
    if (baiduMapCanOpen) {
        [alert addAction:baiduAction];
    }
    
    UIAlertAction *iosMapAction = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self skipIosamap];
    }];
    BOOL iosMapCanOpen=[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]];
    if (iosMapCanOpen) {
        [alert addAction:iosMapAction];
    }
    
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alert addAction:cancleAction];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark 百度
- (void)skipBaiduMap {
    /*      要注意几点：
     
     1. origin={{我的位置}}
     
     这个是不能被修改的 不然无法把出发位置设置为当前位置
     
     2. destination=latlng:%f,%f|name=目的地
     
     name=XXXX name这个字段不能省略 否则导航会失败 而后面的文字则可以随便填
     
     3. coord_type=gcj02
     
     coord_type允许的值为bd09ll、gcj02、wgs84 如果你APP的地图SDK用的是百度地图SDK 请填bd09ll 否则 就填gcj02 wgs84你基本是用不上了(关于地图加密这里也不多谈 请自行学习)
     
     */
    NSString *urlsting = [NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name:%@&mode=driving&coord_type=gcj02",self.latitude,self.longitude,self.desAddress];
    urlsting = [urlsting stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlsting]];
}

#pragma mark  苹果自带
- (void)skipSystemMap {
    
    CLLocationCoordinate2D coords2 = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    
    //当前的位置
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    //目的地的位置
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords2 addressDictionary:nil]];
    toLocation.name = self.desAddress;
    NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];
    
    NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
    
    //打开苹果自身地图应用，并呈现特定的item
    [MKMapItem openMapsWithItems:items launchOptions:options];
}

#pragma mark 高德
- (void)skipIosamap {
    
    NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&sname=%@&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&m=0&t=0",@"我的位置",self.latitude,self.longitude,self.desAddress] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    
    /*
     
     高德
     导航 （sourceApplication 、backScheme  不能设置 @""  否则跳转后没有路线）
     
     NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@" ",@" ",latitude, longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
     
     
     // 跳转规划路线
     double currentLatitude = latitude - 0.001;
     double currentLongitude = longitude - 0.001;
     NSString *urlString2 = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=%f&slon=%f&sname=%@&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&m=0&t=0",currentLatitude,currentLongitude,@"我的位置",latitude,longitude,@"目的地"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     
     
     */
}

@end

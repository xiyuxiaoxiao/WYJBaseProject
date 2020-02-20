//
//  NearbyView.h
//  BigMedicineBottle
//
//  Created by lanou3g on 15/6/23.
//  Copyright (c) 2015年 wyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

#define APIKey @"16b27fcb3a295e1c1ea4e240d0713f1c"
@interface NearbyView : UIView

@property(strong,nonatomic)MAMapView *mapView;
@property(strong,nonatomic)UIButton *myLocationButton;
@property(strong,nonatomic)UIButton *searchButton;
@end

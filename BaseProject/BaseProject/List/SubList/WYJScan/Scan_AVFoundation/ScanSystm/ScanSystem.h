//
//  ScanSystem.h
//  BaseProject
//
//  Created by ZSXJ on 2017/8/17.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ScanSystemBlock)(NSString* string);


@interface ScanSystem : UIViewController
@property(copy,nonatomic)ScanSystemBlock responseQR;
@end

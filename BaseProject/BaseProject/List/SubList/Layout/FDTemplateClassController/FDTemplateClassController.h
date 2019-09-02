//
//  FDTemplateClassController.h
//  BaseProject
//
//  Created by ZSXJ on 2019/9/2.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FDTemplateClassController : ViewController

@end

@interface FDTemplateClassModal : NSObject
@property (nonatomic, copy)     NSString *title;
@property (nonatomic, copy)     NSString *name;

@property (nonatomic, assign)   BOOL hidden;
@end

NS_ASSUME_NONNULL_END

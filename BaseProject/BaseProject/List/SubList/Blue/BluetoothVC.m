//
//  BluetoothVC.m
//  BaseProject
//
//  Created by 潇雨 on 2020/12/28.
//  Copyright © 2020 WYJ. All rights reserved.
//

#import "BluetoothVC.h"
#import <CoreBluetooth/CoreBluetooth.h>


@interface BluetoothVC ()<CBCentralManagerDelegate>

@property (nonatomic,strong) CBCentralManager *centralManager;
@property (nonatomic, weak) IBOutlet UILabel *label;

@property (nonatomic, copy) NSString *textString;
@property (nonatomic, assign) BOOL showText;
@property (nonatomic, strong) UILabel *windowViewLabel;

@end

@implementation BluetoothVC

- (void)initWindowData{
    self.showText = NO;
    self.textString = @"";
}
- (void)saveLoag:(NSString *)str {
    self.textString = [self.textString stringByAppendingString:str];
    self.textString = [self.textString stringByAppendingString:@"\n"];
    
    if (self.showText) {
        self.windowViewLabel.text = self.textString;
        return;
    }
    
    self.showText = YES;
    
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeWindowView)];
    [view addGestureRecognizer:tap];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, view.bounds.size.width, view.bounds.size.height * 0.7)];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor whiteColor];
    [view addSubview:label];
    
    label.text = self.textString;
    
    self.windowViewLabel = label;
}
- (void)removeWindowView {
    [self.windowViewLabel.superview removeFromSuperview];
    self.showText = NO;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWindowData];
    
    self.label.text = @"";
    
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];

}

- (IBAction)getBluePermission:(id)sender {
    NSLog(@"哈哈");
}


#pragma mark - CLLocationManagerDelegate
//每次蓝牙状态改变都会回调这个函数
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
    NSArray *title = @[
        @"CBManagerStateUnknown",
        @"CBManagerStateResetting",
        @"CBManagerStateUnsupported",
        @"CBManagerStateUnauthorized",
        @"CBManagerStatePoweredOff",
        @"CBManagerStatePoweredOn",
    ];
    
    NSLog(@"蓝牙状态 %@",title[(int)central.state]);
    
    NSString *blueStateStr = title[(int)self.centralManager.state];
    
    NSString *str = self.label.text;
    str = [str stringByAppendingString:@"\n"];
                                   
    str = [str stringByAppendingString:blueStateStr];
    
    self.label.text = str;
    
    
    
    [self saveLoag:blueStateStr];
}

- (IBAction)openSetting {
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}
@end

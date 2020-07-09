//
//  DatePickController.m
//  BaseProject
//
//  Created by 潇雨 on 2020/7/9.
//  Copyright © 2020 WYJ. All rights reserved.
//

#import "DatePickController.h"
#import "WSDatePickerView.h"
@interface DatePickController ()
{
    WSDateStyle dateStyle;
}
@end

@implementation DatePickController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)button1:(id)sender {
    dateStyle = DateStyleShowYearMonthDay;
    [self addPick];
}
- (IBAction)button2:(id)sender {
    dateStyle = DateStyleShowYearMonth;
    [self addPick];
}
- (IBAction)button3:(id)sender {
    dateStyle = DateStyleShowMonthDay;
    [self addPick];
}
- (IBAction)button4:(id)sender {
    dateStyle = DateStyleShowDayHourMinute;
    [self addPick];
}
- (IBAction)button5:(id)sender {
    dateStyle = DateStyleShowYearMonthDayHourMinute;
    [self addPick];
}

- (void)addPick {
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:dateStyle CompleteBlock:^(NSDate *selectDate) {
        NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd"];
        NSLog(@"选择的月日时分：%@",date);
    }];
    datepicker.dateLabelColor = [UIColor orangeColor];//年-月-日-时-分 颜色
    datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
    datepicker.doneButtonColor = [UIColor orangeColor];//确定按钮的颜色
    [datepicker show];
}

@end

//
//  RestMoneyEveryYearController.m
//  BaseProject
//
//  Created by ZSXJ on 2019/10/24.
//  Copyright © 2019 WYJ. All rights reserved.
//

#import "RestMoneyEveryYearController.h"

// 计算n年后还剩多少钱  每年从本金扣除需要多支付的钱
float calMyMoneyYearLater(float remain, float yearDiff, int *year, NSMutableString *str) {

    while (remain > 0) {
        //返回一年后的金额 从本金扣除需要多支付的钱 然后剩余的本金
        float oneYearLater = (remain - yearDiff) * 1.04;
        *year = *year + 1;
        [str appendFormat:@" %d\t 年 余额： %.2f\t万 \n", *year, oneYearLater / 10000];
        
        remain = calMyMoneyYearLater(oneYearLater, yearDiff, year, str);
    }
    return remain;
}

@interface RestMoneyEveryYearController ()
@property (nonatomic, weak) IBOutlet UITextField *amountField;     // 额度
@property (nonatomic, weak) IBOutlet UITextField *monthyDiffField; // 每个月的差值
@property (nonatomic, weak) IBOutlet UITextView  *resultText;      // 结果
@end

@implementation RestMoneyEveryYearController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.resultText.editable = NO;
    self.resultText.textContainerInset = UIEdgeInsetsMake(20, 0, 20, 0);
}

- (IBAction)calculateAction:(id)sender {
    
    [self resignFirstResponder];
    
    float amount = [self.amountField.text floatValue] * 10000;
    float yearDiff = [self.monthyDiffField.text floatValue] * 12;
    int year  = 0;
    
    
    NSMutableString *str = [NSMutableString string];
    calMyMoneyYearLater(amount, yearDiff, &year, str);
    
    self.resultText.text = str;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self resignFirstResponder];
    
}

- (BOOL)resignFirstResponder {
    [self.amountField resignFirstResponder];
    [self.monthyDiffField resignFirstResponder];
    return [super resignFirstResponder];
}

@end

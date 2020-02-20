//
//  ViewController.m
//  BaseProject
//
//  Created by ZSXJ on 2017/4/10.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "ViewController.h"
#import "WYJHTTPSession.h"
#import "WYJDate.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    Class classContorller = NSClassFromString(@"ImageManagerControer");
    UIViewController *vc = [[classContorller alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    return;
    NSLog(@"开始");
    // 对 url 和 params  进行 MD5 编码  作为key
    NSDictionary *params = @{
                             @"company_id":     @"2",
                             @"id_or_code":     @"197",
                             @"platform_ids":   @"40,41,42,45"
                             };
    [WYJHTTPSession GET:@"http://wdto2o.wangdian.cn/WdtFull/V1/Waimai/getWaimaiOpenTime" ReqParams:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"success: %@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *theError) {
        NSLog(@"error: %@",theError);
    }];

}
@end

//
//  CitySelectController.m
//  BaseProject
//
//  Created by ZSXJ on 2017/6/16.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "CitySelectController.h"
#import "CityController.h"
@interface CitySelectController ()
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@end

@implementation CitySelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)buttonAction:(id)sender {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    NSArray *array = dict[@"address"];
    
    CityController *cityController = [[CityController alloc] init];
    cityController.currentTitle = @"省份";
    cityController.array = array;
    cityController.selectBlock = ^(NSString *str){
        self.cityLabel.text = str;
    };
    
    [self.navigationController pushViewController:cityController animated:YES];
}

@end

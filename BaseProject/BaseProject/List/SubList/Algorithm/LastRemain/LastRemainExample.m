//
//  LastRemainExample.m
//  BaseProject
//
//  Created by ZSXJ on 2017/9/18.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "LastRemainExample.h"
#import "LastRemainObject.h"
@interface LastRemainExample ()

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (weak, nonatomic) IBOutlet UITextField *mText;
@property (weak, nonatomic) IBOutlet UITextField *nText;

@end

@implementation LastRemainExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"查看源码" style:(UIBarButtonItemStylePlain) target:self action:@selector(codeShow)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)codeShow {
    SourceViewController *vc = [[SourceViewController alloc] init];
    vc.filePath = SourcePathByClassName(@"LastRemainObject");
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)codeAction:(id)sender {
    NSString *text = self.nText.text;
    int n = [text intValue];
    
    
    NSString *mText = self.mText.text;
    int m = [mText intValue];
    if (n <= 0 || m <= 0) {
        self.resultLabel.text = [NSString stringWithFormat:@"结果: 请检查m、n"];
        return;
    }
    int s = LastRemaining(n, m);
    self.resultLabel.text = [NSString stringWithFormat:@"结果: %d",s];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.nText resignFirstResponder];
    [self.mText resignFirstResponder];
}

@end

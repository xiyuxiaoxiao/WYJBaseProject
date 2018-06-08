//
//  TextOneByOne.m
//  BaseProject
//
//  Created by ZSXJ on 2017/7/13.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "TextOneByOne.h"
#import <CoreText/CoreText.h>

@interface TextOneByOne ()
{
    NSMutableArray *labels;
    NSMutableArray *numArr;
    NSMutableArray *dataArr;
}
@end

@implementation TextOneByOne

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/*
 正在加载中的 不能再点击 否则造成速度加快
 */
- (IBAction)buttonClick:(id)sender {
    
    self.view.userInteractionEnabled = NO;
    
    UIView *view = [self.view viewWithTag:101];
    if (view) {
        [view removeFromSuperview];
    }
    
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    vi.backgroundColor = [UIColor whiteColor];
    vi.tag = 101;
    [self.view addSubview:vi];
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = vi.bounds;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    [vi.layer addSublayer:textLayer];
    textLayer.alignmentMode = kCAAlignmentJustified;
    textLayer.wrapped = YES;
    
    UIFont *font = [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:12];
    NSArray *familyNames = [UIFont familyNames];
    for( NSString *familyName in familyNames ){
        
        printf( "Family: %s \n", [familyName UTF8String] );
        
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        for( NSString *fontName in fontNames ){
            
            printf( "\tFont: %s \n", [fontName UTF8String] );
        }
    }
    
    NSString *str = @"还是月西江更有意境:日暮江水远,入夜随风迁,秋叶乱水月...";
    
    NSMutableAttributedString *string = nil;
    string = [[NSMutableAttributedString alloc] initWithString:str];
    CFStringRef fontName = (__bridge CFStringRef)(font.fontName);
    CGFloat fontSize = font.pointSize;
    CTFontRef fontRef = CTFontCreateWithName(fontName, fontSize, NULL);
    NSDictionary *attribs = @{
                              (__bridge id)kCTForegroundColorAttributeName:(__bridge id)[UIColor whiteColor].CGColor,
                              (__bridge id)kCTFontAttributeName:(__bridge id)fontRef
                              };
    [string setAttributes:attribs range:NSMakeRange(0, str.length)];
    
    dataArr = [NSMutableArray arrayWithObjects:(__bridge id _Nonnull)(fontRef),attribs,string,str,textLayer, nil];
    numArr = [NSMutableArray array];
    for (int i = 0; i < str.length; i++) {
        [numArr addObject:[NSNumber numberWithInt:i]];
        [self performSelector:@selector(changeToBlack) withObject:nil afterDelay:0.1 * i];
    }
    
    NSLog(@"=================ddd=======");
    CFRelease(fontRef);
    
}

- (void)changeToBlack {
    CTFontRef fontRef = (__bridge CTFontRef)(dataArr[0]);
    NSMutableAttributedString *string = dataArr[2];
    NSNumber *num = [numArr firstObject];
    int y = [num intValue];
    NSDictionary *attribs = dataArr[1];
    attribs = @{
                (__bridge id)kCTForegroundColorAttributeName:(__bridge id)[UIColor blackColor].CGColor,
                (__bridge id)kCTFontAttributeName:(__bridge id)fontRef
                };
    [string setAttributes:attribs range:NSMakeRange(y, 1)];
    if (numArr.count > 0) {
        [numArr removeObjectAtIndex:0];
    }
    
    if (numArr.count == 0) {
        self.view.userInteractionEnabled = YES;
    }
    
    CATextLayer *textLayer = [dataArr lastObject];
    textLayer.string = string;
}

@end

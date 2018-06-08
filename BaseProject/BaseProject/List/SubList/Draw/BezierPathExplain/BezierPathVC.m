//
//  BezierPathVC.m
//  BaseProject
//
//  Created by ZSXJ on 2018/4/23.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import "BezierPathVC.h"
#import "BezierPathView.h"

@interface BezierPathVC ()
{
    BezierPathView *pathView;
    BezierPathView *addLayPathView;
    
    UIView *referenceView;
}

@property (weak, nonatomic) IBOutlet UITextField *strokenEndTextField;
@property (weak, nonatomic) IBOutlet UITextField *lineWidthTextField;
@property (weak, nonatomic) IBOutlet UITextField *kMarginTextField;
@property (weak, nonatomic) IBOutlet UITextField *paddingTextField;

@property (weak, nonatomic) IBOutlet UITextField *fillColorAlphaTextField;
@property (weak, nonatomic) IBOutlet UITextField *strokeColorAlphaTextField;

@end

@implementation BezierPathVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"UIBezierPath 相关属性";
    
    _kMarginTextField.text = @"20";
    _strokenEndTextField.text = @"0.8";
    _lineWidthTextField.text = @"30";
    _paddingTextField.text = @"20";
    
    _fillColorAlphaTextField.text = @"1";
    _strokeColorAlphaTextField.text = @"0.3";
    
    [self addReferenceView];
    [self addPiceView];
    [self addPiceViewByAddLayer];
    
    [self addLabel:referenceView text:@"参考的 宽、高:100"];
    [self addLabel:pathView text:@"设置为mask"];
    [self addLabel:addLayPathView text:@"addLayer"];
}

- (void)addLabel: (UIView *)topView text: (NSString *)text {
    
    CGFloat x = topView.frame.origin.x;
    CGFloat y = CGRectGetMaxY(topView.frame);
    CGFloat w = topView.frame.size.width;
    CGFloat h = 20;
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label];
    label.frame = CGRectMake(x, y, w, h);
    
    label.text = text;
}

- (void)addReferenceView {
    CGFloat x = 20;
    CGFloat y = 20;
    CGFloat w = 100;
    CGFloat h = 100;
    
    referenceView = [[UIView alloc] init];
    referenceView.frame = CGRectMake(x, y, w, h);
    referenceView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:referenceView];
}

- (void)addPiceView {
    
    CGFloat y = referenceView.frame.origin.y + referenceView.frame.size.height + 20;
    BezierPathView *view = [self creatPathView:y];
    [view refresh];
    [self.view addSubview:view];
    
    pathView = view;
}

- (void)addPiceViewByAddLayer {
    CGFloat y = referenceView.frame.origin.y + (referenceView.frame.size.height + 40)*2;
    BezierPathView *view = [self creatPathView:y];
    [view addMaskLayer];
    [self.view addSubview:view];
    addLayPathView = view;
}

- (BezierPathView *)creatPathView: (CGFloat)y {
    CGFloat x = referenceView.frame.origin.x;
    CGFloat w = referenceView.frame.size.width;
    CGFloat h = referenceView.frame.size.height;
    
    BezierPathView *view = [[BezierPathView alloc] init];
    
    view.radius = w/2;
    view.centerPoint = CGPointMake(x+w/2, y+w/2);
    
    view.strokeEnd  = [_strokenEndTextField.text floatValue];
    view.lineWidth  = [_lineWidthTextField.text floatValue];
    view.kMargin    = [_kMarginTextField.text floatValue];
    view.padding    = [_paddingTextField.text floatValue];
    view.fillColorAlpha   = [_fillColorAlphaTextField.text floatValue];
    view.strokeColorAlpha = [_strokeColorAlphaTextField.text floatValue];
    
    view.frame = CGRectMake(x, y, w, h);
    return view;
}

- (IBAction)confirmAction:(id)sender {
    [self changeStrokend];
    [self changeLineWidth];
    [self changeKMargin];
    [self changeFillColorAlpha];
    [self changeStrokeColorAlpha];
    
    [pathView removeFromSuperview];
    pathView = nil;
    [self addPiceView];
    
    [addLayPathView removeFromSuperview];
    addLayPathView = nil;
    [self addPiceViewByAddLayer];;
}


- (void)changeStrokend {
    
    CGFloat f = [_strokenEndTextField.text floatValue];
    if (f <= 0) {
        f = 0;
    }
    else if (f >= 1) {
        f = 1;
    }
    _strokenEndTextField.text = [NSString stringWithFormat:@"%.2f",f];
}

- (void)changeLineWidth {
    
    CGFloat f = [_lineWidthTextField.text floatValue];
    if (f <= 0) {
        f = 0;
    }
    _lineWidthTextField.text = [NSString stringWithFormat:@"%.0f",f];
}

- (void)changeKMargin {
    
    CGFloat f = [_kMarginTextField.text floatValue];
    if (f <= 0) {
        f = 0;
    }
    _kMarginTextField.text = [NSString stringWithFormat:@"%.0f",f];
}

- (void)changePadding {
    
    CGFloat f = [_paddingTextField.text floatValue];
    if (f <= 0) {
        f = 0;
    }
    _paddingTextField.text = [NSString stringWithFormat:@"%.0f",f];
}

- (void)changeFillColorAlpha {
    
    CGFloat f = [_fillColorAlphaTextField.text floatValue];
    if (f <= 0) {
        f = 0;
    }
    else if (f >= 1) {
        f = 1;
    }
    _fillColorAlphaTextField.text = [NSString stringWithFormat:@"%.1f",f];
}

- (void)changeStrokeColorAlpha {
    
    CGFloat f = [_strokeColorAlphaTextField.text floatValue];
    if (f <= 0) {
        f = 0;
    }
    else if (f >= 1) {
        f = 1;
    }
    _strokeColorAlphaTextField.text = [NSString stringWithFormat:@"%.1f",f];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}


@end

//
//  GradientColorController.m
//  BaseProject
//
//  Created by ZSXJ on 2018/8/9.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import "GradientColorController.h"
#import <Accelerate/Accelerate.h>
#import <GPUImage.h>

@interface GradientColorController ()
@property (nonatomic, strong)CIFilter *filter;
@end

@implementation GradientColorController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self addBackLayer];
    [self addGradientLayer];
    
//    [self addVagueViewByCoreImage];
    [self addVagueViewByGPU];
}

- (void)addGradientLayer  {
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(50, 250, 300, 20);
    gradientLayer.cornerRadius = 10;
    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor yellowColor].CGColor,(__bridge id)[UIColor greenColor].CGColor, (__bridge id)[UIColor blueColor].CGColor];
    gradientLayer.locations = @[@0.3, @0.5, @0.7, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    [self.view.layer addSublayer:gradientLayer];
    
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = CGRectMake(0, 0, 0, 20);
    maskLayer.borderWidth = 20;
    [gradientLayer setMask:maskLayer];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self circleAnimation:maskLayer];
    });
    
}

- (void)addBackLayer {
    CALayer *bgLayer = [CALayer layer];
    bgLayer.frame = CGRectMake(50, 250, 300, 20);
    bgLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    bgLayer.masksToBounds = YES;
    bgLayer.cornerRadius = 10;
    [self.view.layer addSublayer:bgLayer];
}

- (void)circleAnimation:(CALayer *)maskLayer { // 进度条动画
    
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [CATransaction setAnimationDuration:2];
    maskLayer.frame = CGRectMake(0, 0, 300, 20);
    [CATransaction commit];
}


//---------------- 模糊图片 -------------------------------------------
- (void)addVagueViewByCoreImage {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 300, 300, 200)];
    [self.view addSubview:imageView];
    
    UIImage *image = [UIImage imageNamed:@"middelLittle"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
        CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
        [filter setValue:ciImage forKey:kCIInputImageKey];
        //设置模糊程度
        [filter setValue:@10.0f forKey: @"inputRadius"];
        
        self.filter = filter;
        
        CIImage *result = [filter valueForKey:kCIOutputImageKey];
        CGRect frame = [ciImage extent];
        NSLog(@"%f,%f,%f,%f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
        CGImageRef outImage = [context createCGImage: result fromRect:ciImage.extent];
        UIImage * blurImage = [UIImage imageWithCGImage:outImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = blurImage;
        });
    });
}

- (void)addVagueViewByGPU {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 300, 300, 200)];
    imageView.tag = 200;
    [self.view addSubview:imageView];
    
    UIImage *image = [UIImage imageNamed:@"middelLittle"];
    GPUImageGaussianBlurFilter *filter = [[GPUImageGaussianBlurFilter alloc] init];
    filter.blurRadiusInPixels = 10.0;//值越大，模糊度越大
    UIImage *blurImage = [filter imageByFilteringImage:image];

    imageView.image = blurImage;
}

@end

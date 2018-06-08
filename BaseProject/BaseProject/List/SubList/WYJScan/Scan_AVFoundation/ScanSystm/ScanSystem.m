//
//  ScanSystem.m
//  BaseProject
//
//  Created by ZSXJ on 2017/8/17.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "ScanSystem.h"
#import <AVFoundation/AVFoundation.h>

@interface ScanSystem ()<AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) UIView *boxView;
@property (nonatomic) BOOL isReading;
@property (strong, nonatomic) CALayer *scanLayer;
@property (strong, nonatomic) UIView *viewPreview;
//捕捉会话
@property (nonatomic, strong) AVCaptureSession *captureSession;
//展示layer
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@end

@implementation ScanSystem

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewPreview = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.view = self.viewPreview;
    
    _captureSession = nil;
    _isReading = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self startReading];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self stopReading];
}

- (void)moveScanLayer:(NSTimer *)timer
{
    CGRect frame = _scanLayer.frame;
    if (_boxView.frame.size.height < _scanLayer.frame.origin.y) {
        frame.origin.y = 0;
        _scanLayer.frame = frame;
    }else{
        frame.origin.y += 5;
        [UIView animateWithDuration:0.05 animations:^{
            _scanLayer.frame = frame;
        }];
    }
}

- (void)startStopReading{
    if (!_isReading) {
        if ([self startReading]) {
            
        }
    }
    else{
        [self stopReading];
    }
    _isReading = !_isReading;
}
-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    [_scanLayer removeFromSuperlayer];
    [_videoPreviewLayer removeFromSuperlayer];
}

#pragma mark - AVCaptureDevice
- (BOOL)startReading {
    NSError *error;
    //1.初始化捕捉设备（AVCaptureDevice），类型为AVMediaTypeVideo
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //2.用captureDevice创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    //3.创建媒体数据输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    //4.实例化捕捉会话
    _captureSession = [[AVCaptureSession alloc] init];
    //4.1.将输入流添加到会话
    [_captureSession addInput:input];
    //4.2.将媒体输出流添加到会话中
    [_captureSession addOutput:captureMetadataOutput];
    //5.创建串行队列，并加媒体输出流添加到队列当中
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    //5.1.设置代理
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    //5.2.设置输出媒体数据类型为QRCode
    //    [captureMetadataOutput setMetadataObjectTypes:
    //     @[AVMetadataObjectTypeCode128Code,]];
    [captureMetadataOutput setMetadataObjectTypes:
     @[AVMetadataObjectTypeQRCode,
       AVMetadataObjectTypeEAN13Code,
       AVMetadataObjectTypeEAN8Code,
       AVMetadataObjectTypeUPCECode,
       AVMetadataObjectTypeCode39Code,
       AVMetadataObjectTypeCode39Mod43Code,
       AVMetadataObjectTypeCode93Code,
       AVMetadataObjectTypeCode128Code,
       AVMetadataObjectTypePDF417Code]];
    //6.实例化预览图层
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    //7.设置预览图层填充方式
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    //8.设置图层的frame
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    //9.将图层添加到预览view的图层上
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    
    //10.设置扫描范围
    captureMetadataOutput.rectOfInterest = CGRectMake(0.2f, 0.2f, 0.6f, 0.6f);
    
    
    //10.1.扫描框
    //    _boxView = [[UIView alloc] initWithFrame:CGRectMake(_viewPreview.bounds.size.width * 0.2f, _viewPreview.bounds.size.height * 0.2f, _viewPreview.bounds.size.width - _viewPreview.bounds.size.width * 0.4f, _viewPreview.bounds.size.height - _viewPreview.bounds.size.height * 0.4f)];
    
    _boxView = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 110, [UIScreen mainScreen].bounds.size.height / 2 - 110, 220, 220)];
    _boxView.layer.borderColor = [UIColor greenColor].CGColor;
    _boxView.layer.borderWidth = 1.0f;
    [_viewPreview addSubview:_boxView];
    
    
    //10.2.扫描线
    _scanLayer = [[CALayer alloc] init];
    _scanLayer.frame = CGRectMake(0, 0, _boxView.bounds.size.width, 1);
    _scanLayer.backgroundColor = [UIColor brownColor].CGColor;
    [_boxView.layer addSublayer:_scanLayer];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(moveScanLayer:) userInfo:nil repeats:YES];
    [timer fire];
    
    //10.开始扫描
    [_captureSession startRunning];
    return YES;
}

//MARK: 解析扫描结果
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //判断是否有数据
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        //判断回传的数据类型
        [self stopReading];
        
        NSString *userId = [metadataObj stringValue];
        
        [self.navigationController performSelectorOnMainThread:@selector(popViewControllerAnimated:) withObject:nil waitUntilDone:NO];
        self.responseQR(userId);
        
        _isReading = YES;
    }
}

@end

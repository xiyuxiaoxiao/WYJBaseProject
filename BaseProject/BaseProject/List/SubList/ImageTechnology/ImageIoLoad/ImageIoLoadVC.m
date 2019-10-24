//
//  ImageIoLoadVC.m
//  BaseProject
//
//  Created by ZSXJ on 2019/10/10.
//  Copyright © 2019 WYJ. All rights reserved.
//

#import "ImageIoLoadVC.h"

@interface ImageIoLoadVC ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSMutableData *haveReceivedData;
@property (nonatomic, strong) dispatch_queue_t queueSerial;
@end

@implementation ImageIoLoadVC
- (NSMutableData *)haveReceivedData {
    if (!_haveReceivedData) {
        _haveReceivedData = [NSMutableData data];
    }
    return _haveReceivedData;
}

- (dispatch_queue_t)queueSerial {
    if (!_queueSerial) {
        _queueSerial = dispatch_queue_create("net.wyj.comQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _queueSerial;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = CGRectMake(20, 200, 350, 300);
    self.imageView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.imageView];
    
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    button.frame = CGRectMake(20, 20, 100, 45);
    button.layer.borderColor = [UIColor blueColor].CGColor;
    button.layer.borderWidth = 1;
    button.layer.cornerRadius = 5;
    [button setTitle:@"开始下载" forState:(UIControlStateNormal)];
    [button setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(startAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIButton *button2 = [UIButton buttonWithType:(UIButtonTypeSystem)];
    button2.frame = CGRectMake(200, 20, 100, 45);
    button2.layer.borderColor = [UIColor blueColor].CGColor;
    button2.layer.borderWidth = 1;
    button2.layer.cornerRadius = 5;
    [button2 setTitle:@"清除URLcache" forState:(UIControlStateNormal)];
    [button2 setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
    [self.view addSubview:button2];
    [button2 addTarget:self action:@selector(cashAction) forControlEvents:(UIControlEventTouchUpInside)];
}

// http://c.hiphotos.baidu.com/zhidao/pic/item/7aec54e736d12f2e0bd5528c48c2d5628435680e.jpg
// http://lc-snkarza7.cn-n1.lcfile.com/6cb7656be138b3c3bc05/cutMiddle.png (比较大的 内存没有减少 不如绘制的)
- (NSURL *)url {
    return [NSURL URLWithString:@"http://lc-snkarza7.cn-n1.lcfile.com/6cb7656be138b3c3bc05/cutMiddle.png"];
}

- (void)cashAction {
    NSURLCache *cache = [NSURLCache sharedURLCache];
    NSURLRequest * request = [NSURLRequest requestWithURL:[self url]];
    [cache removeCachedResponseForRequest:request];
}

- (void)startAction{
    
    self.haveReceivedData = nil;
    self.imageView.image = nil;
    //创建NSURLSession对象，代理方法在self(控制器)执行，代理方法队列传的nil，表示和下载在一个队列里，也就是在子线程中执行。
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    
    //    NSURLRequest *request = [NSURLRequest requestWithURL:[self url] cachePolicy:(NSURLRequestReloadIgnoringLocalCacheData) timeoutInterval:0];
    //    NSURLSessionDataTask *task = [session dataTaskWithRequest:request];
    
    //    //创建一个dataTask任务 url默认会缓存
    NSURLSessionDataTask *task = [session dataTaskWithURL:[self url]];
    
    //启动任务
    [task resume];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    dispatch_async(self.queueSerial, ^{
        [self receiveDataDataTask:dataTask didReceiveData:data];
        //        sleep(1);
        usleep(300 *1000); //和sleep一样 以微妙为单位
    });
}

// 接受到data后的处理 //这样的方式并不能减少内存 反而比直接本地加载更大 所以需要实现一点一点读取数据然后绘制
- (void)receiveDataDataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data  {
    
    //存储已经下载的图片二进制数据。
    [self.haveReceivedData appendData:data];
    
    //总共需要下载的图片数据的大小。
    int64_t totalSize = dataTask.countOfBytesExpectedToReceive;
    
    //创建一个递增的ImageSource，一般传NULL。
    CGImageSourceRef imageSource = CGImageSourceCreateIncremental(NULL);
    
    //使用最新的数据更新递增的ImageSource，第二个参数是已经接收到的Data，第三个参数表示是否已经是最后一个Data了。
    CGImageSourceUpdateData(imageSource, (__bridge CFDataRef)self.haveReceivedData, totalSize == self.haveReceivedData.length);
    
    //通过关联到ImageSource上的Data来创建一个CGImage对象，第一个参数传入更新数据之后的imageSource；第二个参数是图片的索引，一般传0；第三个参数跟创建的时候一样，传NULL就行。
    CGImageRef image = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
    
    //释放创建的CGImageSourceRef对象
    CFRelease(imageSource);
    
    //在主线程中更新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        //其实可以直接把CGImageRef对象赋值给layer的contents属性，翻开苹果的头文件看就知道，
        //一个UIView之所以能显示内容，就是因为CALayer的原因，而CALayer显示内容的属性就是contents，而contents通常就是CGImageRef。
        //self.imageView.layer.contents = (__bridge id _Nullable)(image);
        self.imageView.image = [UIImage imageWithCGImage:image];
        
        //释放创建的CGImageRef对象
        CGImageRelease(image);
    });
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self logCacheResponse];
}

// 打印缓存的大小
- (void)logCacheResponse {
    //    self.imageView.image = [UIImage imageNamed:@"cutMiddle"];
    NSLog(@"数据大小：%f",self.haveReceivedData.length /1024.0); // 304.449 KB
    
    NSURLCache *cache = [NSURLCache sharedURLCache];
    NSURLRequest * request = [NSURLRequest requestWithURL:[self url]];
    NSCachedURLResponse *cachedResponse = [cache cachedResponseForRequest:request];
    
    NSLog(@"响应头： %@",cachedResponse.response);
    NSLog(@"响应体大小%f", cachedResponse.data.length / 1024.0);
    NSLog(@"响应体： %@",cachedResponse.data);
}

@end

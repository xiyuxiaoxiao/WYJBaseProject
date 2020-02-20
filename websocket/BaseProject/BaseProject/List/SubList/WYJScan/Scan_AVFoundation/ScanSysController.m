//
//  ScanSysController.m
//  BaseProject
//
//  Created by ZSXJ on 2017/8/17.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "ScanSysController.h"
#import "ScanSystem.h"
@interface ScanSysController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@end

@implementation ScanSysController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)scanSystemAction {
    ScanSystem *vc = [[ScanSystem alloc] init];
    vc.responseQR = ^(NSString *str) {
        self.resultLabel.text = str;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

// 相册读取二维码
- (IBAction)photoAlbumQR {
    if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypePhotoLibrary)]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.delegate = self;
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:controller animated:YES completion:NULL];
    }else {
        // 不支持相册
        self.resultLabel.text = @"不支持相册";
    }
}

// 目前  CIDetector 只支持读取二维码
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    //1.获取选择的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    //2.初始化一个监测器
    CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        //监测到的结果数组
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        if (features.count >=1) {
            /**结果对象 */
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            self.resultLabel.text = feature.messageString;
        }else{
            self.resultLabel.text = @"该图片没有包含一个二维码！";
        }
    }];
}

@end

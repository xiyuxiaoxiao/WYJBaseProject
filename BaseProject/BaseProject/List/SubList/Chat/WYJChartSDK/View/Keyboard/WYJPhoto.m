//
//  WYJPhoto.m
//  BaseProject
//
//  Created by ZSXJ on 2019/1/31.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import "WYJPhoto.h"
#import <Photos/Photos.h>

@interface WYJPhoto ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, copy)     void (^backBlc)(UIImage *image);

@end

static WYJPhoto *StaticPhoto = nil;

@implementation WYJPhoto
+ (void)getPhoto: (void (^)(UIImage *img))backBlc {
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        // 没有权限访问
        // 没有权限访问相册
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无权限访问相册" message:@"请前往 设置-隐私-照片 进行设置" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:action];
        
        [[self getCurrentVC] presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    

    
    
    WYJPhoto *photo = [[WYJPhoto alloc] init];
    photo.backBlc = backBlc;
    StaticPhoto = nil;
    StaticPhoto = photo;
    [photo getPhoto];
}

- (void)getPhoto {
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
    pickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerVC.delegate = self;
    
    [[self.class getCurrentVC] presentViewController:pickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    self.backBlc(image);
    
    StaticPhoto = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    StaticPhoto = nil;
    [picker dismissViewControllerAnimated:YES completion:nil];
}




+ (UIViewController *)getCurrentVC {
    
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

@end

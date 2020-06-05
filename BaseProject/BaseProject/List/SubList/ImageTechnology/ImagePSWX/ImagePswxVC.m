//
//  ImagePswxVC.m
//  BaseProject
//
//  Created by ZSXJ on 2020/5/19.
//  Copyright © 2020 WYJ. All rights reserved.
//

#import "ImagePswxVC.h"
#import "WYJPhoto.h"

@interface ImagePswxVC ()
@property (nonatomic, strong) UIImage *source_image;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

@end

@implementation ImagePswxVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}

- (IBAction)createdNewImageAction {
//    UIImage *image = [self addImage:self.source_image logo:[UIImage imageNamed:@"yuanyuan"]];
//    self.imageView.image = image;
    
    self.imageView.image = [self createdImageWithView:self.timeLabel];
}
- (IBAction)selectImageAction {
    [WYJPhoto getPhoto:^(UIImage * _Nonnull img) {
        self.source_image = img;
        self.imageView.image = self.source_image;
    }];
}

- (UIImage *)addImage:(UIImage *)img logo:(UIImage *)logo{
    int w = img.size.width;
    int h = img.size.height;
    int logoWidth = logo.size.width;
    int logoHeight = logo.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    //create a graphic context with CGBitmapContextCreate
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGContextDrawImage(context, CGRectMake(w-logoWidth, 0, logoWidth, logoHeight), [logo CGImage]);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return [UIImage imageWithCGImage:imageMasked];
}

- (UIImage *)createdImageWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        [view.layer renderInContext:ctx];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    return newImage;
}

@end

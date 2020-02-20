//
//  CustomAnnotationView.m
//  CustomAnnotationDemo
//
//  Created by songjian on 13-3-11.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "CustomAnnotationView.h"
#import "CustomCalloutView.h"
#import "PortraitArrowView.h"
#define kWidth  150.f
#define kHeight 40.f

#define kHoriMargin 5.f
#define kVertMargin 5.f

#define kPortraitWidth  30.f
#define kPortraitHeight 30.f

#define kCalloutWidth   200.0
#define kCalloutHeight  70.0

@interface CustomAnnotationView ()

@property (nonatomic, strong) UILabel *platformLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *orderLabel;
@property (nonatomic, strong) PortraitArrowView *portraitArrowView;
@end

@implementation CustomAnnotationView

@synthesize calloutView;

#pragma mark - Handle Action

- (void)btnAction
{
    CLLocationCoordinate2D coorinate = [self.annotation coordinate];
    
    NSLog(@"coordinate = {%f, %f}", coorinate.latitude, coorinate.longitude);
    
    NSLog(@"%@",self.orderInfo);
}

#pragma mark - Override

- (void)setOrderInfo:(NSDictionary *)orderInfo {
    _orderInfo = orderInfo;
    
    self.platformLabel.text  = _orderInfo[@"platform"];
    self.statusLabel.text    = _orderInfo[@"status"];;
    self.orderLabel.text     = [NSString stringWithFormat:@"订单号:%@",_orderInfo[@"trade_no"]];
    
    self.portraitArrowView.image = [UIImage imageNamed:orderInfo[@"portraitName"]];
    self.portraitArrowView.name = orderInfo[@"name"];
}

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        if (self.calloutView == nil)
        {
            /* Construct custom callout. */
            self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
            

            UILabel *platformLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth-50, 40)];
            platformLabel.textColor = [UIColor whiteColor];
            platformLabel.font = [UIFont systemFontOfSize:15];
            [self.calloutView addSubview:platformLabel];
            
            
            UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCalloutWidth-50, 0, 50, 40)];
            statusLabel.textColor = [UIColor whiteColor];
            statusLabel.font = [UIFont systemFontOfSize:15];
            [self.calloutView addSubview:statusLabel];
            
            
            UILabel *orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kCalloutHeight - 40, kCalloutWidth, 30)];
            orderLabel.textColor = [UIColor whiteColor];
            orderLabel.font = [UIFont systemFontOfSize:15];
            orderLabel.minimumScaleFactor = 0.1;
            orderLabel.adjustsFontSizeToFitWidth = YES;
            [self.calloutView addSubview:orderLabel];
            
            
            
            platformLabel.text  = self.orderInfo[@"platform"];
            statusLabel.text    = self.orderInfo[@"status"];;
            orderLabel.text     = [NSString stringWithFormat:@"订单号:%@",self.orderInfo[@"trade_no"]];
            
            self.platformLabel  = platformLabel;
            self.statusLabel    = statusLabel;
            self.orderLabel     = orderLabel;
            
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.frame = CGRectMake(0, 0, kCalloutWidth, kCalloutHeight);
            [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
            
            [self.calloutView addSubview:btn];
        }
        
        [self addSubview:self.calloutView];
    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{

    BOOL inside = [super pointInside:point withEvent:event];
    /* Points that lie outside the receiver’s bounds are never reported as hits,
     even if they actually lie within one of the receiver’s subviews.
     This can occur if the current view’s clipsToBounds property is set to NO and the affected subview extends beyond the view’s bounds.
     */
    if (!inside && self.selected)
    {
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    
    return inside;
}

#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.bounds = CGRectMake(0.f, 0.f, 50, 100);
        PortraitArrowView *view = [[PortraitArrowView alloc] initWithFrame:CGRectMake(1, 1, 48, 98)];
        view.userInteractionEnabled = NO;
        [self addSubview:view];
        self.portraitArrowView = view;
    }
    
    return self;
}

@end

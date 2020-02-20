//
//  AnimationRead.m
//  BaseProject
//
//  Created by ZSXJ on 2018/12/20.
//  Copyright © 2018年 WYJ. All rights reserved.
//
@interface AnimationRead : NSObject
@end

@implementation AnimationRead


//详细的核心动画
//http://www.cocoachina.com/ios/20170623/19612.html

/*
    Core Animation
 
 CABasicAnimation(基础动画)
 CAKeyframeAnimation(帧动画)
 CAAnimationGroup(动画组)
 CATransition(过度动画)
 
 还有其他的 只是自己不常用

 */


/*
 
CABasicAnimation(基础动画)

    fromValue: keyPath 相应属性的初始值
    toValue:   keyPath 相应属性的结束值

    动画过程说明:
    随着动画的进行,在长度为duration的持续时间内,keyPath相应属性的值从fromValue渐渐地变为toValue
    keyPath内容是CALayer的可动画Animatable属性
    如果fillMode=kCAFillModeForwards同时removedOnComletion=NO,那么在动画执行完毕后,图层会保持显示动画执行后的状态。但在实质上,图层的属性值还是动画执行前的初始值,并没有真正被改变。
 
 */

/*
 
 CAKeyframeAnimation(帧动画)
 
     CABasicAnimation只能从一个数值(fromValue)变到另一个数值(toValue),而CAKeyframeAnimation会使用一个NSArray保存这些数值
     values:
            上述的NSArray对象。里面的元素称为“关键帧”(keyframe)。动画对象会在指定的时间(duration)内,依次显示values数组中的每一个关键帧
     path:
            可以设置一个CGPathRef、CGMutablePathRef,让图层按照路径轨迹移动。path只对CALayer的anchorPoint和position起作用。如果设置了path,那么values将被忽略
     keyTimes:
            可以为对应的关键帧指定对应的时间点,其取值范围为0到1.0,keyTimes中的每一个时间值都对应values中的每一帧。如果没有设置keyTimes,各个关键帧的时间是平分的
 
 */

/*
 
 CAAnimationGroup(动画组)
        动画组,是CAAnimation的子类,可以保存一组动画对象,将CAAnimationGroup对象加入层后,
    组中所有动画对象可以同时并发运行
    nimations:  用来保存一组动画对象的NSArray
                默认情况下,一组动画对象是同时运行的,也可以通过设置动画对象的beginTime属性来更改动画的开始时间
 
 */

/*
 CATransition(过度动画)
     type:          动画过渡类型
     subtype:       动画过渡方向
     startProgress: 动画起点(在整体动画的百分比)
     endProgress:   动画终点(在整体动画的百分比)
 */

MakeSourcePath
@end

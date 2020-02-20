//
//  RuntimePoint.m
//  BaseProject
//
//  Created by ZSXJ on 2018/12/20.
//  Copyright © 2018年 WYJ. All rights reserved.
//
@interface RuntimePoint : NSObject
@end

@implementation RuntimePoint

/*
 1）消息机制  同一个控制器中
 2）方法交换 Method Swizzling
        1. 对动画push修改 有时候会出现连续多次push的结果 导致bug
        2. 添加眼睛登录 可以在不同的页面查看当前页面的一些内容接口数据等
        3. tableViewd默认占位图片
        4. 导航栏隐藏变换 （跨级主要是返回，或者未知的跳转 ） 交互
        5. 埋点 统计页面进入的次数 
        ...
 
 3）动态加载方法      （在没有实现相关方法的时候 会走一个方法 可以在里面动态添加一个方法 或者不添加）
 4）消息转发 NSNull  （在没有实现相关方法的时候，有一个方法，可以在里面设置可以相应相关方法的对象，或者设置为nil）
        1. 对于NSNUll的方法 在最后将targetw对象置为nil
 5）动态关联属性 （字典转模型）
        1. 创建model caretoryi添加属性
 */

MakeSourcePath
@end

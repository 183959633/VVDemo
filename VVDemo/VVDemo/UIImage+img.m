//
//  UIImage+img.m
//  VVDemo
//
//  Created by Jack on 2018/5/10.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "UIImage+img.h"
#import <objc/message.h>
@implementation UIImage (img)
+ (void)load{
    //需要互换的目标方法
    Method imageNamedMethod      = class_getClassMethod(self, @selector(imageNamed:));
    //配合目标互换的自定义方法
    Method jack_imageNamedMethod = class_getClassMethod(self, @selector(jack_imageNamed:));
    
    //利用 runtime 开始交互
    method_exchangeImplementations(imageNamedMethod, jack_imageNamedMethod);
}
+(UIImage*)jack_imageNamed:(NSString*)name{
    UIImage *img = [UIImage jack_imageNamed:name];
    if (img) {
        NSLog(@"runtime 动态互换方法img 写入成功!!!");
    }else{
        NSLog(@"runtime 动态互换方法img 写入失败!!!");
    }
    return img;
}
@end

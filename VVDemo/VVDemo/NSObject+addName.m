//
//  NSObject+addName.m
//  VVDemo
//
//  Created by Jack on 2018/5/10.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "NSObject+addName.h"
#import <objc/runtime.h>
@implementation NSObject (addName)
- (void)setName:(NSString *)name{
    objc_setAssociatedObject(self, @"name", name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)name{
    return objc_getAssociatedObject(self, @"name");
}
@end

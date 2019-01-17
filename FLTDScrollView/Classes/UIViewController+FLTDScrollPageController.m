//
//  UIViewController+FLTDScrollPageController.m
//  test
//
//  Created by 彭煌环 on 2017/9/5.
//  Copyright © 2017年 彭煌环. All rights reserved.
//

#import "UIViewController+FLTDScrollPageController.h"
#import "FLTDScrollPageDelegate.h"
#import <objc/runtime.h>

char FLIndexKey;
@implementation UIViewController (FLTDScrollPageController)
- (UIViewController *)fl_scrollPageController{
    //如果控制器遵守FLTDScrollPageDelegate协议，则是我们要找的控制器，否则向上寻找
    UIViewController *controller = self;
    while (controller) {
        if ([controller conformsToProtocol:@protocol(FLTDScrollPageDelegate)]) {
            break;
        }
        controller = controller.parentViewController;
    }
    return controller;
}

- (NSInteger)fl_currentIndex{
    return [objc_getAssociatedObject(self, &FLIndexKey) integerValue];
}

- (void)setFl_currentIndex:(NSInteger)fl_currentIndex{
    objc_setAssociatedObject(self, &FLIndexKey, @(fl_currentIndex), OBJC_ASSOCIATION_ASSIGN);
}

@end

//
//  UIViewController+FLTDScrollPageController.h
//  test
//
//  Created by 彭煌环 on 2017/9/5.
//  Copyright © 2017年 彭煌环. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (FLTDScrollPageController)

/**
 所有子控制器的父控制器, 方便在每个子控制页面直接获取到父控制器进行其他操作
 */
@property(nonatomic,weak,readonly)UIViewController *fl_scrollPageController;
@property(nonatomic,assign)NSInteger fl_currentIndex;
@end

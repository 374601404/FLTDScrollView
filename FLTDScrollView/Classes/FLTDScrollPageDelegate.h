//
//  FLTDScrollPageDelegate.h
//  test
//
//  Created by 彭煌环 on 2017/8/21.
//  Copyright © 2017年 彭煌环. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FLTDTitle;
@protocol FLTDScrollPageDelegate <NSObject>
/**将要显示子控制器的个数 */
- (NSInteger)numberOfChildViewControllers;

/**
 获取到即将要显示的控制器，可在该方法中进行初始化操作

 @param reuseController 子控制器，应该先判断是否为空，为空则先创建控制器 不为nil直接返回
 @param index 控制器的下标
 @return 子控制器
 */
- (UIViewController *)childViewController:(UIViewController *)reuseController ForIndex:(NSInteger)index;
@optional

/**
 初始化标题时进行个性化设置

 @param titleView the titleview to be customed
 @param index tileview's index
 */
- (void)setupTitleView:(FLTDTitle *)titleView index:(NSInteger)index;


/**
 控制器显示结束

 @param reuseController 子控制器
 @param index 子控制器下标，与标题视图下标保持一致对应
 */
- (void)childViewControllerDidEndDisplay:(UIViewController *)reuseController Forindex:(NSInteger)index;
@end

//
//  FLTDTopSegementView.h
//  test
//
//  Created by 彭煌环 on 2017/8/21.
//  Copyright © 2017年 彭煌环. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLTDScrollPageDelegate.h"
#import "FLTDSegementStyle.h"
#import "FLTDTitle.h"


typedef void(^titleViewOnClickBlock)(FLTDTitle *titleView,NSInteger index);

@interface FLTDTopSegementView : UIView
/**实现FLTDScrollPageDelegate协议代理对象，在这里进行初始化titleView回调
 使用weak管理内存，是避免循环引用
*/
@property(nonatomic,weak)id<FLTDScrollPageDelegate> delegate;
//初始化方法
- (instancetype)initWithFrame:(CGRect)frame segementStyle:(FLTDSegementStyle *)style delegate:(id<FLTDScrollPageDelegate>)delegate titles:(NSArray<NSString *> *)titles titleDidClick:(titleViewOnClickBlock)titleDidClick;
//根据progress调整titleview的位置
- (void)adjustUIWithProgress:(CGFloat)progress OldIndex:(NSInteger)oldIndex CurrentIndex:(NSInteger)currentIndex;
/**contentview滚动完成后，调整titleview的位置*/
- (void)adjustUIToCurrentIndex:(NSInteger)currentIndex;
/** 设置选中的下标*/
- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated;
@end

//
//  FLTDScrollPageView.h
//  test
//
//  Created by 彭煌环 on 2017/9/6.
//  Copyright © 2017年 彭煌环. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLTDSegementStyle.h"
#import "FLTDScrollPageDelegate.h"
#import "FLTDTopSegementView.h"
#import "FLTDContentView.h"


@interface FLTDScrollPageView : UIView

@property(strong,nonatomic,readonly)FLTDContentView *contentView;
@property(strong,nonatomic)FLTDTopSegementView *segementView;

/**初始化方法*/
- (instancetype)initWithFrame:(CGRect)frame segementStyle:(FLTDSegementStyle *)segementStyle titles:(NSArray *)titles parentViewController:(UIViewController *)parentViewController delegate:(id<FLTDScrollPageDelegate>)delegate;
/** 设置选中的下标*/
- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated;
@end

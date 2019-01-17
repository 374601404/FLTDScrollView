//
//  FLTDSegementStyle.h
//  test
//
//  Created by 彭煌环 on 2017/8/21.
//  Copyright © 2017年 彭煌环. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FLTDSegementStyle : NSObject
        /**topSegement Style **/
//是否显示滚动条
@property(nonatomic,assign,getter=isShowScrollLine)BOOL isShowScrollLine;
/**title的普通字体*/
@property(nonatomic,strong)UIFont *normalTitleFont;
/**title的选中字体*/
@property(nonatomic,strong)UIFont *selectedTitleFont;
/**标题的高度*/
@property(nonatomic,assign)CGFloat segementViewHeight;
/** 是否滚动标题 默认为YES 设置为NO的时候所有的标题将不会滚动, 并且宽度会平分 和系统的segment效果相似 */
@property(nonatomic,assign,getter=isScrollTitle)BOOL isScrollTitle;
//标题之间的间距
@property(nonatomic,assign)CGFloat titleMargin;
//标题一般状态颜色
@property(nonatomic,strong)UIColor *normalTitleColor;
//标题选中状态颜色
@property(nonatomic,strong)UIColor *selectedTitleColor;
//滚动条的颜色
@property(nonatomic,strong)UIColor *scrollLineColor;
//滚动条的圆角
@property(nonatomic,assign)CGFloat scrollLineraduis;
//滚动条的高度
@property(nonatomic,assign)CGFloat scrollLineHeight;
//滚动条宽度 (相对文字居中)
@property(nonatomic,assign)CGFloat scrollLineWidth;
//滚动条上间距
@property(nonatomic,assign)CGFloat scrollLineTop;
//滚动条下间距
@property(nonatomic,assign)CGFloat scrollLineBottom;
/**是否让标题栏的背景色渐变*/
@property(nonatomic,assign)BOOL isSegementViewGradualColor;
/**isSegementViewGradualColor为YES，再设置左边起始颜色*/
@property(nonatomic,strong)NSString *leftSegementViewColor;
/**isSegementViewGradualColor为YEs，再设置右边结束颜色*/
@property(nonatomic,strong)NSString *rightSegementViewColor;
/* contentview bounces property*/
@property(nonatomic,assign)BOOL contentScrollViewBounces;

@end

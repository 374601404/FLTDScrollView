//
//  FLTDTitle.h
//  test
//
//  Created by 彭煌环 on 2017/8/21.
//  Copyright © 2017年 彭煌环. All rights reserved.
//

#import <UIKit/UIKit.h>

//滚动的title view
@interface FLTDTitle : UIView
//title的文字相关属性
@property(nonatomic,strong)NSString *text;
@property(nonatomic,strong)UIColor *color;
@property(nonatomic,strong)UIFont *font;
@property(nonatomic,assign,getter=isSelected)BOOL isSelected;//是否被选中
@property(nonatomic,strong,readonly)UILabel *label;//文字Label，只读属性
- (CGFloat)titleWidth;
@end

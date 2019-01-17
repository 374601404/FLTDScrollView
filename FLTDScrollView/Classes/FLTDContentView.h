//
//  FLTDContentView.h
//  test
//
//  Created by 彭煌环 on 2017/9/1.
//  Copyright © 2017年 彭煌环. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLTDTopSegementView.h"
#import "FLTDCollectionView.h"

@interface FLTDContentView : UIView

/**代理对象*/
@property(nonatomic,weak)id<FLTDScrollPageDelegate> delegate;
/**CollectionView*/
@property(nonatomic,strong,readonly)FLTDCollectionView *collectionView;

/**初始化方法*/
- (instancetype)initWithFrame:(CGRect)frame segementStyle:(FLTDSegementStyle *)style segementView:(FLTDTopSegementView *)segementView parentViewController:(UIViewController *)parentViewController delegate:(id<FLTDScrollPageDelegate>)delegate;
/**设置contentoffset的方法*/
- (void)setContentOffset:(CGPoint)offset animated:(BOOL)animated;
@end

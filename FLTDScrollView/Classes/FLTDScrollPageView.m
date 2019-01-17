//
//  FLTDScrollPageView.m
//  test
//
//  Created by 彭煌环 on 2017/9/6.
//  Copyright © 2017年 彭煌环. All rights reserved.
//

#import "FLTDScrollPageView.h"

@interface FLTDScrollPageView()

@property(strong,nonatomic)FLTDContentView *contentView;
@property(strong,nonatomic)FLTDSegementStyle *style;
//weak 避免循环引用
@property(weak,nonatomic)UIViewController *parentViewController;
@property(weak,nonatomic)id<FLTDScrollPageDelegate> delegate;
@property(strong,nonatomic)NSArray *titleArray;

@end

@implementation FLTDScrollPageView

- (instancetype)initWithFrame:(CGRect)frame segementStyle:(FLTDSegementStyle *)segementStyle titles:(NSArray *)titles parentViewController:(UIViewController *)parentViewController delegate:(id<FLTDScrollPageDelegate>)delegate{
    if (self = [super initWithFrame:frame]) {
        _style = segementStyle;
        _delegate = delegate;
        _parentViewController = parentViewController;
        _titleArray = titles.copy;
        [self addSubview:self.segementView];
        [self addSubview:self.contentView];
    }
    
    return self;
}

- (FLTDTopSegementView *)segementView{
    if (!_segementView) {
        __weak typeof(self) weakSelf = self;
        FLTDTopSegementView *segementView = [[FLTDTopSegementView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.style.segementViewHeight) segementStyle:_style delegate:_delegate titles:_titleArray titleDidClick:^(FLTDTitle *titleView, NSInteger index) {
            [weakSelf.contentView setContentOffset:CGPointMake(weakSelf.contentView.bounds.size.width * index, 0.0)  animated:YES];
        }];
        _segementView = segementView;
    }
    return _segementView;
}

- (FLTDContentView *)contentView{
    if (!_contentView) {
        FLTDContentView *view = [[FLTDContentView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segementView.frame), self.bounds.size.width, self.bounds.size.height - self.style.segementViewHeight) segementStyle:_style segementView:self.segementView parentViewController:self.parentViewController delegate:self.delegate];
        _contentView = view;
    }
    return _contentView;
}

#pragma mark public helper
/** 设置选中的下标*/
- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated{
    if (index < 0 || index >= self.titleArray.count) {
        return;
    }
    [self.segementView setSelectedIndex:index animated:YES];
}

@end

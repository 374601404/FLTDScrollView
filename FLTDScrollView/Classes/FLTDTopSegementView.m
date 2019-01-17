//
//  FLTDTopSegementView.m
//  test
//
//  Created by 彭煌环 on 2017/8/21.
//  Copyright © 2017年 彭煌环. All rights reserved.
//

#import "FLTDTopSegementView.h"


@interface FLTDTopSegementView()<UIScrollViewDelegate>{
    CGFloat _scrollViewW;
    CGFloat _scrollViewH;
    NSInteger _oldIndex;//之前选中的titleview下标
    NSInteger _currentIndex;//当前选中的titleview下标
}
@property(nonatomic,strong)UIView *scrollLine;//滚动条
@property(nonatomic,strong)UIView *coverView;//遮盖
@property(nonatomic,strong)UIScrollView *scrollView;//滑动视图
@property(nonatomic,strong)NSArray<NSString *> *titles;//缓存标题文字
@property(nonatomic,strong)NSMutableArray<FLTDTitle *> *titleViews;//标题视图
@property(nonatomic,strong)NSMutableArray *titleWidthArr;//标题宽度
@property(nonatomic,strong)FLTDSegementStyle *style;//style
@property(nonatomic, copy)titleViewOnClickBlock titleDidClick;//titleview被点击会回调代码块
/**处理颜色渐变*/
@property(nonatomic,strong)NSArray *normalColorRGBA;
@property(nonatomic,strong)NSArray *selectedColorRGBA;
@property(nonatomic,strong)NSArray *differenceRGBA;
@end

static CGFloat contentSizeOffX = 0;
@implementation FLTDTopSegementView

- (instancetype)initWithFrame:(CGRect)frame segementStyle:(FLTDSegementStyle *)style delegate:(id<FLTDScrollPageDelegate>)delegate titles:(NSArray<NSString *> *)titles titleDidClick:(titleViewOnClickBlock)titleDidClick{
    if (self = [super initWithFrame:frame]) {
        _oldIndex = -1;
        _currentIndex = 0;
        _style = style;
        _delegate = delegate;
        _titles = titles;
        _scrollViewH = frame.size.height;
        _scrollViewW = frame.size.width;
        _oldIndex = 0;
        _currentIndex = 0;
        _titleDidClick = titleDidClick;
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    [self setupSubViews];
    [self setupUIFrame];
    if (self.style.isSegementViewGradualColor) {
        CAGradientLayer *gradientLayer = [self getGradientLayerWithLeftColor:self.style.leftSegementViewColor rightColor:self.style.rightSegementViewColor];
        gradientLayer.frame = self.scrollView.bounds;
        [self.scrollView.layer insertSublayer:gradientLayer atIndex:0];
    }else{
        self.scrollView.backgroundColor = [UIColor whiteColor];
    }
}

#pragma mark setup operation
//1、初始化视图
- (void)setupSubViews{
    [self addSubview:self.scrollView];
    [self addPreferredStyleView];
    [self setupTitles];
}

//根据设置添加喜欢的效果   滚动条还是遮盖
- (void)addPreferredStyleView{
    if (_style.isShowScrollLine) {
       [self.scrollView addSubview:self.scrollLine];
    }
    
}

//初始化标题视图
- (void)setupTitles{
    if ([_titles count] == 0) {
        return;
    }
    NSInteger index = 0;
    for(NSString *title in _titles){
        FLTDTitle *titleView = [[FLTDTitle alloc] initWithFrame:CGRectZero];
        titleView.tag = index;
        titleView.font = _style.normalTitleFont;
        titleView.color = _style.normalTitleColor;
        titleView.text = title;
        //这样回调代理方法才是安全的
        if (self.delegate && [self.delegate respondsToSelector:@selector(setupTitleView:index:)]) {
            [self.delegate setupTitleView:titleView index:index];//初始化titleView
        }
        //添加点击手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleViewOnclick:)];
        [titleView addGestureRecognizer:tapGesture];
        [self.titleViews addObject:titleView];
        [self.titleWidthArr addObject:@(titleView.titleWidth)];//@()转换为对象
        [self.scrollView addSubview:titleView];
        index++;
    }
}



//2、初始化视图的位置  给ScrollView、titleView Frame  scrollLine和Cover
- (void)setupUIFrame{
    if (self.titles.count == 0) {
        return;
    }
    [self setupScrollViewPosition];
    [self setupTitleViewsPosition];
    [self setupScrollLineAndCoverPosition];
    if (_style.isScrollTitle) {
        contentSizeOffX = _style.titleMargin;
        FLTDTitle *lastTitleView = [self.titleViews lastObject];
        if (lastTitleView) {
           self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastTitleView.frame) + _style.titleMargin, 0.0);
        }
    }
}


- (void)setupScrollViewPosition{
    self.scrollView.frame = CGRectMake(0.0, 0.0, _scrollViewW, _scrollViewH);
}

- (void)setupTitleViewsPosition{
    CGFloat titleX = 0;
    CGFloat titleY = 0;
    CGFloat titleW = 0;
    CGFloat titleH = _scrollViewH;
    if (!_style.isScrollTitle){
        //所有的titleView平分宽度
        NSInteger index = 0;
        titleW = _scrollViewW/self.titles.count;
        for(FLTDTitle *titleView in self.titleViews){
            titleView.frame = CGRectMake(titleW * index, titleY, titleW, titleH);
            titleView.label.center = titleView.center;
        }
        
    }else{
        /**
         固定titleView宽度，居中显示
         在title不足以占满整个屏幕的时候，将所有title展示在中央位置,先计算出所有title所占的宽度，加上间距
         然后用scrollView的宽度减去该计算所得宽度的结果 除以2 为起点
         */
        CGFloat titlesW = 0;
        for(FLTDTitle *titleView in _titleViews){
            titlesW += [titleView titleWidth];//计算标题宽度
        }
        titlesW += _style.titleMargin * (_titleViews.count + 1);//加上标题间距
        if (titlesW <= _scrollViewW){
            //标题的宽度小于ScrollView
            titleX = (_scrollViewW - titlesW) / 2 + _style.titleMargin;//起点
            for(FLTDTitle *titleView in _titleViews){
                titleW = titleView.titleWidth;
                titleView.frame = CGRectMake(titleX, titleY, titleW, titleH);
                titleX += titleView.titleWidth + _style.titleMargin;
                titleView.label.center = titleView.center;
            }
        }else{
            titleX = _style.titleMargin;
            for(FLTDTitle *titleView in _titleViews){
                titleW = titleView.titleWidth;
                titleView.frame = CGRectMake(titleX, titleY, titleW, titleH);
                titleX += titleView.titleWidth + _style.titleMargin;
                titleView.label.center = titleView.center;
            }
        }
    }
}

- (void)setupScrollLineAndCoverPosition{
    //初始位于第一个titleView下面
    FLTDTitle *firstTitleView = self.titleViews[0];
    CGFloat extraX = firstTitleView.frame.origin.x;
    CGFloat extraW = _style.scrollLineWidth;
    CGFloat extraY = _scrollViewH - _style.scrollLineHeight - _style.scrollLineBottom;
    CGFloat extraH = _style.scrollLineHeight;
    //滚动条
    if (self.scrollLine) {
        if (_style.scrollLineWidth != 0) {
           extraX += (firstTitleView.titleWidth - _style.scrollLineWidth)/2;
        }
        self.scrollLine.frame = CGRectMake(extraX, extraY, extraW, extraH);
    }
    //遮盖
    if (self.coverView) {
        
    }
    
}

#pragma mark lazy-load component
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = NO;
        _scrollView.bounces = YES;//默认允许bounces
        _scrollView.scrollsToTop = NO;//点击状态栏不返回顶部
        _scrollView.delegate = self;
    }
    return  _scrollView;
}

//需要定制scrollLine 的颜色  宽度  是否显示  scrollLine
- (UIView *)scrollLine{
    if (!_style.isShowScrollLine) {
        return nil;
    }
    if (!_scrollLine) {
        _scrollLine = [[UIView alloc] init];
        _scrollLine.layer.cornerRadius = 2;
        _scrollLine.backgroundColor = _style.scrollLineColor;
    }
    return _scrollLine;
}


- (NSMutableArray<FLTDTitle *> *)titleViews{
    if (!_titleViews) {
        _titleViews = [[NSMutableArray alloc] init];
    }
    return _titleViews;
}

- (NSMutableArray *)titleWidthArr{
    if (!_titleWidthArr) {
        _titleWidthArr = [[NSMutableArray alloc] init];
    }
    return _titleWidthArr;
}

- (NSArray *)normalColorRGBA{
    if (!_normalColorRGBA) {
        _normalColorRGBA = [self getRGBAColor:_style.normalTitleColor];
    }
    return _normalColorRGBA;
}

- (NSArray *)selectedColorRGBA{
    if (!_selectedColorRGBA) {
        _selectedColorRGBA = [self getRGBAColor:_style.selectedTitleColor];
    }
    return _selectedColorRGBA;
}

- (NSArray *)differenceRGBA{
    if (!_differenceRGBA) {
        if (self.normalColorRGBA && self.selectedColorRGBA) {
            CGFloat differenceR = [_normalColorRGBA[0] floatValue] - [_selectedColorRGBA[0] floatValue];
            CGFloat differenceG = [_normalColorRGBA[1] floatValue] - [_selectedColorRGBA[1] floatValue];
            CGFloat differenceB = [_normalColorRGBA[2] floatValue] - [_selectedColorRGBA[2] floatValue];
            CGFloat differenceA = [_normalColorRGBA[3] floatValue] - [_selectedColorRGBA[3] floatValue];
            _differenceRGBA = [NSArray arrayWithObjects:@(differenceR),@(differenceG),@(differenceB),@(differenceA), nil];
        }
    }
    return _differenceRGBA;
}

- (NSArray *)getRGBAColor:(UIColor *)color{
    CGFloat numOfcomponents = CGColorGetNumberOfComponents(color.CGColor);
    NSArray *rgbaComponents;
    if (numOfcomponents == 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        rgbaComponents = [NSArray arrayWithObjects:@(components[0]), @(components[1]), @(components[2]), @(components[3]), nil];
    } else{
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        rgbaComponents = [NSArray arrayWithObjects:@(components[0]), @(components[0]), @(components[0]), @(components[1]), nil];
    }
    return rgbaComponents;
}

#pragma mark private helper
- (void)titleViewOnclick:(UITapGestureRecognizer *)tapGuesture{
    FLTDTitle *currentTitleView = (FLTDTitle *)tapGuesture.view;
    if (!currentTitleView) {
        return;
    }
    _currentIndex = currentTitleView.tag;
    [self adjustUIWhenTitleClickedWithAnimated:YES taped:YES];
}

// 获取渐变蓝色图层
- (CAGradientLayer *)getGradientLayerWithLeftColor:(NSString *)leftColor rightColor:(NSString *)rightColor{
    if (!leftColor || !rightColor) {
        leftColor = @"FFFFFF";
        rightColor = @"FFFFFF";
    }
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    
    gradientLayer.colors = @[(id)[self fltd_colorWithHexString:leftColor].CGColor, (id)[self fltd_colorWithHexString:rightColor].CGColor];
    gradientLayer.locations = @[@0.0, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    return gradientLayer;
}

// 颜色转换三：iOS中十六进制的颜色（以#开头）转换为UIColor
- (UIColor *)fltd_colorWithHexString:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // 判断前缀并剪切掉
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    } else if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    } else if ([cString length] != 6) {
        return [UIColor clearColor];
    }
    
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

//核心方法
#pragma mark public helper
//点击、或者设置选中titleview调整位置
- (void)adjustUIWhenTitleClickedWithAnimated:(BOOL)animated taped:(BOOL)taped{
    if (_oldIndex == _currentIndex && taped) {
        return;
    }
    FLTDTitle *oldTitleView = self.titleViews[_oldIndex];
    FLTDTitle *currentTitleView = self.titleViews[_currentIndex];
    CGFloat animatedTime = animated ? 0.30 : 0.0;
    [UIView animateWithDuration:animatedTime animations:^{
        oldTitleView.color = self.style.normalTitleColor;
        oldTitleView.font = self.style.normalTitleFont;
        currentTitleView.color = self.style.selectedTitleColor;
        currentTitleView.font = self.style.selectedTitleFont;
        if (self.scrollLine) {
            CGFloat scrollLineX = currentTitleView.frame.origin.x + (currentTitleView.titleWidth - self.style.scrollLineWidth)/2;
            self.scrollLine.frame = CGRectMake(scrollLineX, self.scrollLine.frame.origin.y, self.scrollLine.frame.size.width, self.scrollLine.frame.size.height);
        }
    } completion:^(BOOL finished) {
        
    }];
    _oldIndex = _currentIndex;
    //点击title回调 这个很关键
    if (self.titleDidClick) {
        self.titleDidClick(currentTitleView, _currentIndex);
    }
}


//根据progress调整titleview的位置
- (void)adjustUIWithProgress:(CGFloat)progress OldIndex:(NSInteger)oldIndex CurrentIndex:(NSInteger)currentIndex{
    if (oldIndex < 0 || oldIndex >= self.titleViews.count || currentIndex < 0 || currentIndex >= self.titleViews.count) {
        return;
    }
    _oldIndex = currentIndex;
    FLTDTitle *oldTitleView = self.titleViews[oldIndex];
    FLTDTitle *currentTitleView = self.titleViews[currentIndex];
    //这里只是处理了scrollLine的在标题大小不一样的情况
    CGFloat distanceX = currentTitleView.frame.origin.x + (currentTitleView.frame.size.width - self.style.scrollLineWidth)/2 - (oldTitleView.frame.origin.x + (oldTitleView.frame.size.width - self.style.scrollLineWidth)/2);
    //调整titleview的位置
    if (self.scrollLine) {
        CGFloat scrollLineX = oldTitleView.frame.origin.x +(oldTitleView.frame.size.width - self.style.scrollLineWidth)/2 + distanceX * progress;
        self.scrollLine.frame = CGRectMake(scrollLineX, self.scrollLine.frame.origin.y, self.scrollLine.frame.size.width, self.scrollLine.frame.size.height);
    }
    //处理颜色渐变
    oldTitleView.color = [UIColor colorWithRed:
                          [self.selectedColorRGBA[0] floatValue] + [self.differenceRGBA[0] floatValue] * progress
                        green:[self.selectedColorRGBA[1] floatValue] + [self.differenceRGBA[1] floatValue] * progress blue:[self.selectedColorRGBA[2] floatValue] + [self.differenceRGBA[2] floatValue] * progress alpha:[self.selectedColorRGBA[3] floatValue] + [self.differenceRGBA[3] floatValue] * progress];
    currentTitleView.color = [UIColor colorWithRed:
                              [self.normalColorRGBA[0] floatValue] - [self.differenceRGBA[0] floatValue] * progress green:[self.normalColorRGBA[1] floatValue] - [self.differenceRGBA[1] floatValue] * progress blue:[self.normalColorRGBA[2] floatValue] - [self.differenceRGBA[2] floatValue] * progress alpha:[self.normalColorRGBA[3] floatValue] - [self.differenceRGBA[3] floatValue] * progress];
}

//contentview滚动完成后，调整titleview的位置
- (void)adjustUIToCurrentIndex:(NSInteger)currentIndex{
    _oldIndex = currentIndex;
    NSInteger index = 0;
    //处理颜色渐变和缩放（目前没加入缩放功能）
    for(FLTDTitle *titleView in self.titleViews){
        if (index != currentIndex) {
            titleView.color = _style.normalTitleColor;
            titleView.font = _style.normalTitleFont;
        }else{
            titleView.color = _style.selectedTitleColor;
            titleView.font = _style.selectedTitleFont;
        }
        index++;
    }
    //调整ScrollView的contentoffset,显示出被右滑出来的标题
    if (self.scrollView.contentSize.width != self.scrollView.bounds.size.width) {//需要调整scrollview
        FLTDTitle *titleView = self.titleViews[currentIndex];
        CGFloat titleViewMaxX = CGRectGetMaxX(titleView.frame);
        CGFloat offsetX = 0;
        if ((currentIndex - 1) >= 0 && (currentIndex + 1) < self.titleViews.count) {
            if ((titleViewMaxX + 2 * _style.titleMargin + [self.titleViews[currentIndex + 1] titleWidth]) > _scrollViewW) {
                offsetX = titleViewMaxX + 2 * _style.titleMargin + [self.titleViews[currentIndex + 1] titleWidth] - _scrollViewW;
            }
            [self.scrollView setContentOffset:CGPointMake(offsetX, 0.0) animated:YES];
        }
        
    }
    
}

- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated{
    if (index < 0 || index >= self.titles.count) {
        return;
    }
    _currentIndex = index;
    [self adjustUIWhenTitleClickedWithAnimated:YES taped:NO];
}


@end

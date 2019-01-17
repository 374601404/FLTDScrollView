//
//  FLTDContentView.m
//  test
//
//  Created by 彭煌环 on 2017/9/1.
//  Copyright © 2017年 彭煌环. All rights reserved.
//

#import "FLTDContentView.h"
#import "UIViewController+FLTDScrollPageController.h"


@interface FLTDContentView()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSInteger _currentIndex;//当前的cell下标
    NSInteger _oldIndex;//旧的cell下标
    CGFloat _oldOffset;//旧偏移量
}
/**用于处理重用和内容显示的collectionView*/
@property(nonatomic,strong)FLTDCollectionView *collectionView;
/** collectionViewCell的个数，与titleView、自控制器数量保持一致 */
@property(nonatomic,assign)NSInteger itemsCount;
/** 瀑布流布局 */
@property(nonatomic,strong)UICollectionViewFlowLayout *collectionViewLayout;
/**顶部滑动组件  weak!*/
@property(nonatomic,weak)FLTDTopSegementView *segementView;
/**父控制器,weak避免循环引用*/
@property(nonatomic,weak)UIViewController *parentViewController;
/**当前子控制器*/
@property(nonatomic,strong)UIViewController *currentChildVc;
/**字典缓存当前子控制器集合*/
@property(nonatomic,strong)NSMutableDictionary<NSString *,UIViewController *> *childVcDic;
/**是否需要管理子控制器的生命周期方法,YES表示接管子控制器的生命周期回调*/
@property(nonatomic,assign)BOOL needManageChildLifeCycle;
/**设置为YES，即禁止titleview随着内容滚动而调整位置,处理点击titleview这种情况*/
@property(nonatomic,assign)BOOL forbiddenTouchToAdjustTitle;
@end


static NSString * const cellId = @"cellId";
@implementation FLTDContentView


- (instancetype)initWithFrame:(CGRect)frame segementStyle:(FLTDSegementStyle *)style segementView:(FLTDTopSegementView *)segementView parentViewController:(UIViewController *)parentViewController delegate:(id<FLTDScrollPageDelegate>)delegate{
    if (self = [super initWithFrame:frame]) {
        _segementView = segementView;
        _parentViewController = parentViewController;
        _delegate = delegate;
        _needManageChildLifeCycle = ![parentViewController shouldAutomaticallyForwardAppearanceMethods];
        _forbiddenTouchToAdjustTitle = NO;
        [self addSubview:self.collectionView];
        self.collectionView.bounces = style.contentScrollViewBounces;
        [self commonInit];
    }
    return self;
}


- (void)commonInit{
    _oldIndex = -1;
    _currentIndex = 0;
    _oldOffset = 0.0;
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(numberOfChildViewControllers)]) {
            _itemsCount = [_delegate numberOfChildViewControllers];
        }
    }
}

#pragma mark View LifeCycle
- (void)layoutSubviews{
    [super layoutSubviews];
}


#pragma mark UIScrollViewDelegate

/**contentoffset改变 回调*/

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_forbiddenTouchToAdjustTitle || scrollView.contentOffset.x < 0 || scrollView.contentOffset.x > scrollView.contentSize.width - self.bounds.size.width) {
        //非法偏移量
        return;
    }
    CGFloat tempProgress = scrollView.contentOffset.x/self.bounds.size.width;
    NSInteger tempIndex = tempProgress;
    CGFloat progress =  tempProgress - floor(tempProgress);
    CGFloat detailX = scrollView.contentOffset.x - _oldOffset;
    if (detailX > 0) {
        //向左滑 index增加
        if (progress == 0) {
            return;
        }
        _oldIndex = tempIndex;
        _currentIndex = tempIndex + 1;
    } else if(detailX < 0){
        //向右滑  index减少
        progress = 1.0 - progress;
        _oldIndex = tempIndex + 1;
        _currentIndex = tempIndex;
    }else{
            return;
    }
    [self contentViewMoveFromIndex:_oldIndex toIndex:_currentIndex progress:progress];
}

/**手指开始滑动时回调*/
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _forbiddenTouchToAdjustTitle = NO;
    _oldOffset = scrollView.contentOffset.x;
}
/**滑动彻底停下来*/
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger currentIndex = scrollView.contentOffset.x/self.bounds.size.width;
    [self contentViewMoveFromIndex:_oldIndex toIndex:currentIndex progress:1.0];
    [self adjustTitleViewToCurrentIndex:currentIndex];
}

#pragma mark UICollectionViewDataSouce、UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger itemNumber = 0;
    if (collectionView) {
        itemNumber = self.itemsCount;
    }
    return itemNumber;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

//即将要展示某个item时，进行对子控制器的初始化
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    [self setupChinldVcForCell:cell AtIndex:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];//取消collctionviewcell的点击选中效果
    if (_delegate && [_delegate respondsToSelector:@selector(childViewControllerDidEndDisplay:Forindex:)]) {
        UIViewController *controller = nil;
        controller = [self.childVcDic valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        [_delegate childViewControllerDidEndDisplay:controller Forindex:indexPath.row];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];//取消collctionviewcell的点击选中效果
}

//初始化子控制器
- (void)setupChinldVcForCell:(UICollectionViewCell *)cell AtIndex:(NSIndexPath*)indexPath{
    if (_currentIndex != indexPath.row) {
        return;//跳过不显示的中间几页
    }
    _currentChildVc = (UIViewController *)[self.childVcDic valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    if (_delegate && [_delegate respondsToSelector:@selector(childViewController:ForIndex:)]) {
        if (_currentChildVc == nil) {
            _currentChildVc = [_delegate childViewController:nil ForIndex:indexPath.row];
            //设置当前子控制器的下标
            _currentChildVc.fl_currentIndex = indexPath.row;
            //缓存所有的子控制器
            [self.childVcDic setValue:_currentChildVc forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        }else{
            [_delegate childViewController:_currentChildVc ForIndex:indexPath.row];
        }
    }
    //建立子控制器与父控制器的关系
    if (_currentChildVc != self.parentViewController) {
        [self.parentViewController addChildViewController:_currentChildVc];
    }
    _currentChildVc.view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:_currentChildVc.view];
    [_currentChildVc didMoveToParentViewController:_parentViewController];
    //处理子控制器的生命周期方法
//    [self viewWillAppearWithIndex:indexPath.row];
//    [self viewWillDisappearWithIndex:_oldIndex];
}

#pragma mark lazy-load component
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[FLTDCollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.collectionViewLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.scrollsToTop = YES;
        _collectionView.bounces = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        //注册重用的cellID
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellId];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)collectionViewLayout{
    if (!_collectionViewLayout) {
        _collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionViewLayout.itemSize = self.bounds.size;
        _collectionViewLayout.minimumLineSpacing = 0.0;
        _collectionViewLayout.minimumInteritemSpacing = 0.0;
        _collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _collectionViewLayout;
}

- (NSMutableDictionary<NSString *,UIViewController *> *)childVcDic{
    if (!_childVcDic) {
        _childVcDic = [[NSMutableDictionary alloc] init];
    }
    return _childVcDic;
}

#pragma mark private helper
//滑动时，一个页面向另一个页面跳转时调用
- (void)contentViewMoveFromIndex:(NSInteger)oldIndex toIndex:(NSInteger)currentIndex progress:(CGFloat)progress{
    if (self.segementView) {
        [self.segementView adjustUIWithProgress:progress OldIndex:oldIndex CurrentIndex:currentIndex];
    }
}

//滑动完成后，跳转titleview的偏移量
- (void)adjustTitleViewToCurrentIndex:(NSInteger)currentIndex{
    if (self.segementView) {
        [self.segementView adjustUIToCurrentIndex:currentIndex];
    }
}


/**
    写这么多方法是方便可以添加代理协议，代理childVc的生命周期方法,只需要childVc实现协议，并在以下方法分别调用代理方法
 */
- (void)viewWillAppearWithIndex:(NSInteger)index{
    UIViewController<FLTDScrollPageDelegate> *childVc = (UIViewController<FLTDScrollPageDelegate> *)[self.childVcDic valueForKey:[NSString stringWithFormat:@"%ld",index]];
    if (childVc) {
        if (_needManageChildLifeCycle) {
            [childVc beginAppearanceTransition:YES animated:NO];
        }
    }
    
}

- (void)viewDidAppearWithIndex:(NSInteger)index{
    UIViewController<FLTDScrollPageDelegate> *childVc = (UIViewController<FLTDScrollPageDelegate> *)[self.childVcDic valueForKey:[NSString stringWithFormat:@"%ld",index]];
    if (childVc) {
        if (_needManageChildLifeCycle) {
            [childVc endAppearanceTransition];
        }
    }
}

- (void)viewWillDisappearWithIndex:(NSInteger)index{
    UIViewController<FLTDScrollPageDelegate> *childVc = (UIViewController<FLTDScrollPageDelegate> *)[self.childVcDic valueForKey:[NSString stringWithFormat:@"%ld",index]];
    if (childVc) {
        if (_needManageChildLifeCycle) {
            //isAppearing 参数为NO
            [childVc beginAppearanceTransition:NO animated:NO];
        }
    }
}

- (void)viewDidDisappearWithIndex:(NSInteger)index{
    UIViewController<FLTDScrollPageDelegate> *childVc = (UIViewController<FLTDScrollPageDelegate> *)[self.childVcDic valueForKey:[NSString stringWithFormat:@"%ld",index]];
    if (childVc) {
        if (_needManageChildLifeCycle) {
            [childVc endAppearanceTransition];
        }
    }
}

#pragma mark public helper
- (void)setContentOffset:(CGPoint)offset animated:(BOOL)animated{
    _forbiddenTouchToAdjustTitle = YES;//点击事件发生时，禁止标题视图随着滚动
    NSInteger currentIndex = offset.x/self.collectionView.bounds.size.width;
    _oldIndex = _currentIndex;
    _currentIndex = currentIndex;
    [self.collectionView setContentOffset:offset animated:YES];
}

@end

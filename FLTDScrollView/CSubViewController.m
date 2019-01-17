//
//  CSubViewController.m
//  FLTDScrollView
//
//  Created by penghh on 2019/1/16.
//  Copyright © 2019 penghh. All rights reserved.
//

#import "CSubViewController.h"
#import "FLTDScrollPageView.h"
#import "NavigationInteractiveTransition.h"

#define SCREEN_WIDTH            ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT           ([UIScreen mainScreen].bounds.size.height)
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height //状态栏高度

@interface CSubViewController ()<FLTDScrollPageDelegate,UIGestureRecognizerDelegate>

@property(strong, nonatomic) FLTDScrollPageView *pageView;
@property(strong, nonatomic) NSArray *titlesArr;
@property(strong, nonatomic) UIScreenEdgePanGestureRecognizer *popRecognizer;
@property(strong, nonatomic) NavigationInteractiveTransition *navT;

@end

@implementation CSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
//    self.titlesArr = @[@"控制器1",@"控制器2"];
//    FLTDSegementStyle *style = [[FLTDSegementStyle alloc] init];
//    style.segementViewHeight = 44;
//    style.isShowScrollLine = YES;
//    style.scrollLineBottom = 4.f;
//    style.scrollLineColor = [UIColor blueColor];
//    style.scrollLineraduis = 2.f;
//    style.titleMargin = 30.f;
//    style.normalTitleFont = [UIFont systemFontOfSize:17.f];
//    style.selectedTitleFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:17];
//    style.normalTitleColor = [UIColor blackColor];
//    style.selectedTitleColor = [UIColor redColor];
//    _pageView = [[FLTDScrollPageView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusBarHeight) segementStyle:style titles:self.titlesArr parentViewController:self delegate:self];
//    [_pageView setSelectedIndex:0 animated:NO];
//    [self.view addSubview:_pageView];
//
    //适配侧滑回退手势
//    UIGestureRecognizer *gesture = self.navigationController.interactivePopGestureRecognizer;
//    gesture.enabled = NO;
//    UIView *gestureView = gesture.view;
    UIScreenEdgePanGestureRecognizer *popRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(test)];
//    popRecognizer.delegate = self;
//    popRecognizer.maximumNumberOfTouches = 1;
    popRecognizer.edges = UIRectEdgeRight;
    _popRecognizer = popRecognizer;
//    [popRecognizer addTarget:self action:@selector(test)];
//    [gestureView addGestureRecognizer:popRecognizer];
//    [self.view addGestureRecognizer:popRecognizer];
    NavigationInteractiveTransition  *navT = [[NavigationInteractiveTransition alloc] initWithViewController:self.navigationController];
    _navT = navT;
    [popRecognizer addTarget:navT action:@selector(handleControllerPop:)];
    
    
    //创建返回按钮
//    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    leftBtn.frame = CGRectMake(0, 0, 25,25);
//    [leftBtn setBackgroundImage:[UIImage imageNamed:@"yj_common_backstyleOne_normal"] forState:UIControlStateNormal];
//    [leftBtn setBackgroundImage:[UIImage imageNamed:@"yj_common_backstyleOne_selected"] forState:UIControlStateHighlighted];
//    leftBtn.contentMode = UIViewContentModeScaleToFill;
//    [leftBtn addTarget:self action:@selector(leftBarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem * leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];;
//    //创建UIBarButtonSystemItemFixedSpace
//    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    //将宽度设为负值
//    spaceItem.width = -15;
//    //将两个BarButtonItem都返回给NavigationItem
//    self.navigationItem.leftBarButtonItems = @[spaceItem,leftBarBtn];
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)leftBarBtnClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)test{
    NSLog(@"边角被触发");
}

#pragma mark - UIGestureRecognizerDelegate
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    return YES;
//}

#pragma mark - FLTDScrollPageDelegate
- (NSInteger)numberOfChildViewControllers{
    return 2;
}

- (UIViewController *)childViewController:(UIViewController *)reuseController ForIndex:(NSInteger)index{
    UIViewController *childVc = reuseController;
    if (!reuseController) {
        switch (index) {
            case 0:{
                UIViewController *vC = [[UIViewController alloc] init];
                vC.view.backgroundColor = [UIColor grayColor];
                childVc = vC;
                break;
            }
            case 1:{
                UIViewController *vC = [[UIViewController alloc] init];
                vC.view.backgroundColor = [UIColor purpleColor];
                childVc = vC;
                break;
            }
            default:
                break;
        }
    }
    return childVc;
}

@end

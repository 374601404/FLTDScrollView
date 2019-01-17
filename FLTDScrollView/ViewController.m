//
//  ViewController.m
//  FLTDScrollView
//
//  Created by penghh on 2019/1/14.
//  Copyright © 2019 penghh. All rights reserved.
//

#import "ViewController.h"
#import "FLTDScrollPageView.h"
#import "ASubViewController.h"
#import "BSubViewController.h"
//#import <UINavigationController+FDFullscreenPopGesture.h>

#define SCREEN_WIDTH            ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT           ([UIScreen mainScreen].bounds.size.height)
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height //状态栏高度

@interface ViewController ()<FLTDScrollPageDelegate>

@property(strong, nonatomic) FLTDScrollPageView *pageView;
@property(strong, nonatomic) NSArray *titlesArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titlesArr = @[@"A控制器",@"B控制器"];
    FLTDSegementStyle *style = [[FLTDSegementStyle alloc] init];
    style.segementViewHeight = 44;
    style.isShowScrollLine = YES;
    style.scrollLineBottom = 4.f;
    style.scrollLineColor = [UIColor blueColor];
    style.scrollLineraduis = 2.f;
    style.titleMargin = 30.f;
    style.normalTitleFont = [UIFont systemFontOfSize:17.f];
    style.selectedTitleFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:17];
    style.normalTitleColor = [UIColor blackColor];
    style.selectedTitleColor = [UIColor redColor];
    _pageView = [[FLTDScrollPageView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusBarHeight) segementStyle:style titles:self.titlesArr parentViewController:self delegate:self];
    [_pageView setSelectedIndex:0 animated:NO];
    [self.view addSubview:_pageView];
    //开启手势返回
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark - FLTDScrollPageDelegate
- (NSInteger)numberOfChildViewControllers{
    return 2;
}

- (UIViewController *)childViewController:(UIViewController *)reuseController ForIndex:(NSInteger)index{
    UIViewController *childVc = reuseController;
    if (!reuseController) {
        switch (index) {
            case 0:{
                ASubViewController *vC = [[ASubViewController alloc] init];
                childVc = vC;
                break;
            }
            case 1:{
                BSubViewController *vC = [[BSubViewController alloc] init];
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

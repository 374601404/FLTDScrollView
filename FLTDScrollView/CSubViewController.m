//
//  CSubViewController.m
//  FLTDScrollView
//
//  Created by penghh on 2019/1/16.
//  Copyright © 2019 penghh. All rights reserved.
//

#import "CSubViewController.h"
#import "FLTDScrollPageView.h"

#define SCREEN_WIDTH            ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT           ([UIScreen mainScreen].bounds.size.height)
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height //状态栏高度

@interface CSubViewController ()<FLTDScrollPageDelegate>

@property(strong, nonatomic) FLTDScrollPageView *pageView;
@property(strong, nonatomic) NSArray *titlesArr;
@property(strong, nonatomic) UIScreenEdgePanGestureRecognizer *popRecognizer;

@end

@implementation CSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark - UIGestureRecognizerDelegate

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

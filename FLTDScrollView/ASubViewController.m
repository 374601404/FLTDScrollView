//
//  ASubViewController.m
//  FLTDScrollView
//
//  Created by penghh on 2019/1/16.
//  Copyright © 2019 penghh. All rights reserved.
//

#import "ASubViewController.h"
#import "CSubViewController.h"

@interface ASubViewController ()

@end

@implementation ASubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"push" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(200,300, 50, 30);
    [btn addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.borderWidth = 2.f;
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:btn];
}

- (void)pushAction{
    CSubViewController *vC = [[CSubViewController alloc] init];
//    [self.navigationController pushViewController:vC animated:YES];
    [self presentViewController:vC animated:YES completion:nil];
}


@end

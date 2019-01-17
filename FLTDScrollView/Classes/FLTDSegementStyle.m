//
//  FLTDSegementStyle.m
//  test
//
//  Created by 彭煌环 on 2017/8/21.
//  Copyright © 2017年 彭煌环. All rights reserved.
//

#import "FLTDSegementStyle.h"

@implementation FLTDSegementStyle

- (instancetype)init{
    if (self = [super init]) {
        self.isScrollTitle = YES;//默认为YES
        self.segementViewHeight = 44;
        //颜色0xFFFFFF
        self.scrollLineColor = [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:1.f];
        self.scrollLineWidth = 24;
        self.scrollLineHeight = 3;
        self.isScrollTitle = YES;
    }

    return self;
}
@end

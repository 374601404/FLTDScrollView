//
//  FLTDTitle.m
//  test
//
//  Created by 彭煌环 on 2017/8/21.
//  Copyright © 2017年 彭煌环. All rights reserved.
//

#import "FLTDTitle.h"

@interface FLTDTitle(){
    CGSize titleSize;
}
@property(nonatomic,strong)UIImageView *imageView;//图片视图
@property(nonatomic,strong)UILabel *label;//文字Label
@end

@implementation FLTDTitle

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.label];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.label.frame = self.bounds;
}

//lazy-load component
- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.textAlignment = NSTextAlignmentCenter;//文字居中对齐
    }
    return _label;
}



//override getter and setter
- (void)setFont:(UIFont *)font{
    if (font) {
        _font = font;
        self.label.font = font;
    }
}

- (void)setText:(NSString *)text{
    if (text) {
        self.label.text = text;
        CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.label.font} context:nil];
        titleSize = rect.size;
    }
}

- (void)setColor:(UIColor *)color{
    if (color) {
        _color = color;
        self.label.textColor = color;
    }
}

#pragma mark pulic helper
- (CGFloat)titleWidth{
    return titleSize.width;
}

@end

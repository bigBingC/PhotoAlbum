//
//  DKAlbumBottomView.m
//  Photo
//
//  Created by 崔冰smile on 2019/10/8.
//  Copyright © 2019 Ziwutong. All rights reserved.
//

#import "DKAlbumBottomView.h"
#import "Masonry.h"

@interface DKAlbumBottomView ()
@property (nonatomic, strong) UIButton *btnLeft;
@property (nonatomic, strong) UIButton *btnRight;
@end

@implementation DKAlbumBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.bgColor = [UIColor blackColor];
        self.leftTitleColor = [UIColor whiteColor];
        self.rightTitleColor = [UIColor whiteColor];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    [self addSubview:self.btnLeft];
    [self addSubview:self.btnRight];
    
    [self.btnLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(15);
    }];
    
    [self.btnRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
}

- (void)setLeftTitle:(NSString *)leftTitle {
    [self.btnLeft setTitle:leftTitle forState:UIControlStateNormal];
}

- (void)setLeftTitleColor:(UIColor *)leftTitleColor {
    [self.btnLeft setTitleColor:leftTitleColor forState:UIControlStateNormal];
}

- (void)setRightTitle:(NSString *)rightTitle {
    [self.btnRight setTitle:rightTitle forState:UIControlStateNormal];
}

- (void)setRightTitleColor:(UIColor *)rightTitleColor {
    [self.btnRight setTitleColor:rightTitleColor forState:UIControlStateNormal];
}

- (void)setBgColor:(UIColor *)bgColor {
    self.backgroundColor = bgColor;
}

#pragma mark - 初始化
- (UIButton *)btnLeft {
    if (!_btnLeft) {
        _btnLeft = [[UIButton alloc] init];
        _btnLeft.titleLabel.font = [UIFont systemFontOfSize:14];
        [_btnLeft setTitle:@"预览" forState:UIControlStateNormal];
    }
    return _btnLeft;
}

- (UIButton *)btnRight {
    if (!_btnRight) {
        _btnRight = [[UIButton alloc] init];
        _btnRight.titleLabel.font = [UIFont systemFontOfSize:14];
        [_btnRight setTitle:@"确定" forState:UIControlStateNormal];
    }
    return _btnRight;
}

@end

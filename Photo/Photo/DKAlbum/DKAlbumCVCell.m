//
//  DKAlbumCVCell.m
//  Photo
//
//  Created by 崔冰smile on 2019/9/28.
//  Copyright © 2019 Ziwutong. All rights reserved.
//

#import "DKAlbumCVCell.h"
#import "DKAlbumTool.h"
#import "Masonry.h"

#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width

@interface DKAlbumCVCell ()
// 相片
@property (nonatomic, strong) UIImageView *photoImageView;
// 选中按钮
@property (nonatomic, strong) UIButton *selectButton;
// 半透明遮罩
@property (nonatomic, strong) UIView *maskView;

@end

@implementation DKAlbumCVCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    [self.contentView addSubview:self.photoImageView];
    [self.contentView addSubview:self.selectButton];
    [self.contentView addSubview:self.maskView];
    
    [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-5);
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)setModel:(DKAlbumModel *)model {
    _model = model;
    [[DKAlbumTool shareInstance] fetchPhotoWithAsset:model.asset imageBlock:^(UIImage * _Nonnull image) {
        self.photoImageView.image = image;
    }];
}

#pragma mark - mehtod
- (void)selectedPhoto {
    // 超过最大选择数量不要把model.isSelec置返，否则会出现异常
    if ([DKAlbumTool shareInstance].selectedNum >= _model.maxSelectedNum) {
        // 超过选择的数量如果点击选中的取消选中状态，否则不可点击
        if (_model.isSelect) {
            _model.isSelect = NO;
        } else {
            NSLog(@"最多选%lu张",(unsigned long)[DKAlbumTool shareInstance].maxSelectNum);
        }
    } else {
        _model.isSelect = !_model.isSelect;
    }
    
    if (_model.isSelect) {
        [self.selectButton setBackgroundImage:[UIImage imageNamed: @"selectbox_select"] forState:UIControlStateNormal];
    } else {
        [self.selectButton setBackgroundImage:nil forState:UIControlStateNormal];
    }
    
    if (self.selectedBlock) {
        self.selectedBlock(_model);
    }
}

#pragma mark - 初始化
- (UIImageView *)photoImageView {
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] init];
    }
    return _photoImageView;
}

- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _selectButton.layer.borderWidth = 1.f;
        _selectButton.layer.cornerRadius = 15;
        _selectButton.layer.masksToBounds = YES;
        [_selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_selectButton addTarget:self action:@selector(selectedPhoto) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.hidden = YES;
    }
    return _maskView;
}
@end

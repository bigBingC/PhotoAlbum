//
//  DKAlbumPreviewView.m
//  Photo
//
//  Created by 崔冰smile on 2019/10/8.
//  Copyright © 2019 Ziwutong. All rights reserved.
//

#import "DKAlbumPreviewView.h"
#import "Masonry.h"
#import "DKAlbumTool.h"

@interface DKAlbumPreviewView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *assetImageView;

@end

@implementation DKAlbumPreviewView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.assetImageView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.assetImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)showImage:(UIImage *)image {
    self.assetImageView.image = image;
    CGFloat imageViewHeight = (self.assetImageView.image.size.height / self.assetImageView.image.size.width * self.scrollView.frame.size.width);
    CGFloat imageViewWidth = self.scrollView.frame.size.width;
    [self.assetImageView setFrame:CGRectMake(0, 0, imageViewWidth, imageViewHeight)];
    [self.assetImageView setCenter:CGPointMake(self.assetImageView.center.x, CGRectGetMidY(self.scrollView.frame))];
}

- (void)setAsset:(PHAsset *)asset {
    _asset = asset;
    __weak typeof(self) weakSelf = self;
    [[DKAlbumTool shareInstance] fetchPhotoWithAsset:asset imageBlock:^(UIImage * _Nonnull image) {
        [weakSelf performSelectorOnMainThread:@selector(showImage:) withObject:image waitUntilDone:YES];
    }];
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.assetImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGSize originalSize = self.scrollView.bounds.size;
    CGSize contentSize = self.scrollView.contentSize;
    CGFloat offsetX = (originalSize.width > contentSize.width) ? (originalSize.width - contentSize.width) : 0;
    CGFloat offsetY = (originalSize.height > contentSize.height) ? (originalSize.height - contentSize.height) : 0;
    self.assetImageView.center = CGPointMake(contentSize.width / 2 + offsetX,(originalSize.height > contentSize.height) ? originalSize.height / 2 : contentSize.height / 2 + offsetY);
}

#pragma mark - 初始化
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setDelegate:self];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setMinimumZoomScale:1.0];
        [_scrollView setMaximumZoomScale:2.0];
    }
    return _scrollView;
}

- (UIImageView *)assetImageView {
    if (!_assetImageView) {
        _assetImageView = [[UIImageView alloc] init];
    }
    return _assetImageView;
}

@end

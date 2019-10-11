//
//  DKAlbumPreviewViewController.m
//  Photo
//
//  Created by 崔冰smile on 2019/9/29.
//  Copyright © 2019 Ziwutong. All rights reserved.
//

#import "DKAlbumPreviewViewController.h"
#import "DKAlbumModel.h"
#import "Masonry.h"
#import "DKAlbumTool.h"
#import "DKAlbumBottomView.h"
#import "DKAlbumPreviewView.h"

#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define ImageHeight [[UIScreen mainScreen] bounds].size.height - 108

@interface DKAlbumPreviewViewController () <UIScrollViewDelegate>
@property (nonatomic ,retain) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *navBarView;
@property (nonatomic, strong) DKAlbumBottomView *bottomView;
@end

@implementation DKAlbumPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createBaseView];
}

- (void)createBaseView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.hidden = YES;
    
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat navContentHeight = 44;
    CGFloat navH = statusBarHeight + navContentHeight;
    [self.view addSubview:self.navBarView];
    [self.navBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(navH);
    }];
    
    UIButton *btnBack = ({
        UIButton *btn = [[UIButton alloc] init];
        [btn setImage:[UIImage imageNamed:@"barbuttonicon_back"] forState:UIControlStateNormal];
        btn;
    });
    [self.navBarView addSubview:btnBack];
    
    [btnBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBarView.mas_centerY);
        make.left.equalTo(self.navBarView.mas_left).offset(15);
        make.width.height.mas_equalTo(35);
    }];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBarView.mas_bottom);
        make.left.right.equalTo(self.view);
    }];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    [self setupAssets];
}

#pragma mark - method
- (void)setupAssets {
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * self.previewAssets.count, ImageHeight);
    for (int i = 0; i < self.previewAssets.count; i++) {
        @autoreleasepool {
            DKAlbumModel *model = self.previewAssets[i];
            
            /*
            DKAlbumPreviewView *preview = [[DKAlbumPreviewView alloc] initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, kScreenHeight)];
            preview.asset = model.asset;
            [self.scrollView addSubview:preview];
            */
            
            UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
            doubleTap.numberOfTapsRequired = 2;
            
            UIScrollView *subScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, ImageHeight)];
            subScrollView.backgroundColor = [UIColor clearColor];
            subScrollView.showsHorizontalScrollIndicator = subScrollView.showsVerticalScrollIndicator = NO;
            subScrollView.delegate = self;
            subScrollView.minimumZoomScale = 1.0;
            subScrollView.maximumZoomScale = 2;
            subScrollView.userInteractionEnabled = YES;
            [self.scrollView addSubview:subScrollView];
            
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:doubleTap];
            [subScrollView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.equalTo(subScrollView);
                make.width.mas_equalTo(kScreenWidth);
                make.height.mas_equalTo(ImageHeight);
            }];
            
            [imageView setCenter:CGPointMake(imageView.center.x, CGRectGetMidY(subScrollView.frame))];
            
             [[DKAlbumTool shareInstance] fetchPhotoWithAsset:model.asset imageBlock:^(UIImage * _Nonnull image) {
                imageView.image = image;
             }];
        }
    }
    
    self.scrollView.contentOffset = CGPointMake(self.currentIndex * kScreenWidth, ImageHeight);
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gesture {
    float newScale = [(UIScrollView *)gesture.view.superview zoomScale] * 2;
    [UIView animateWithDuration:0.3 animations:^{
        [(UIScrollView *)gesture.view.superview setZoomScale:newScale];
    }];
    if (newScale > 2) {
        newScale = 1;
        [UIView animateWithDuration:0.3 animations:^{
            [(UIScrollView *)gesture.view.superview setZoomScale:newScale];
        }];
    }
}

#pragma mark - delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        int index = scrollView.contentOffset.x / scrollView.bounds.size.width;
        if (index != self.currentIndex) {
            for (UIScrollView *scrollview in scrollView.subviews){
                if ([scrollview isKindOfClass:[UIScrollView class]]){
                    [scrollview setZoomScale:1.0];
                }
            }
            self.currentIndex = index;
        }
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    for (UIView *view in scrollView.subviews) {
        return view;
    }
    return nil;
}

#pragma mark - 初始化
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.showsHorizontalScrollIndicator = _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIView *)navBarView {
    if (!_navBarView) {
        _navBarView = [[UIView alloc] init];
        _navBarView.backgroundColor = [UIColor blackColor];
    }
    return _navBarView;
}

- (DKAlbumBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[DKAlbumBottomView alloc] init];
    }
    return _bottomView;
}
@end

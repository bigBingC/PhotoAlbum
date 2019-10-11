//
//  DKAlbumViewController.m
//  Photo
//
//  Created by 崔冰smile on 2019/9/28.
//  Copyright © 2019 Ziwutong. All rights reserved.
//

#import "DKAlbumViewController.h"
#import "DKAlbumCVCell.h"
#import "Masonry.h"
#import "DKAlbumTool.h"
#import "DKAlbumPreviewViewController.h"

#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

@interface DKAlbumViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@end

@implementation DKAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createBaseView];
    [self loadDefaultAsset];
}

- (void)createBaseView {
    
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.collectionView];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    UIButton *btnPreview = [[UIButton alloc] init];
    [btnPreview setTitle:@"预览" forState:UIControlStateNormal];
    [btnPreview addTarget:self action:@selector(didPressedPreviewButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnSure = [[UIButton alloc] init];
    [btnSure setTitle:@"确定" forState:UIControlStateNormal];
    [btnSure addTarget:self action:@selector(didPressedSureButton) forControlEvents:UIControlEventTouchUpInside];

    [self.bottomView addSubview:btnPreview];
    [self.bottomView addSubview:btnSure];
    
    [btnPreview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView.mas_left).offset(20);
        make.centerY.equalTo(self.bottomView.mas_centerY);
    }];
    
    [btnSure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView.mas_right).offset(-20);
        make.centerY.equalTo(self.bottomView.mas_centerY);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    [self.collectionView registerClass:[DKAlbumCVCell class] forCellWithReuseIdentifier:DKAlbumCVCellID];
}

- (void)loadDefaultAsset {
    __block PHAssetCollection *collec;
    [[DKAlbumTool shareInstance] fetchAlbumGroups:^(NSMutableArray * _Nonnull groups) {
        collec = groups[1];
    }];
    
    [[DKAlbumTool shareInstance] fetchAlbumAssetsWithGroup:collec withAssets:^(NSMutableArray<DKAlbumModel *> * _Nonnull assets) {
        self.dataSource = assets;
        [self.collectionView reloadData];
    }];
}

#pragma mark - method
- (void)didPressedPreviewButton {
    
}

- (void)didPressedSureButton {
    
}

#pragma mark - delegate & dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    DKAlbumCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DKAlbumCVCellID forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    cell.selectedBlock = ^(DKAlbumModel * _Nonnull selectedModel) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        // 添加之前如果包含则先移除
        if ([strongSelf.selectedArray containsObject:selectedModel]) {
            [strongSelf.selectedArray removeObject:selectedModel];
        }
       
        if (selectedModel.isSelect) {
            [strongSelf.selectedArray addObject:selectedModel];
        }
        [DKAlbumTool shareInstance].selectedNum = strongSelf.selectedArray.count;
    };
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenWidth - 25.f) / 4.f, (kScreenWidth - 25.f) / 4.f);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DKAlbumPreviewViewController *preview = [[DKAlbumPreviewViewController alloc] init];
    preview.previewAssets = self.dataSource;
    preview.currentIndex = indexPath.row;
    [self.navigationController pushViewController:preview animated:YES];
}

#pragma mark - 初始化
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 5.f;
        layout.minimumInteritemSpacing = 5.f;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 20, 30) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = YES;
        _collectionView.alwaysBounceVertical = YES;
    }
    return _collectionView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor grayColor];
    }
    return _bottomView;
}

- (NSMutableArray *)selectedArray {
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}
@end

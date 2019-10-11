//
//  DKAlbumTool.h
//  Photo
//
//  Created by 崔冰smile on 2019/9/28.
//  Copyright © 2019 Ziwutong. All rights reserved.
//

/**
 工具类（新建自定义相册、获取相册及图片）
 */

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "DKAlbumModel.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^getAlbumGroupsBlock)(NSMutableArray *groups);
typedef void (^getAlbumAssetsBlock)(NSMutableArray <DKAlbumModel *>*assets);

@interface DKAlbumTool : NSObject
// 相册标题
@property (nonatomic, copy) NSString *groupTitle;
// 所有相册
@property (nonatomic, strong) NSMutableArray <PHAssetCollection *>*groups;
// 一个相册内所有的图片
@property (nonatomic, strong) NSMutableArray <DKAlbumModel *>*assets;
// 最大可以选择的图片数
@property (nonatomic, assign) NSUInteger maxSelectNum;
// 已经选择的图片数
@property (nonatomic, assign) NSUInteger selectedNum;

+ (instancetype)shareInstance;

/**
 自定义相册，若不存在就建立一个，并回传AssetCollection
 
 @param name 自定义相册名
 @param completion 回调
 */
- (void)createAssetCollectionWithName:(NSString *)name completion:(void(^)(NSString *errorMsg, PHAssetCollection *assetCollection))completion;

/**
 将图片存到手机，并指定到指定相册
 
 @param imageArray 添加的图片组
 @param assetCollection 指定的相册
 @param completion 回调
 */
- (void)addAssetsToAlbumWithImageArray:(NSMutableArray *)imageArray toAssetCollection:(PHAssetCollection *)assetCollection completion:(void(^)(NSString *errorMsg))completion;

/**
 用名称取得AssetCollection
 
 @param name 相册名
 */
- (PHAssetCollection*)fetchAssetCollectionWithName:(NSString *)name;


/**
 获取相册组（系统+自定义）
 
 @param albumGroups 所有的相册
 */
- (void)fetchAlbumGroups:(getAlbumGroupsBlock)albumGroups;

/**
 获取某一相册内所有的PHAsset
 
 @param group 指定的相册
 @param albumAssets 回调
 */
- (void)fetchAlbumAssetsWithGroup:(PHAssetCollection *)group withAssets:(getAlbumAssetsBlock)albumAssets;

/**
 PHAsset转成image
 
 @param asset PHAsset
 @param imageBlock 回调
 */
- (void)fetchPhotoWithAsset:(PHAsset *)asset imageBlock:(void(^)(UIImage *))imageBlock;


@end

NS_ASSUME_NONNULL_END

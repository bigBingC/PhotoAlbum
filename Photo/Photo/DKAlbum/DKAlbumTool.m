//
//  DKAlbumTool.m
//  Photo
//
//  Created by 崔冰smile on 2019/9/28.
//  Copyright © 2019 Ziwutong. All rights reserved.
//

#import "DKAlbumTool.h"

@implementation DKAlbumTool

+ (instancetype)shareInstance {
    static DKAlbumTool *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DKAlbumTool alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self == [super init]) {
        self.groups = [NSMutableArray array];
        self.assets = [NSMutableArray array];
        self.maxSelectNum = 0;
        self.selectedNum = 0;
    }
    return self;
}

- (void)createAssetCollectionWithName:(NSString *)name completion:(void (^)(NSString *errorMsg, PHAssetCollection *collection))completion {
    [self requestPhotoAlbumPermissions:^(BOOL permission) {
        if (permission) {
            PHAssetCollection *assetCollection = [self fetchAssetCollectionWithName:name];
            if (assetCollection) {
                completion(nil, assetCollection);
            } else {
                if (name.length > 0) {
                    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                        [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:name];
                    } completionHandler:^(BOOL success, NSError *error) {
                        if (success) {
                            completion(nil, [self fetchAssetCollectionWithName:name]);
                        } else {
                            completion(error.localizedDescription, nil);
                        }
                    }];
                } else {
                    completion(@"name不能为空", nil);
                }
            }
        } else {
            completion(@"没权限", nil);
        }
    }];
}

- (PHAssetCollection *)fetchAssetCollectionWithName:(NSString *)name {
    __block PHAssetCollection *assetCollection;
    PHFetchResult *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum               subtype:PHAssetCollectionSubtypeAlbumRegular
        options:nil];
    [assetCollections enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL *stop) {
        if ([collection.localizedTitle isEqualToString:name]) {
            assetCollection = collection;
            *stop = YES;
        }
    }];
    
    if (assetCollection) {
        return assetCollection;
    } else {
        return nil;
    }
}

- (void)addAssetsToAlbumWithImageArray:(NSMutableArray *)imageArray toAssetCollection:(PHAssetCollection *)assetCollection completion:(void (^)(NSString * errorMsg))completion {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        NSMutableArray *assetsArray = [[NSMutableArray alloc] init];
        for (UIImage *image in imageArray) {
            PHAssetChangeRequest *createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            PHObjectPlaceholder *assetPlaceholder = [createAssetRequest placeholderForCreatedAsset];
            [assetsArray addObject:assetPlaceholder];
        }

        PHAssetCollectionChangeRequest *collectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
        [collectionChangeRequest addAssets:assetsArray];
    } completionHandler:^(BOOL success, NSError *error) {
        if (success) {
            completion(nil);
        } else {
            completion(error.localizedDescription);
        }
    }];
}

- (void)fetchAlbumGroups:(getAlbumGroupsBlock)albumGroups {
    // 获得个人收藏相册
    PHFetchResult<PHAssetCollection *> *favoritesCollection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumFavorites options:nil];
    // 获得相机胶卷
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    // 获得全部相片
    PHFetchResult<PHAssetCollection *> *cameraRolls = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    
    for (PHAssetCollection *collection in cameraRolls) {
        [self.groups addObject:collection];
    }
    for (PHAssetCollection *collection in assetCollections) {
        [self.groups addObject:collection];
    }
    for (PHAssetCollection *collection in favoritesCollection) {
        [self.groups addObject:collection];
    }
    albumGroups(self.groups);
}

- (void)fetchAlbumAssetsWithGroup:(PHAssetCollection *)group withAssets:(getAlbumAssetsBlock)albumAssets {
    if ([group.localizedTitle isEqualToString:@"All Photos"]) {
        self.groupTitle = @"全部相册";
    } else {
        self.groupTitle = group.localizedTitle;
    }
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:group options:nil];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj) {
            DKAlbumModel *model = [[DKAlbumModel alloc] initAlbumModel:obj];
            model.maxSelectedNum = self.maxSelectNum;
            [self.assets addObject:model];
        }
    }];
    
    albumAssets(self.assets);
}

- (void)fetchPhotoWithAsset:(PHAsset *)asset imageBlock:(void (^)(UIImage * _Nonnull))imageBlock {
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        UIImage *image = [UIImage imageWithData:imageData];
        if (imageBlock) {
            imageBlock(image);
        }
    }];
    
//    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//        if (imageBlock) {
//            imageBlock(result);
//        }
//    }];
}


- (void)requestPhotoAlbumPermissions:(void(^)(BOOL permission))block {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusAuthorized:
            block(YES);
            break;
        case PHAuthorizationStatusNotDetermined: {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus authorizationStatus) {
                 if (authorizationStatus == PHAuthorizationStatusAuthorized) {
                     block(YES);
                 } else {
                     block(NO);
                 }
             }];
            break;
        }
        default:
            block(NO);
            break;
    }
}

@end

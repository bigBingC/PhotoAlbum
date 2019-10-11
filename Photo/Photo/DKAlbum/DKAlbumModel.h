//
//  DKAlbumModel.h
//  Photo
//
//  Created by 崔冰smile on 2019/9/28.
//  Copyright © 2019 Ziwutong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface DKAlbumModel : NSObject

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) NSUInteger maxSelectedNum;
@property (nonatomic, assign) BOOL isSelect;

-(instancetype)initAlbumModel:(PHAsset *)asset;

@end

NS_ASSUME_NONNULL_END

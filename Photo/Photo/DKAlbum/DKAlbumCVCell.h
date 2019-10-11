//
//  DKAlbumCVCell.h
//  Photo
//
//  Created by 崔冰smile on 2019/9/28.
//  Copyright © 2019 Ziwutong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKAlbumModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^selectedAlbumBlock)(DKAlbumModel *selectedModel);

static NSString *DKAlbumCVCellID = @"DKAlbumCVCell";

@interface DKAlbumCVCell : UICollectionViewCell

@property (nonatomic, strong) DKAlbumModel *model;

@property (nonatomic, copy) selectedAlbumBlock selectedBlock;
@end

NS_ASSUME_NONNULL_END

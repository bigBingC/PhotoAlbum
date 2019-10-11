//
//  DKAlbumPreviewViewController.h
//  Photo
//
//  Created by 崔冰smile on 2019/9/29.
//  Copyright © 2019 Ziwutong. All rights reserved.
//

/**
 相册预览
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DKAlbumPreviewViewController : UIViewController
// 预览的图片
@property (nonatomic, strong) NSArray *previewAssets;
// 当前预览图片的索引
@property (nonatomic, assign) NSInteger currentIndex;

@end

NS_ASSUME_NONNULL_END

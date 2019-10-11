//
//  DKAlbumPreviewView.h
//  Photo
//
//  Created by 崔冰smile on 2019/10/8.
//  Copyright © 2019 Ziwutong. All rights reserved.
//

/**
 预览view
 */

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface DKAlbumPreviewView : UIView

@property (nonatomic, strong) PHAsset *asset;

@end

NS_ASSUME_NONNULL_END

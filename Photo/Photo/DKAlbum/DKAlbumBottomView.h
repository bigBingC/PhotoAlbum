//
//  DKAlbumBottomView.h
//  Photo
//
//  Created by 崔冰smile on 2019/10/8.
//  Copyright © 2019 Ziwutong. All rights reserved.
//

/**
 底部toolbar
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DKAlbumBottomView : UIView
@property (nonatomic, copy) NSString *leftTitle;
@property (nonatomic, strong) UIColor *leftTitleColor;

@property (nonatomic, copy) NSString *rightTitle;
@property (nonatomic, strong) UIColor *rightTitleColor;

@property (nonatomic, strong) UIColor *bgColor;
@end

NS_ASSUME_NONNULL_END

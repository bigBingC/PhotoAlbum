//
//  DKAlbumModel.m
//  Photo
//
//  Created by 崔冰smile on 2019/9/28.
//  Copyright © 2019 Ziwutong. All rights reserved.
//

#import "DKAlbumModel.h"

@implementation DKAlbumModel

- (instancetype)initAlbumModel:(PHAsset *)asset {
    self = [super init];
    if (self) {
        _asset = asset;
        _isSelect = NO;
    }
    return self;
}
@end

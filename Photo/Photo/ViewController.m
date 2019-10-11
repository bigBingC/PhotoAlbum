//
//  ViewController.m
//  Photo
//
//  Created by 崔冰smile on 2019/9/28.
//  Copyright © 2019 Ziwutong. All rights reserved.
//

#import "ViewController.h"
#import "DKAlbumTool.h"
#import "DKAlbumViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __block PHAssetCollection *coll;
    [DKAlbumTool shareInstance].maxSelectNum = 6;
    [[DKAlbumTool shareInstance] fetchAlbumGroups:^(NSMutableArray * _Nonnull groups) {
        coll = groups[2];
        NSLog(@"%@",groups);
    }];
    
    [[DKAlbumTool shareInstance] fetchAlbumAssetsWithGroup:coll withAssets:^(NSMutableArray<PHAsset *> * _Nonnull assets) {
        NSLog(@"%@",assets);
    }];
    
    [[DKAlbumTool shareInstance] createAssetCollectionWithName:@"蛋疼" completion:^(NSString * _Nonnull errorMsg, PHAssetCollection * _Nonnull assetCollection) {
        NSLog(@"---");
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    DKAlbumViewController *vc = [[DKAlbumViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

@end

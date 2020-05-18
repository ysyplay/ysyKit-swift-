//
//  YsyUpImageModel.h
//  GHKC
//
//  Created by itonghui on 2019/7/31.
//  Copyright © 2019 Tonghui Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@interface YsyUpImageModel : NSObject
@property (strong,nonatomic) PHAsset  *asset;
@property (strong,nonatomic) UIImage  *image;
@property (strong,nonatomic) NSData   *imageData;
@property (copy  ,nonatomic) NSString *imageUrl;
@property (copy  ,nonatomic) NSString *attchId;
@property (assign,nonatomic) BOOL      uploaded;//是否已经上传
//重制数据
- (void)reloadData;
@end



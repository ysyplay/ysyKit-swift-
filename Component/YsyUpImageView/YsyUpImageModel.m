//
//  YsyUpImageModel.m
//  GHKC
//
//  Created by itonghui on 2019/7/31.
//  Copyright © 2019 Tonghui Network Technology Co., Ltd. All rights reserved.
//

#import "YsyUpImageModel.h"

@implementation YsyUpImageModel
- (void)reloadData{
    self.asset     = nil;
    self.image     = nil;
    self.imageUrl  = nil;
    self.imageData = nil;
    self.attchId   = nil;
    self.uploaded  = NO;
}
@end

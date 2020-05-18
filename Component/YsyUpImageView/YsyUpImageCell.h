//
//  YsyUpImageCell.h
//  IntelligentNetwork
//
//  Created by Runa on 2017/6/6.
//  Copyright © 2017年 Runa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YsyUpImageModel.h"
@interface YsyUpImageCell : UICollectionViewCell
@property (nonatomic,weak ) IBOutlet UIImageView     *pic;
@property (nonatomic,weak ) IBOutlet UIButton        *deleteButt;
@property (nonatomic,weak ) IBOutlet UIImageView     *deleteImage;
@property (weak, nonatomic) IBOutlet UIImageView     *videoFlagView;
@property (nonatomic, strong) YsyUpImageModel *model;
@property (nonatomic, copy) void (^deleteBlock)(NSInteger Index);
@end

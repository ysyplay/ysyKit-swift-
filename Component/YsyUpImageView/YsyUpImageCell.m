//
//  YsyUpImageCell.m
//  IntelligentNetwork
//
//  Created by Runa on 2017/6/6.
//  Copyright © 2017年 Runa. All rights reserved.
//

#import "YsyUpImageCell.h"
#import <Photos/Photos.h>
#import "TZImagePickerController.h"

@interface YsyUpImageCell ()


@end

@implementation YsyUpImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
     _videoFlagView.hidden = true;
     _videoFlagView.image = [UIImage tz_imageNamedFromMyBundle:@"MMVideoPreviewPlay"];
}
- (void)setModel:(YsyUpImageModel *)model{
    if (model.asset.mediaType == PHAssetMediaTypeVideo) {
        _videoFlagView.hidden = NO;
    }else{
        _videoFlagView.hidden = true;
    }
}
- (IBAction)deleteButtClick:(UIButton *)sender {
    if (_deleteBlock){
        _deleteBlock(sender.tag);
    }
}


@end

//
//  YsyUpImageView.h
//  NGanTa
//
//  Created by ysyplay on 2020/1/28.
//  Copyright © 2020 ysyplay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YsyUpImageModel.h"


// 上传成功回调
typedef void(^upLoadSuccessBlock)(void);
// 上传失败回调
typedef void(^upLoadFailureBlock)(void);
// 获取图片资源的方式
typedef NS_ENUM(NSUInteger,UPImageViewType){
    photoAndCamera,
    photo,
    Camera,
};



@protocol YsyUpImageViewDelegate <NSObject>
/**
  如果需要每次单张上传可实现此代理
 @param imageModel 控件模型
 */
- (void)uploadImage:(YsyUpImageModel *)imageModel success:(upLoadSuccessBlock)upLoadSuccess failure:(upLoadFailureBlock)upLoadFailure;
@end


@interface YsyUpImageView : UICollectionView
#pragma mark 可设置属性参数*******************
//当前controller，必须设置
@property (weak,nonatomic) UIViewController *currentVC;
@property (nonatomic, assign) id<YsyUpImageViewDelegate> uploadDelegate;
//用于处理点击添加按钮时，当前controller的操作，例如收起键盘等
@property (nonatomic, copy) void (^actionBlock)(void);
//frame更新后调用
@property (nonatomic, copy) void (^refreshBlock)(void);
//删除某张图片后调用
@property (nonatomic, copy) void (^deleteBlock)(YsyUpImageModel *model);
//picArry 已选择图片model数组
@property (strong,nonatomic,readonly) NSMutableArray<YsyUpImageModel *> *picModelArr;
#pragma mark *******************



#pragma mark 可设置属性参数*******************
///获取图片资源的方式，默认为相机，相册
@property (nonatomic,assign) UPImageViewType       type;
/// 照片最大可选张数，设置为1即为单选模式，默认5
@property (nonatomic,assign) NSInteger             maxCount;
/// 每行展示张数，默认3
@property (nonatomic,assign) float                 columnNum;
/// 允许选择照片，默认为yes
@property (nonatomic,assign) BOOL                  allowPhoto;
/// 允许拍摄照片，默认为yes
@property (nonatomic,assign) BOOL                  allowTakePhoto;
/// 允许选择视频，默认为no
@property (nonatomic,assign) BOOL                  allowVideo;
/// 允许拍摄视频，默认为no
@property (nonatomic,assign) BOOL                  allowTakeVideo;
/// 允许选择多个视频，默认为no
@property (nonatomic,assign) BOOL                  allowMuitlpleVideo;
/// 允许选择Gif图片，默认为no
@property (nonatomic,assign) BOOL                  allowGif;
/// 是否显示选择序号，默认为yes
@property (nonatomic,assign) BOOL                  allowSelectedIndex;
/// 是否允许选择原图，默认为no
@property (nonatomic,assign) BOOL                  allowPickingOriginal;
/// 单选模式下是否剪裁，默认no
@property (nonatomic,assign) BOOL                  allowCrop;
/// 圆形裁剪框，默认no
@property (nonatomic,assign) BOOL                  allowCircleCrop;
#pragma mark *********************************


-(void)removeAll;
///代码初始化frame高度可以传0，根据宽度，会自动算出控价高度，每行3个。
-(instancetype)initWithFrame:(CGRect)frame currentVC:(UIViewController *)currentVC;
///单选时，不需要添加按钮，例如选择头像时可以直接调用
-(void)addImageButtClick;
@end

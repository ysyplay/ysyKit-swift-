//
//  YsyUpImageView.m
//  NGanTa
//
//  Created by ysyplay on 2020/1/28.
//  Copyright © 2020 ysyplay. All rights reserved.
//  原图，视频，Gif，上传暂未完成
#import "YsyUpImageView.h"
#import "TZImagePickerController.h"
#import "YsyUpImageCell.h"
#import "UIView+Layout.h"
#import "FLAnimatedImage.h"
#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>
#define MSWidth [UIScreen mainScreen].bounds.size.width
#define MSHeight [UIScreen mainScreen].bounds.size.height

@interface YsyUpImageView ()<UIImagePickerControllerDelegate,TZImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (strong,nonatomic) UIImagePickerController *imagePicker;
@property (assign,nonatomic,readwrite) NSInteger itemWH;
@property (assign,nonatomic,readwrite) NSInteger margin;
@property (nonatomic,strong) NSOperationQueue *operationQueue;
@end



@implementation YsyUpImageView

- (UIImagePickerController *)imagePicker{
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.navigationBar.barTintColor = _currentVC.navigationController.navigationBar.barTintColor;
        _imagePicker.navigationBar.tintColor = _currentVC.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (@available(iOS 9, *)) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
 
    }
    return _imagePicker;
}

//默认参数设置
- (void)defaultSetting {
    self.allowPhoto           = YES;
    self.allowTakePhoto       = YES;
    self.allowVideo           = NO;
    self.allowTakeVideo       = NO;
    self.allowGif             = NO;
    self.allowMuitlpleVideo   = NO;
    self.allowSelectedIndex   = YES;
    self.allowPickingOriginal = NO;
    self.maxCount             = 5;
    self.columnNum            = 3;
    self.allowCrop            = NO;
    self.allowCircleCrop      = NO;
    self.type                 = photoAndCamera;
    _picModelArr = [[NSMutableArray alloc] initWithCapacity:0];
}

//xib方式创建
-(void)awakeFromNib{
    
    [super awakeFromNib];
    [self defaultSetting];
    if (_maxCount ==0) {
        _maxCount = 5;
    }
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _margin = 12;
    _itemWH = (self.tz_width - (_columnNum - 1) * _margin) / _columnNum;
    [_currentVC.view layoutIfNeeded];
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing      = _margin;
    //设置表格的滚动方向，有水平和竖直两种
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self setCollectionViewLayout:layout];
    self.dataSource      = self;
    self.delegate        = self;
    self.pagingEnabled   = NO;
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds   = YES;
    [self registerNib:[UINib nibWithNibName:@"YsyUpImageCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
}

//代码方式创建
-(instancetype)initWithFrame:(CGRect)frame currentVC:(UIViewController *)currentVC{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _margin = 12;
    _itemWH = (frame.size.width - (_columnNum - 1) * _margin) / _columnNum;
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing      = _margin;
    CGRect Frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, _itemWH + _margin * 2 + 15);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self = [super initWithFrame:Frame collectionViewLayout:layout];
    if (self)
    {
        [self defaultSetting];
        self.dataSource      = self;
        self.delegate        = self;
        self.pagingEnabled   = NO;
        self.backgroundColor = [UIColor clearColor];
        self.currentVC       = currentVC;
       [self registerNib:[UINib nibWithNibName:@"YsyUpImageCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    } 
    return self;
}
//设置每个item的边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 0, 10, 0);
}
-(void)refreshFrame {
    if (_refreshBlock)
    {
        NSInteger count = _picModelArr.count + 1;
        if (_picModelArr.count == _maxCount)
        {
            count = _maxCount;
        }
        int rowCount = ceil(count/_columnNum);
         _itemWH = (self.tz_width - (_columnNum - 1) * _margin) / _columnNum;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, (_itemWH+_margin)*rowCount+_margin);
        
        _refreshBlock();
    }
}
-(void)removeAll
{
    [_picModelArr removeAllObjects];
    [self reloadData];
}
- (void)reloadData{
    [self refreshFrame];
    [super reloadData];
}

#pragma mark UICollectionView
- ( CGSize )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath {
    return CGSizeMake(_itemWH, _itemWH);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_picModelArr.count >= _maxCount) {
        return _maxCount;
    }
    //如果不是允许多选视频，当已选择一个视频后，不显示添加按钮
    if (!self.allowMuitlpleVideo) {
        for (YsyUpImageModel *model in _picModelArr) {
            if (model.asset.mediaType == PHAssetMediaTypeVideo) {
                return _picModelArr.count;
            }
        }
    }
    return _picModelArr.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YsyUpImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    //添加按钮
    if (indexPath.row == _picModelArr.count)
    {
        cell.pic.image = [UIImage imageNamed:@"AlbumAddBtn"];
        cell.deleteButt.hidden    = YES;
        cell.deleteImage.hidden   = YES;
        cell.videoFlagView.hidden = YES;
    }
    else
    {
        YsyUpImageModel *model = _picModelArr[indexPath.row];
        if (model.imageUrl) {
//            [cell.pic sd_setImageWithURL:(NSURL *)model.imageUrl placeholderImage:PLACEHOLDER_IMAGE];
        }else{
            cell.pic.image = model.image;
        }
        cell.model = model;
        cell.deleteButt.tag          = indexPath.row;
        cell.deleteButt.hidden       = NO;
        cell.deleteImage.hidden      = NO;
        __weak typeof(self) weakSelf = self;
        cell.deleteBlock = ^(NSInteger Index)
        {
            [weakSelf deletePicItem:model];
            [self reloadData];
        };
    }
    return cell;
}
- (void)deletePicItem:(YsyUpImageModel *)model{
    if (self.deleteBlock) {
        self.deleteBlock(model);
    }
    [self.picModelArr removeObject:model];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _picModelArr.count)
    {
        //添加
        [self addImageButtClick];
    }
    else
    {
        //查看预览
        [self preview:indexPath.row];
    }
}
//预览照片或者视频
-(void)preview:(NSInteger)index {
    PHAsset *asset = _picModelArr[index].asset;
    BOOL isVideo = NO;
    isVideo = asset.mediaType == PHAssetMediaTypeVideo;
    if ([[asset valueForKey:@"filename"] containsString:@"GIF"] && self.allowGif && !self.allowMuitlpleVideo) {
        TZGifPhotoPreviewController *vc = [[TZGifPhotoPreviewController alloc] init];
        TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypePhotoGif timeLength:@""];
        vc.model = model;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [_currentVC presentViewController:vc animated:YES completion:nil];
    } else if (isVideo && !self.allowMuitlpleVideo) { // perview video / 预览视频
        TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
        TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
        vc.model = model;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [_currentVC presentViewController:vc animated:YES completion:nil];
    } else { // preview photos / 预览照片
        NSMutableArray *selectedAssets = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray *selectedPhotos = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i<_picModelArr.count; i++) {
            YsyUpImageModel *model = _picModelArr[i];
            [selectedAssets addObject:model.asset];
            [selectedPhotos addObject:model.image];
        }
        TZImagePickerController *tzPicker  = [[TZImagePickerController alloc] initWithSelectedAssets:selectedAssets selectedPhotos:selectedPhotos index:index];
        tzPicker.maxImagesCount            = self.maxCount;
        tzPicker.allowPickingGif           = self.allowGif;
        tzPicker.allowPickingOriginalPhoto = self.allowPickingOriginal;
        tzPicker.allowPickingMultipleVideo = self.allowMuitlpleVideo;
        tzPicker.showSelectedIndex         = self.allowSelectedIndex;
        tzPicker.isSelectOriginalPhoto     = NO;
        tzPicker.modalPresentationStyle    = UIModalPresentationFullScreen;
        __weak typeof(self) weakSelf       = self;
        
        // 如果在预览界面删除了某些相片，更新数据源
        [tzPicker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
            for (YsyUpImageModel *model in weakSelf.picModelArr) {
                if (![assets containsObject:model.asset]) {
                    [arr addObject:model];
                }
            }
            for (YsyUpImageModel *model in arr) {
                [weakSelf deletePicItem:model];
           }
           [weakSelf reloadData];
        }];
        
        [_currentVC presentViewController:tzPicker animated:YES completion:nil];
    }
}

//点击添加按钮
-(void)addImageButtClick {
    if (_actionBlock) {
        _actionBlock();
    }
    self.currentVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    if (self.imagePicker) {
        if (_type == photoAndCamera) {
            UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self takePhoto];
            }];
            [actionSheet addAction:takePhotoAction];
            UIAlertAction *imagePickerAction = [UIAlertAction actionWithTitle:@"去相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self pushTZImagePickerController];
            }];
            [actionSheet addAction:imagePickerAction];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [actionSheet addAction:cancelAction];
            [_currentVC presentViewController:actionSheet animated:YES completion:nil];
        }
        else if (_type == photo) {
           [self takePhoto];
        }
        else if (_type == Camera) {
            [self pushTZImagePickerController];
        }
    }
}

#pragma mark 相机入口 ************************
//拍照的一系列权限验证和处理
- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        // 无相机权限 做一个友好的提示
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }]];
        [_currentVC presentViewController:alertController animated:YES completion:nil];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self takePhoto];
                });
            }
        }];
        // 拍照之前还需要检查相册权限
    } else if ([PHPhotoLibrary authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }]];
        [_currentVC presentViewController:alertController animated:YES completion:nil];
    } else if ([PHPhotoLibrary authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}
// 调用相机
- (void)pushImagePickerController {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePicker.sourceType = sourceType;
        NSMutableArray *mediaTypes = [NSMutableArray array];
        if (self.allowTakeVideo) {
            [mediaTypes addObject:(NSString *)kUTTypeMovie];
        }
        if (self.allowTakePhoto) {
            [mediaTypes addObject:(NSString *)kUTTypeImage];
        }
        if (mediaTypes.count) {
            _imagePicker.mediaTypes = mediaTypes;
        }
        [_currentVC presentViewController:_imagePicker animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}
// 拍照结束后调用
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //这里是单纯为了调用HUD
    TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    [tzImagePickerVc showProgressHUD];
    
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSDictionary *meta = [info objectForKey:UIImagePickerControllerMediaMetadata];
        // save photo and get asset / 保存图片到相册，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image meta:meta location:nil completion:^(PHAsset *asset, NSError *error){
            [tzImagePickerVc hideProgressHUD];
            if (error) {
                NSLog(@"图片保存失败 %@",error);
            } else {
                TZAssetModel *assetModel = [[TZImageManager manager] createModelWithAsset:asset];
                if (self.allowCrop) { // 允许裁剪,去裁剪
                    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
                        [self refreshCollectionViewWithAddedAsset:asset image:cropImage];
                    }];
                    imagePicker.allowPickingImage = YES;
                    imagePicker.needCircleCrop = self.allowCircleCrop;
                    imagePicker.circleCropRadius = 100;
                    [self.currentVC presentViewController:imagePicker animated:YES completion:nil];
                } else {
                    [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                }
            }
        }];
    } else if ([type isEqualToString:@"public.movie"]) {
        NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        if (videoUrl) {
            [[TZImageManager manager] saveVideoWithUrl:videoUrl location:nil completion:^(PHAsset *asset, NSError *error) {
                [tzImagePickerVc hideProgressHUD];
                if (!error) {
                    TZAssetModel *assetModel = [[TZImageManager manager] createModelWithAsset:asset];
                    [[TZImageManager manager] getPhotoWithAsset:assetModel.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
                        if (!isDegraded && photo) {
                            [self refreshCollectionViewWithAddedAsset:assetModel.asset image:photo];
                        }
                    }];
                }
            }];
        }
    }
}

- (void)refreshCollectionViewWithAddedAsset:(PHAsset *)asset image:(UIImage *)image {
    UIImage *getImg = [self imageCompressForWidth:image target:700];
    NSData *imgData = UIImageJPEGRepresentation(getImg, 0.6);
    NSLog(@"图片大小 %.3lukb",imgData.length/1024);
    
    __block YsyUpImageModel *model = [YsyUpImageModel new];
    model.imageData = imgData;
    model.image = getImg;
    model.asset = asset;
    if ([self.uploadDelegate respondsToSelector:@selector(uploadImage:success:failure:)]) {
        __weak typeof(self) weakSelf = self;
        [self.uploadDelegate uploadImage:model success:^{
            [weakSelf.picModelArr addObject:model];
            [weakSelf reloadData];
        } failure:^{
            model.image = [UIImage imageNamed:@"uploadFailure"];
            [weakSelf.picModelArr addObject:model];
            [weakSelf reloadData];
        }];
    }else{
        [self.picModelArr addObject:model];
    }
    [self reloadData];
}
#pragma mark end*******************************


#pragma mark TZ相片选择器************************
- (void)pushTZImagePickerController {
    if (self.maxCount <= 0) {
        return;
    }
    TZImagePickerController *tzPicker = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxCount - self.picModelArr.count columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    
/// 五类个性化设置，这些参数都可以不传，此时会走默认设置
    tzPicker.isSelectOriginalPhoto = NO;
    if (self.maxCount > 1) {
        // 1.设置目前已经选中的图片数组
        //tzPicker.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    }
    tzPicker.allowTakePicture     = NO;// 在内部显示拍照按钮
    tzPicker.allowTakeVideo       = NO;// 在内部显示拍视频按
    tzPicker.videoMaximumDuration = 10;// 视频最大拍摄时间
    [tzPicker setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    }];
    // tzPicker.photoWidth = 1600;
    // tzPicker.photoPreviewMaxWidth = 1600;
    

    // 2. 在这里设置tzPicker的外观
    // tzPicker.navigationBar.barTintColor = [UIColor greenColor];
    // tzPicker.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // tzPicker.oKButtonTitleColorNormal = [UIColor greenColor];
    // tzPicker.navigationBar.translucent = NO;
    tzPicker.iconThemeColor = [UIColor colorWithRed:31 / 255.0 green:185 / 255.0 blue:34 / 255.0 alpha:1.0];
    tzPicker.showPhotoCannotSelectLayer = YES;
    tzPicker.cannotSelectLayerColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    [tzPicker setPhotoPickerPageUIConfigBlock:^(UICollectionView *collectionView, UIView *bottomToolBar, UIButton *previewButton, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel, UIView *divideLine) {
        [doneButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }];
    /*
    [tzPicker setAssetCellDidSetModelBlock:^(TZAssetCell *cell, UIImageView *imageView, UIImageView *selectImageView, UILabel *indexLabel, UIView *bottomView, UILabel *timeLength, UIImageView *videoImgView) {
        cell.contentView.clipsToBounds = YES;
        cell.contentView.layer.cornerRadius = cell.contentView.tz_width * 0.5;
    }];
     */
    
    
    
    // 3. 设置是否可以选择视频/图片/原图
    tzPicker.allowPickingVideo         = self.allowVideo;
    tzPicker.allowPickingImage         = self.allowPhoto;
    tzPicker.allowPickingOriginalPhoto = self.allowPickingOriginal;
    tzPicker.allowPickingGif           = self.allowGif;
    tzPicker.allowPickingMultipleVideo = self.allowMuitlpleVideo;
    
    
    
    // 4. 照片排列按修改时间升序
    tzPicker.sortAscendingByModificationDate = true;
    // tzPicker.minImagesCount = 3;
    // tzPicker.alwaysEnableDoneBtn = YES;
    // tzPicker.minPhotoWidthSelectable = 3000;
    // tzPicker.minPhotoHeightSelectable = 2000;
    
    
    /// 5. 单选模式,maxImagesCount为1时才生效
    tzPicker.showSelectBtn = NO;
    tzPicker.allowCrop = self.allowCrop;
    tzPicker.needCircleCrop = self.allowCircleCrop;
    // 设置竖屏下的裁剪尺寸
    NSInteger left = 30;
    NSInteger widthHeight = _currentVC.view.tz_width - 2 * left;
    NSInteger top = (_currentVC.view.tz_height - widthHeight) / 2;
    tzPicker.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    tzPicker.scaleAspectFillCrop = YES;
    // 设置横屏下的裁剪尺寸
    // tzPicker.cropRectLandscape = CGRectMake((_currentVC.view.tz_height - widthHeight) / 2, left, widthHeight, widthHeight);
    /*
     [tzPicker setCropViewSettingBlock:^(UIView *cropView) {
     cropView.layer.borderColor = [UIColor redColor].CGColor;
     cropView.layer.borderWidth = 2.0;
     }];*/
    
    //tzPicker.allowPreview = NO;
    // 自定义导航栏上的返回按钮
    /*
    [tzPicker setNavLeftBarButtonSettingBlock:^(UIButton *leftButton){
        [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 20)];
    }];
    tzPicker.delegate = self;
    */
    
    // Deprecated, Use statusBarStyle
    // imagePickerVc.isStatusBarDefault = NO;
    tzPicker.statusBarStyle = UIStatusBarStyleLightContent;
    
    // 设置是否显示图片序号
    tzPicker.showSelectedIndex = self.allowSelectedIndex;
    
    // 设置拍照时是否需要定位，仅对选择器内部拍照有效，外部拍照的，请拷贝demo时手动把pushImagePickerController里定位方法的调用删掉
    // tzPicker.allowCameraLocation = NO;
    
    // 自定义gif播放方案
    [[TZImagePickerConfig sharedInstance] setGifImagePlayBlock:^(TZPhotoPreviewView *view, UIImageView *imageView, NSData *gifData, NSDictionary *info) {
        FLAnimatedImage *animatedImage = [FLAnimatedImage animatedImageWithGIFData:gifData];
        FLAnimatedImageView *animatedImageView;
        for (UIView *subview in imageView.subviews) {
            if ([subview isKindOfClass:[FLAnimatedImageView class]]) {
                animatedImageView = (FLAnimatedImageView *)subview;
                animatedImageView.frame = imageView.bounds;
                animatedImageView.animatedImage = nil;
            }
        }
        if (!animatedImageView) {
            animatedImageView = [[FLAnimatedImageView alloc] initWithFrame:imageView.bounds];
            animatedImageView.runLoopMode = NSDefaultRunLoopMode;
            [imageView addSubview:animatedImageView];
        }
        animatedImageView.animatedImage = animatedImage;
    }];
    
    // 设置首选语言 / Set preferred language
     tzPicker.preferredLanguage = @"zh-Hans";
    
    // 设置languageBundle以使用其它语言 / Set languageBundle to use other language
    // imagePickerVc.languageBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"tz-ru" ofType:@"lproj"]];
    
   /// - 到这里为止
    
    // 你可以通过block或者代理，来得到用户选择的照片.
    [tzPicker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {

    }];
    tzPicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [_currentVC presentViewController:tzPicker animated:YES completion:nil];
}


// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 你也可以设置autoDismiss属性为NO，选择器就不会自己dismis了
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    for (int i= 0; i<photos.count; i++) {
        UIImage *getImg = photos[i];//[self imageCompressForWidth:photos[i] target:700];
        NSData *imgData = UIImageJPEGRepresentation(getImg, 0.6);
        NSLog(@"图片大小 %.3lukb",imgData.length/1024);
        __block YsyUpImageModel *model = [YsyUpImageModel new];
        model.imageData = imgData;
        model.image = getImg;
        model.asset = assets[i];
        if ([self.uploadDelegate respondsToSelector:@selector(uploadImage:success:failure:)]) {
            __weak typeof(self) weakSelf = self;
            [self.uploadDelegate uploadImage:model success:^{
                [weakSelf.picModelArr addObject:model];
                [weakSelf reloadData];
            } failure:^{
                model.image = [UIImage imageNamed:@"uploadFailure"];
                [weakSelf.picModelArr addObject:model];
                [weakSelf reloadData];
            }];
        }else{
            [self.picModelArr addObject:model];
        }
    }
    [self reloadData];
}
#pragma mark 对于视频以及gif的处理暂时还没有测试上传的问题，还需要完善调试,暂时默认不支持，所以下面两个代理方法暂时用不到

// 如果用户选择了一个视频且allowPickingMultipleVideo是NO，下面的代理方法会被执行
// 如果allowPickingMultipleVideo是YES，将会调用imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset {
    // open this code to send video / 打开这段代码发送视频
    [[TZImageManager manager] getVideoOutputPathWithAsset:asset presetName:AVAssetExportPresetLowQuality success:^(NSString *outputPath) {
        // NSData *data = [NSData dataWithContentsOfFile:outputPath];
        NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
        // Export completed, send video here, send by outputPath or NSData
        // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    } failure:^(NSString *errorMessage, NSError *error) {
        NSLog(@"视频导出失败:%@,error:%@",errorMessage, error);
    }];
    [self reloadData];
}

// 如果用户选择了一个gif图片且allowPickingMultipleVideo是NO，下面的代理方法会被执行
// 如果allowPickingMultipleVideo是YES，将会调用imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(PHAsset *)asset {
    [self reloadData];
}

#pragma mark end*******************************

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [_currentVC dismissViewControllerAnimated:YES
                             completion:nil];
}

// 决定相册显示与否
- (BOOL)isAlbumCanSelect:(NSString *)albumName result:(PHFetchResult *)result {
    /*
    if ([albumName isEqualToString:@"个人收藏"]) {
        return NO;
    }
    if ([albumName isEqualToString:@"视频"]) {
        return NO;
    }*/
    return YES;
}

// 决定asset显示与否
- (BOOL)isAssetCanSelect:(PHAsset *)asset {
    /*
    switch (asset.mediaType) {
        case PHAssetMediaTypeVideo: {
            // 视频时长
            // NSTimeInterval duration = phAsset.duration;
            return NO;
        } break;
        case PHAssetMediaTypeImage: {
            // 图片尺寸
            if (phAsset.pixelWidth > 3000 || phAsset.pixelHeight > 3000) {
                // return NO;
            }
            return YES;
        } break;
        case PHAssetMediaTypeAudio:
            return NO;
            break;
        case PHAssetMediaTypeUnknown:
            return NO;
            break;
        default: break;
    }
     */
    return YES;
}



// 按比例缩小图片到某个宽度
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage target:(CGFloat)multiple{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    multiple = imageSize.width/multiple;
    CGFloat targetWidth = width/multiple;
    CGFloat targetHeight = height/multiple;
    NSLog(@"缩小  %f",targetWidth);
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth, targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)dealloc{
    NSLog(@"安全移除YsyUpImage");
}


@end

//
//  FGImagePickerVC.m
//  yiquanqiu
//
//  Created by Eric on 2017/7/24.
//  Copyright © 2017年 YangWeiCong. All rights reserved.
//

#import "FGImagePickerVC.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <TZImagePickerController/UIView+Layout.h>
#import <TZImageManager.h>
#import <TZImagePickerController/TZLocationManager.h>
#import <TZImagePickerController/TZVideoPlayerController.h>
#import <TZImagePickerController/TZPhotoPreviewController.h>
#import <TZImagePickerController/TZGifPhotoPreviewController.h>
#import "LxGridViewFlowLayout.h"
#import "FGImagePickerCCell.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <UIImageView+YYWebImage.h>

@interface FGImagePickerVC ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate> {
//    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    NSMutableArray *_selectedMixPhotos;
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
    CGFloat _column;
}

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) LxGridViewFlowLayout *layout;
@property (strong, nonatomic) CLLocation *location;

//@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
//// 设置开关
//@property (weak, nonatomic) IBOutlet UISwitch *showTakePhotoBtnSwitch;  ///< 在内部显示拍照按钮
//@property (weak, nonatomic) IBOutlet UISwitch *sortAscendingSwitch;     ///< 照片排列按修改时间升序
//@property (assign, nonatomic) IBOutlet UISwitch *allowPickingVideoSwitch; ///< 允许选择视频
//@property (weak, nonatomic) IBOutlet UISwitch *allowPickingImageSwitch; ///< 允许选择图片
//@property (assign, nonatomic) BOOL allowPickingGifSwitch;
//@property (weak, nonatomic) IBOutlet UISwitch *allowPickingOriginalPhotoSwitch; ///< 允许选择原图
//@property (assign, nonatomic) BOOL showSheetSwitch; ///< 显示一个sheet,把拍照按钮放在外面
//@property (weak, nonatomic) IBOutlet UITextField *maxCountTF;  ///< 照片最大可选张数，设置为1即为单选模式
//@property (weak, nonatomic) IBOutlet UITextField *columnNumberTF;
//@property (weak, nonatomic) IBOutlet UISwitch *allowCropSwitch;
//@property (weak, nonatomic) IBOutlet UISwitch *needCircleCropSwitch;
//@property (weak, nonatomic) IBOutlet UISwitch *allowPickingMuitlpleVideoSwitch;

@end

@implementation FGImagePickerVC

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9OrLater) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
        
    }
    return _imagePickerVc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    _selectedMixPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    [self configCollectionView];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)configCollectionView {
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    _layout = [[LxGridViewFlowLayout alloc] init];
    
    _column = 4;
    _margin = 10;
    _itemWH = (self.view.tz_width - (_column + 1)  * _margin) / _column;
    _layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    _layout.minimumInteritemSpacing = _margin;
    _layout.minimumLineSpacing = _margin;
    
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    CGFloat rgb = 244 / 255.0;
    _collectionView.backgroundColor = [UIColor redColor];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.scrollEnabled = NO;
    _collectionView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[FGImagePickerCCell class] forCellWithReuseIdentifier:@"FGImagePickerCCell"];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    WeakSelf
    [RACObserve(self.collectionView, contentSize) subscribeNext:^(NSValue *_Nullable x) {
        StrongSelf
        if (x.CGSizeValue.height > 0) {
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(x.CGSizeValue.height + _margin * 2);
            }];
        }
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
   
//    _column = 4;
//    _margin = 10;
//    _itemWH = (self.view.tz_width - (_column + 1)  * _margin) / _column;
//    _layout.itemSize = CGSizeMake(_itemWH, _itemWH);
//    _layout.minimumInteritemSpacing = _margin;
//    _layout.minimumLineSpacing = _margin;
//    [self.collectionView setCollectionViewLayout:_layout];
////    self.collectionView.frame = CGRectMake(0, 0, self.view.tz_width, self.view.tz_height);
//    
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//    [RACObserve(self.collectionView, contentSize) subscribeNext:^(NSValue *_Nullable x) {
//        if (x.CGSizeValue.height > 0) {
//            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.mas_equalTo(x.CGSizeValue.height);
//            }];
//        }
//    }];
}

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _selectedMixPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FGImagePickerCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FGImagePickerCCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    
    if (indexPath.row == _selectedMixPhotos.count ) {
        cell.imageView.image = [UIImage imageNamed:self.addBtnImgPath];
        cell.deleteBtn.hidden = YES;
        cell.gifLable.hidden = YES;
        if (_selectedMixPhotos.count == _maxCountTF) {
            cell.imageView.image = nil;
        }
    } else {
        id obj = _selectedMixPhotos[indexPath.row];
        if ([obj isKindOfClass:[NSString class]]) {
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:UIImageWithName(@"default_square_image_7")];
//            [cell.imageView setImageURL:[NSURL URLWithString:obj]];
            cell.asset = nil;
        }else{
            cell.imageView.image = _selectedMixPhotos[indexPath.row];
            cell.asset = _selectedAssets[indexPath.row];
        }
        cell.deleteBtn.hidden = NO;
    }
    if (!self.allowPickingGifSwitch) {
        cell.gifLable.hidden = YES;
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedMixPhotos.count) {
        BOOL showSheet = self.showSheetSwitch;
        if (showSheet) {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
            [sheet showInView:self.view];
        } else {
            [self pushTZImagePickerController];
        }
    } else { // preview photos or video / 预览照片或者视频
#warning 暂时关闭预览功能，蛋疼
//        id selectedItem = _selectedMixPhotos[indexPath.item];
//        if ([selectedItem isKindOfClass:[NSString class]]) {
            return;
//        }
        
        
        id asset = _selectedAssets[indexPath.row];
        BOOL isVideo = NO;
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = asset;
            isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = asset;
            isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
        }
        if ([[asset valueForKey:@"filename"] containsString:@"GIF"] && self.allowPickingGifSwitch && !self.allowPickingMuitlpleVideoSwitch) {
            TZGifPhotoPreviewController *vc = [[TZGifPhotoPreviewController alloc] init];
            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypePhotoGif timeLength:@""];
            vc.model = model;
            [self presentViewController:vc animated:YES completion:nil];
        } else if (isVideo && !self.allowPickingMuitlpleVideoSwitch) { // perview video / 预览视频
            TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
            vc.model = model;
            [self presentViewController:vc animated:YES completion:nil];
        } else { // preview photos / 预览照片
            NSMutableArray *arr = [NSMutableArray array];
            for (id obj in _selectedAssets) {
                if (![obj isKindOfClass:[NSString class]]) {
                    [arr addObject:obj];
                }
            }
            NSMutableArray *arr1 = [NSMutableArray array];
            for (id obj in _selectedMixPhotos) {
                if (![obj isKindOfClass:[NSString class]]) {
                    [arr1 addObject:obj];
                }
            }
            
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:arr selectedPhotos:arr1 index:indexPath.row];
//            imagePickerVc.delegate = self;
            imagePickerVc.maxImagesCount = self.maxCountTF;
            imagePickerVc.allowPickingGif = self.allowPickingGifSwitch;
            imagePickerVc.allowPickingOriginalPhoto = self.allowPickingOriginalPhotoSwitch;
            imagePickerVc.allowPickingMultipleVideo = self.allowPickingMuitlpleVideoSwitch;
            imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                _selectedMixPhotos = [NSMutableArray arrayWithArray:[self getUrlsArr]];
                _selectedAssets = [NSMutableArray arrayWithArray:[self getUrlsArr]];
                [_selectedMixPhotos addObjectsFromArray:photos];
                [_selectedAssets addObjectsFromArray:assets];
                _isSelectOriginalPhoto = isSelectOriginalPhoto;
                [_collectionView reloadData];
                _collectionView.contentSize = CGSizeMake(0, ((_selectedMixPhotos.count + 2) / 3 ) * (_margin + _itemWH));
            }];
            [self presentViewController:imagePickerVc animated:YES completion:nil];
        }
    }
}

#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < _selectedMixPhotos.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < _selectedMixPhotos.count && destinationIndexPath.item < _selectedMixPhotos.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    UIImage *image = _selectedMixPhotos[sourceIndexPath.item];
    [_selectedMixPhotos removeObjectAtIndex:sourceIndexPath.item];
    [_selectedMixPhotos insertObject:image atIndex:destinationIndexPath.item];
    
    id asset = _selectedAssets[sourceIndexPath.item];
    [_selectedAssets removeObjectAtIndex:sourceIndexPath.item];
    [_selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
    
    [_collectionView reloadData];
}

- (NSMutableArray *)getUrlsArr
{
    NSMutableArray *arr = [NSMutableArray array];
    for (id obj in _selectedMixPhotos) {
        if ([obj isKindOfClass:[NSString class]]) {
            [arr addObject:obj];
        }
    }
    return arr;
}

#pragma mark - TZImagePickerController

- (void)pushTZImagePickerController {
    if (self.maxCountTF <= 0) {
        return;
    }
    NSInteger maxCount = self.maxCountTF - [[self getUrlsArr] count];
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxCount columnNumber:self.columnNumberTF delegate:self pushPhotoPickerVc:YES];
//    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxCount delegate:self];
    
    // imagePickerVc.navigationBar.translucent = NO;
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
//    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
//
    if (self.maxCountTF > 1) {
        // 1.设置目前已经选中的图片数组
        NSMutableArray *arr = [NSMutableArray array];
        for (id obj in _selectedAssets) {
            if (![obj isKindOfClass:[NSString class]]) {
                [arr addObject:obj];
            }
        }
        imagePickerVc.selectedAssets = arr; // 目前已经选中的图片数组
    }
//    imagePickerVc.allowTakePicture = self.showTakePhotoBtnSwitch; // 在内部显示拍照按钮
//
//    // imagePickerVc.photoWidth = 1000;
//
//    // 2. Set the appearance
//    // 2. 在这里设置imagePickerVc的外观
//    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
//    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
//    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
//    // imagePickerVc.navigationBar.translucent = NO;
//
//    // 3. Set allow picking video & photo & originalPhoto or not
//    // 3. 设置是否可以选择视频/图片/原图
//    imagePickerVc.allowPickingVideo = self.allowPickingVideoSwitch;
//    imagePickerVc.allowPickingImage = self.allowPickingImageSwitch;
//    imagePickerVc.allowPickingOriginalPhoto = self.allowPickingOriginalPhotoSwitch;
//    imagePickerVc.allowPickingGif = self.allowPickingGifSwitch;
//
//
//    // 4. 照片排列按修改时间升序
//    imagePickerVc.sortAscendingByModificationDate = self.sortAscendingSwitch;
//
//    // imagePickerVc.minImagesCount = 3;
//    // imagePickerVc.alwaysEnableDoneBtn = YES;
//
//    // imagePickerVc.minPhotoWidthSelectable = 3000;
//    // imagePickerVc.minPhotoHeightSelectable = 2000;
//
//    /// 5. Single selection mode, valid when maxImagesCount = 1
//    /// 5. 单选模式,maxImagesCount为1时才生效
//    imagePickerVc.showSelectBtn = NO;
//    imagePickerVc.allowCrop = self.allowCropSwitch;
//    imagePickerVc.needCircleCrop = self.needCircleCropSwitch;
//    // 设置竖屏下的裁剪尺寸
//    imagePickerVc.cropRect = self.cropRect;
//    // 设置横屏下的裁剪尺寸
//    // imagePickerVc.cropRectLandscape = CGRectMake((self.view.tz_height - widthHeight) / 2, left, widthHeight, widthHeight);
//    /*
//     [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
//     cropView.layer.borderColor = [UIColor redColor].CGColor;
//     cropView.layer.borderWidth = 2.0;
//     }];*/
//
//    //imagePickerVc.allowPreview = NO;
//
//    imagePickerVc.isStatusBarDefault = NO;
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    WeakSelf
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        StrongSelf
        if (self.didFinishPickingPhotosHandle) {
            NSMutableArray *arr = [self getUrlsArr];
            [arr addObjectsFromArray:photos];
            self.didFinishPickingPhotosHandle(arr, assets, isSelectOriginalPhoto);
        }
    }];

    [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage, id asset) {
        StrongSelf
        if (self.didFinishPickingVideoHandle) {
            self.didFinishPickingVideoHandle(coverImage, asset);
        }
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - UIImagePickerController

- (void)takePhoto
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        if (iOS7Later) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self takePhoto];
                    });
                }
            }];
        } else {
            [self takePhoto];
        }
        // 拍照之前还需要检查相册权限
    } else if ([TZImageManager authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else if ([TZImageManager authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

// 调用相机
- (void)pushImagePickerController {
    // 提前定位
//    __weak typeof(self) weakSelf = self;
//    [[TZLocationManager manager] startLocationWithSuccessBlock:^(CLLocation *location, CLLocation *oldLocation) {
//        weakSelf.location = location;
//    } failureBlock:^(NSError *error) {
//        weakSelf.location = nil;
//    }];
    

    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        if(iOS8Later) {
            _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = self.sortAscendingSwitch;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image location:self.location completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        if (self.allowCropSwitch) { // 允许裁剪,去裁剪
                            TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
                                [self refreshCollectionViewWithAddedAsset:asset image:cropImage];
                                
                                if (self.didFinishPickingPhotosHandle) {
                                    self.didFinishPickingPhotosHandle(@[cropImage], @[asset], NO);
                                }
                            }];
                            imagePicker.needCircleCrop = self.needCircleCropSwitch;
                            imagePicker.circleCropRadius = 100;
                            imagePicker.cropRect = self.cropRect;
                            [self presentViewController:imagePicker animated:YES completion:nil];
                        } else {
                            [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                            if (self.didFinishPickingPhotosHandle) {
                                self.didFinishPickingPhotosHandle(@[image], @[assetModel.asset], NO);
                            }
                        }
                    }];
                }];
            }
        }];
    }
}

- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    [_selectedAssets addObject:asset];
    [_selectedMixPhotos addObject:image];
    [_collectionView reloadData];
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        NSLog(@"location:%@",phAsset.location);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { // take photo / 去拍照
        [self takePhoto];
    } else if (buttonIndex == 1) {
        [self pushTZImagePickerController];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        } 
    }
}

#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

// The picker should dismiss itself; when it dismissed these handle will be called.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedMixPhotos = [NSMutableArray arrayWithArray:[self getUrlsArr]];
    _selectedAssets = [NSMutableArray arrayWithArray:[self getUrlsArr]];
    [_selectedMixPhotos addObjectsFromArray:photos];
    [_selectedAssets addObjectsFromArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
    
    // 1.打印图片名字
    [self printAssetsName:assets];
    // 2.图片位置信息
    if (iOS8Later) {
        for (PHAsset *phAsset in assets) {
            NSLog(@"location:%@",phAsset.location);
        }
    }
}

// If user picking a video, this callback will be called.
// If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    _selectedMixPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    // open this code to send video / 打开这段代码发送视频
    // [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
    // NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
    // Export completed, send video here, send by outputPath or NSData
    // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    
    // }];
    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

// If user picking a gif image, this callback will be called.
// 如果用户选择了一个gif图片，下面的handle会被执行
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(id)asset {
    _selectedMixPhotos = [NSMutableArray arrayWithArray:@[animatedImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    [_collectionView reloadData];
}

// Decide album show or not't
// 决定相册显示与否
- (BOOL)isAlbumCanSelect:(NSString *)albumName result:(id)result {
    /*
     if ([albumName isEqualToString:@"个人收藏"]) {
     return NO;
     }
     if ([albumName isEqualToString:@"视频"]) {
     return NO;
     }*/
    return YES;
}

// Decide asset show or not't
// 决定asset显示与否
- (BOOL)isAssetCanSelect:(id)asset {
    /*
     if (iOS8Later) {
     PHAsset *phAsset = asset;
     switch (phAsset.mediaType) {
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
     } else {
     ALAsset *alAsset = asset;
     NSString *alAssetType = [[alAsset valueForProperty:ALAssetPropertyType] stringValue];
     if ([alAssetType isEqualToString:ALAssetTypeVideo]) {
     // 视频时长
     // NSTimeInterval duration = [[alAsset valueForProperty:ALAssetPropertyDuration] doubleValue];
     return NO;
     } else if ([alAssetType isEqualToString:ALAssetTypePhoto]) {
     // 图片尺寸
     CGSize imageSize = alAsset.defaultRepresentation.dimensions;
     if (imageSize.width > 3000) {
     // return NO;
     }
     return YES;
     } else if ([alAssetType isEqualToString:ALAssetTypeUnknown]) {
     return NO;
     }
     }*/
    return YES;
}

#pragma mark - Set/Get

- (void)setImageUrls:(NSArray *)imageUrls
{
    _imageUrls = imageUrls;
    _selectedMixPhotos = [NSMutableArray arrayWithArray:imageUrls];
    _selectedAssets = [NSMutableArray arrayWithArray:imageUrls];
    [self.collectionView reloadData];
}

#pragma mark - Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedMixPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
    
    if (self.didFinishPickingPhotosHandle) {
        self.didFinishPickingPhotosHandle(_selectedMixPhotos, _selectedAssets, _isSelectOriginalPhoto);
    }
}


- (void)setShowTakePhotoBtnSwitch:(BOOL)showTakePhotoBtnSwitch
{
    _showTakePhotoBtnSwitch = showTakePhotoBtnSwitch;
    if (showTakePhotoBtnSwitch) {
        _showSheetSwitch = NO;
        _allowPickingImageSwitch = YES;
    }
}

- (void)setShowSheetSwitch:(BOOL)showSheetSwitch
{
    _showSheetSwitch = showSheetSwitch;
    if (showSheetSwitch) {
        _showTakePhotoBtnSwitch = NO;
        _allowPickingImageSwitch = YES;
    }
}

- (void)setAllowPickingOriginalPhotoSwitch:(BOOL)allowPickingOriginalPhotoSwitch
{
    _allowPickingOriginalPhotoSwitch = allowPickingOriginalPhotoSwitch;
    if (allowPickingOriginalPhotoSwitch) {
        _allowPickingImageSwitch = YES;
        _needCircleCropSwitch = NO;
        _allowCropSwitch = NO;
    }
}

- (void)setAllowPickingImageSwitch:(BOOL)allowPickingImageSwitch
{
    _allowPickingImageSwitch = allowPickingImageSwitch;
    if (allowPickingImageSwitch) {
        _allowPickingOriginalPhotoSwitch = NO;
        _showTakePhotoBtnSwitch = NO;
        _allowPickingVideoSwitch = YES;
        _allowPickingGifSwitch = NO;
    }
}

- (void)setAllowPickingGifSwitch:(BOOL)allowPickingGifSwitch
{
    _allowPickingGifSwitch = allowPickingGifSwitch;
    if (allowPickingGifSwitch) {
        _allowPickingImageSwitch = YES;
    }else if (!_allowPickingVideoSwitch){
        _allowPickingMuitlpleVideoSwitch = NO;
    }
}

- (void)setAllowPickingVideoSwitch:(BOOL)allowPickingVideoSwitch
{
    _allowPickingVideoSwitch = allowPickingVideoSwitch;
    if (!allowPickingVideoSwitch) {
        _allowPickingImageSwitch = YES;
        if (!_allowPickingGifSwitch) {
            _allowPickingMuitlpleVideoSwitch = NO;
        }
    }
}

- (void)setAllowCropSwitch:(BOOL)allowCropSwitch
{
    _allowCropSwitch = allowCropSwitch;
    if (allowCropSwitch) {
        _maxCountTF = 1;
        _allowPickingOriginalPhotoSwitch = NO;
    }else{
        if (_maxCountTF == 1) {
            _maxCountTF = 9;
        }
        _needCircleCropSwitch = NO;
    }
}

- (void)setNeedCircleCropSwitch:(BOOL)needCircleCropSwitch
{
    _needCircleCropSwitch = needCircleCropSwitch;
    if (needCircleCropSwitch) {
        _allowCropSwitch = YES;
        _maxCountTF = 1;
        _allowPickingOriginalPhotoSwitch = NO;
    }
}

- (IBAction)allowPickingMultipleVideoSwitchClick:(UISwitch *)sender {
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Private

/// 打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    for (id asset in assets) {
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = (PHAsset *)asset;
            fileName = [phAsset valueForKey:@"filename"];
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = (ALAsset *)asset;
            fileName = alAsset.defaultRepresentation.filename;;
        }
        DLog(@"图片名字:%@",fileName);
    }
}

#pragma clang diagnostic pop

@end

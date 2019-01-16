//
//  FGImagePickerVC.h
//  yiquanqiu
//
//  Created by Eric on 2017/7/24.
//  Copyright © 2017年 YangWeiCong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface FGImagePickerVC : UIViewController

// The picker should dismiss itself; when it dismissed these handle will be called.
// You can also set autoDismiss to NO, then the picker don't dismiss itself.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的handle
// 你也可以设置autoDismiss属性为NO，选择器就不会自己dismis了
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它

@property (nonatomic, strong) NSArray *imageUrls; //传入的默认选中的网络图片

// If user picking a video, this handle will be called.
// If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
@property (nonatomic, copy) void (^didFinishPickingVideoHandle)(UIImage *coverImage,id asset);

@property (nonatomic, copy) void (^didFinishPickingPhotosHandle)(NSArray<id > *photos,NSArray *assets,BOOL isSelectOriginalPhoto);

@property (assign, nonatomic) BOOL showTakePhotoBtnSwitch;  ///< 在内部显示拍照按钮
@property (assign, nonatomic) BOOL sortAscendingSwitch;     ///< 照片排列按修改时间升序
@property (assign, nonatomic) BOOL allowPickingVideoSwitch; ///< 允许选择视频
@property (assign, nonatomic) BOOL allowPickingImageSwitch; ///< 允许选择图片
@property (assign, nonatomic) BOOL allowPickingGifSwitch; ///< 允许选择GIF图片
@property (assign, nonatomic) BOOL allowPickingOriginalPhotoSwitch; ///< 允许选择原图
@property (assign, nonatomic) BOOL showSheetSwitch; ///< 显示一个sheet,把拍照按钮放在外面
@property (assign, nonatomic) NSInteger maxCountTF;  ///< 照片最大可选张数，设置为1即为单选模式
@property (assign, nonatomic) NSInteger columnNumberTF; ///< 每行展示照片张数
@property (assign, nonatomic) BOOL allowCropSwitch; ///< 单选模式下允许裁剪
@property (assign, nonatomic) BOOL needCircleCropSwitch; ///< 使用圆形裁剪框
@property (assign, nonatomic) BOOL allowPickingMuitlpleVideoSwitch; ///< 允许多视频/GIF图片

@property (nonatomic) CGRect cropRect;
@property (nonatomic, strong) NSString *addBtnImgPath;

- (void)takePhoto;
- (void)pushTZImagePickerController;

@end

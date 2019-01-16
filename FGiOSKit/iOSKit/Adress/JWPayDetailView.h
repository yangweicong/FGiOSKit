//
//  YIPayDetailView.h
//  shuaishuai
//
//  Created by 陈经纬 on 17/4/12.
//  Copyright © 2017年 figo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JWPayItemView : UIControl
@property (nonatomic, strong) UIImageView *modeIV;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *chooseIV;
@end

@interface JWPayDetailView : UIView

@property (nonatomic, copy) void(^callBackPayType)(NSInteger tag);// 从0开始


/**
 初始化方法

 @param images 左边图片数组,可以是本地图片字符串或者网络图片地址
 @param titles 支付方式标题
 @param rightNorImage 右边未选择图片
 @param rightSelImage 右边选择图片
 @return <#return value description#>
 */
- (instancetype)initWithLeftImage:(NSArray<NSString *>*)images titles:(NSArray <NSString *>*)titles rightNorImage:(NSString *)rightNorImage rightSelImage:(NSString *)rightSelImage;

+ (instancetype)payDetailViewWithLeftImage:(NSArray<NSString *>*)images titles:(NSArray <NSString *>*)titles rightNorImage:(NSString *)rightNorImage rightSelImage:(NSString *)rightSelImage;


@property (nonatomic,assign)BOOL cancalSelectAll;///< 全部取消选中
@end

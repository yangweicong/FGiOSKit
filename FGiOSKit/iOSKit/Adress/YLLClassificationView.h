//
//  YLLClassificationView.h
//  yulala
//
//  Created by 李俊宇 on 2018/12/11.
//  Copyright © 2018年 YangWeiCong. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface YLLItemView : UIControl

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *chooseIV;
@end


@interface YLLClassificationView : UIView

@property (nonatomic, copy) void(^callBackType)(NSInteger tag);// 从0开始





/**
 初始化方法
 
 
 @param titles 标题
 @param leftNorImage 左边未选择图片
 @param leftSelImage 左边选择图片
 @return <#return value description#>
 */
- (instancetype)initWithTitles:(NSArray <NSString *>*)titles leftNorImage:(NSString *)leftNorImage leftSelImage:(NSString *)leftSelImage tag:(NSInteger)tag;

+ (instancetype)classificationViewTitles:(NSArray <NSString *>*)titles leftNorImage:(NSString *)leftNorImage leftSelImage:(NSString *)leftSelImage tag:(NSInteger)tag;


@property (nonatomic,assign)BOOL cancalAll;///< 全部取消选中

@end

//
//  ICGroupBtnsView.h
//  ichezhidao
//
//  Created by qiuxiaofeng on 16/7/7.
//  Copyright © 2016年 figo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGBaseTouchView.h"

@interface FGGroupBtnsModel : NSObject

@property (nonatomic, copy) NSString *titleString;  ///< 标题
@property (nonatomic, copy) NSString *imageString;  ///< 图片
@property (nonatomic, strong) UIColor *btnTitleColor;  ///< 标题颜色
@property (nonatomic, assign) CGFloat btnTitleFont;  ///< 标题大小 (默认为14)

@property (nonatomic, assign) CGFloat btnTop;  ///< 距离顶部边距 (默认为8)
@property (nonatomic, assign) CGFloat btnBottom;  ///< 距离顶部边距 (默认为8)
@property (nonatomic, assign) CGFloat btnSpace;  ///< 中间距离 (默认为8)

@end



@interface FGGroupBtnsView : FGBaseTouchView

@property (nonatomic, copy) void (^didSelectedIndex) (NSInteger index, NSString *title);

/**
 @param models 数据源
 @param width 宽度
 @param column 列数
 */
- (instancetype)initWithModel:(NSArray<FGGroupBtnsModel*> *)models width:(CGFloat)width column:(NSInteger)column;

@end

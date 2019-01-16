//
//  DSManageAddressCell.h
//  DaoShiBiao
//
//  Created by 陈经纬 on 2017/8/3.
//  Copyright © 2017年 YangWeiCong. All rights reserved.
//

#import "FGBaseTableViewCell.h"

@interface FGManageAddressCell : FGBaseTableViewCell
@property (nonatomic, copy) void (^defaultAddressBtnClick)(UIButton *sender);
@property (nonatomic, copy) void (^editBtnClick)(void);
@property (nonatomic, copy) void (^deleteBtnClick)(void);
@end

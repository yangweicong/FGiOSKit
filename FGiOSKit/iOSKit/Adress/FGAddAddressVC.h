//
//  YSAddressVC.h
//  YaYouShangCheng
//
//  Created by qiuxiaofeng on 2018/1/15.
//  Copyright © 2018年 YangWeiCong. All rights reserved.
//

#import "FGBaseViewController.h"
#import "YSAddressModel.h"

@interface FGAddAddressVC : FGBaseViewController

@property (nonatomic,copy) void ((^saveSucess)(void));///<保存成功的回调
@property (nonatomic, strong) YSAddressModel *addrModel;

@end

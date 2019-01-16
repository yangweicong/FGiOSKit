//
//  FGManageAddressVC.h
//  YaYouShangCheng
//
//  Created by qiuxiaofeng on 2018/1/16.
//  Copyright © 2018年 YangWeiCong. All rights reserved.
//

#import "FGBaseRefreshTableViewController.h"
#import "YSAddressModel.h"
@interface FGManageAddressVC : FGBaseRefreshTableViewController
@property (nonatomic,copy) void ((^didSelect)(YSAddressModel *item));///<<#name#>
@end

//
//  YSAddressModel.h
//  YaYouShangCheng
//
//  Created by qiuxiaofeng on 2018/1/19.
//  Copyright © 2018年 YangWeiCong. All rights reserved.
//

#import "FGBaseModel.h"

@interface YSAddressModel : FGBaseModel
@property (nonatomic,copy) NSString *user_id;///<name
@property (nonatomic,copy) NSString *province;///<<#name#>
@property (nonatomic,copy) NSString *city;///<name
@property (nonatomic, copy) NSString *district;  ///< <#name#>
@property (nonatomic,copy) NSString *address;///<name
@property (nonatomic,copy) NSString *contact_name;///<name
@property (nonatomic, copy) NSString *contact_phone;  ///< <#name#>
@property (nonatomic,assign) BOOL is_default;///<name

@end

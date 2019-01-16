//
//  YSRegionModel.h
//  YaYouShangCheng
//
//  Created by blaceman on 2018/1/15.
//  Copyright © 2018年 YangWeiCong. All rights reserved.
//


@interface YSRegionModel : NSObject

@property (nonatomic,copy) NSString *name;///<<#name#>
@property (nonatomic,copy) NSString *path;///<name
@property (nonatomic,copy) NSString *value;///<<#name#>
@property (nonatomic, assign) BOOL has_children;  ///< 是否有子级

@end

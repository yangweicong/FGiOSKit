//
//  GDMapManager.h
//  yulala
//
//  Created by Eric on 2018/12/24.
//  Copyright © 2018 YangWeiCong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 高德 地图 管理类
 */
@interface GDMapManager : NSObject<AMapLocationManagerDelegate>

+ (instancetype)sharedInstance;

@property (nonatomic, strong) AMapLocationManager *locationManager;  ///< <#Description#>

@property (nonatomic, strong) CLLocation *location;  ///< <#Description#>
@property (nonatomic, strong) AMapLocationReGeocode *reGeocode;  ///< <#Description#>

//单次定位。
- (BOOL)requestLocationWithReGeocodeCompletionBlock:(AMapLocatingCompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END

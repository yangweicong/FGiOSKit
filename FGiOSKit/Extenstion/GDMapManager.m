//
//  GDMapManager.m
//  yulala
//
//  Created by Eric on 2018/12/24.
//  Copyright © 2018 YangWeiCong. All rights reserved.
//

#import "GDMapManager.h"

@implementation GDMapManager

+ (instancetype)sharedInstance
{
    static GDMapManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance setup];
    });
    return sharedInstance;
}

- (void)setup
{
    _locationManager = [[AMapLocationManager alloc] init];
    
    
}

- (BOOL)requestLocationWithReGeocodeCompletionBlock:(AMapLocatingCompletionBlock)completionBlock
{
    return [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
          //设置默认
//        if (IsEmpty(regeocode.city)) {
//            regeocode.city = @"广州市";
//            location = [[CLLocation alloc] initWithLatitude:26.5942057 longitude:106.590507];
//        }
        
        self.location = location;
        self.reGeocode = regeocode;
        
        if (completionBlock) {
            completionBlock(location,regeocode,error);
        }
        
        
    }];
}

@end

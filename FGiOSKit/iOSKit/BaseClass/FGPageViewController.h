//
//  FGPageViewController.h
//  figoioskit
//
//  Created by qiuxiaofeng on 2018/2/27.
//  Copyright © 2018年 qiuxiaofeng. All rights reserved.
//

#import <WMPageController/WMPageController.h>
#import <EasyNavigation/EasyNavigation.h>
#define  kWMMenuViewHeight  44.0
typedef NS_ENUM(NSUInteger, WMMenuViewPosition) {
    WMMenuViewPositionDefault,
    WMMenuViewPositionBottom,
};


@interface FGPageViewController : WMPageController

@property (nonatomic, assign) WMMenuViewPosition menuViewPosition;

@property (nonatomic, strong) UIView *headerView;

- (void)setupViewcontrollers:(NSArray *)controllers titles:(NSArray *)titles;

@end

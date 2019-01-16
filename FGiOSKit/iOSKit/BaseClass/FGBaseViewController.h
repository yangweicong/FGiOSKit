//
//  FGBaseViewController.h
//  figoioskit
//
//  Created by qiuxiaofeng on 2018/2/24.
//  Copyright © 2018年 qiuxiaofeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EasyNavigation/EasyNavigation.h>
#import "FGScrollView.h"

@interface FGBaseViewController : UIViewController

@property (nonatomic, strong) FGScrollView *bgScrollView;

//创建UI
- (void)setupViews;

//UI布局
- (void)setupLayout;

@end

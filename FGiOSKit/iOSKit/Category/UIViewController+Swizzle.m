//
//  UIViewController+Swizzle.m
//  designer
//
//  Created by wujunyang on 16/3/2.
//  Copyright © 2016年 zhangchun. All rights reserved.
//

#import "UIViewController+Swizzle.h"
#import "FGUmengAnalyticsHelper.h"

@implementation UIViewController (Swizzle)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL origSel = @selector(viewDidAppear:);
        SEL swizSel = @selector(swiz_viewDidAppear:);
        [UIViewController swizzleMethods:[self class] originalSelector:origSel swizzledSelector:swizSel];
        
        SEL vcWillAppearSel=@selector(viewWillAppear:);
        SEL swizWillAppearSel=@selector(swiz_viewWillAppear:);
        [UIViewController swizzleMethods:[self class] originalSelector:vcWillAppearSel swizzledSelector:swizWillAppearSel];
        
        SEL vcDidDisappearSel=@selector(viewDidDisappear:);
        SEL swizDidDisappearSel=@selector(swiz_viewDidDisappear:);
        [UIViewController swizzleMethods:[self class] originalSelector:vcDidDisappearSel swizzledSelector:swizDidDisappearSel];
        
        SEL vcWillDisappearSel=@selector(viewWillDisappear:);
        SEL swizWillDisappearSel=@selector(swiz_viewWillDisappear:);
        [UIViewController swizzleMethods:[self class] originalSelector:vcWillDisappearSel swizzledSelector:swizWillDisappearSel];
        
        SEL vcViewDidLoadSel=@selector(viewDidLoad);
        SEL swizViewDidLoadSel=@selector(swiz_viewDidLoad);
        [UIViewController swizzleMethods:[self class] originalSelector:vcViewDidLoadSel swizzledSelector:swizViewDidLoadSel];
    });
}

+ (void)swizzleMethods:(Class)class originalSelector:(SEL)origSel swizzledSelector:(SEL)swizSel
{
    Method origMethod = class_getInstanceMethod(class, origSel);
    Method swizMethod = class_getInstanceMethod(class, swizSel);
    
    //class_addMethod will fail if original method already exists
    BOOL didAddMethod = class_addMethod(class, origSel, method_getImplementation(swizMethod), method_getTypeEncoding(swizMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizSel, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        //origMethod and swizMethod already exist
        method_exchangeImplementations(origMethod, swizMethod);
    }
}

- (void)swiz_viewDidLoad{
//    if (self.navigationController) {
//        UIImage *buttonNormal = [[UIImage imageNamed:@"ic_arrow_left_return_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        [self.navigationController.navigationBar setBackIndicatorImage:buttonNormal];
//        [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:buttonNormal];
//        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//        self.navigationItem.backBarButtonItem = backItem;
//    }
    [self swiz_viewDidLoad];
}


- (void)swiz_viewDidAppear:(BOOL)animated
{
    //可以对控制器名称做过滤 达到过滤哪些是不操作
//    NSString *curClassName=NSStringFromClass([self class]);
//    if (curClassName.length>0&&([curClassName isEqualToString:@"ZUHomeRecommendViewController"]||[curClassName isEqualToString:@"ZUHomeServiceViewController"]||[curClassName isEqualToString:@"ZUHomeBroadcastViewController"]||[curClassName isEqualToString:@"ZUHomeMineViewController"])) {
//        [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
//    }
    [self swiz_viewDidAppear:animated];
}

-(void)swiz_viewWillAppear:(BOOL)animated
{
    
    if ([[self.navigationController childViewControllers] count] > 1) {
    }
    
    //umeng跟踪page 以本项目的VC页面才进入友盟统计
    if ([self filterZUPages]) {
        [FGUmengAnalyticsHelper beginLogPageView:[self class]];
    }
    
    [self swiz_viewWillAppear:animated];
}

-(void)swiz_viewDidDisappear:(BOOL)animated
{
    //umeng跟踪page 以开头本项目的VC页面才进入友盟统计
    if ([self filterZUPages]) {
    [FGUmengAnalyticsHelper endLogPageView:[self class]];
    }
    [self swiz_viewDidDisappear:animated];
}

-(void)swiz_viewWillDisappear:(BOOL)animated
{
    [self swiz_viewWillDisappear:animated];
}

//过滤掉一些不要统计的页面
-(BOOL)filterZUPages
{
    return YES;
//    BOOL result=NO;
//    //以ZU开头不统计的页面 H5页面已经在里面实现进行友盟统计特殊要求
//    NSArray *myfilterArray= @[@"ZUNavigationController",@"ZUHomeViewController",@"ZUWebViewController"];
//    //不是以ZU开头但要统计的页面
//    NSArray *includeArray=@[@"RCPublicServiceWebViewController",@"MWPhotoBrowser"];
//    //以ZU开头本项目的VC页面才进入友盟统计
//    if ([NSStringFromClass([self class]) hasPrefix:@"ZU"]&&![myfilterArray containsObject:NSStringFromClass([self class])]) {
//        result=YES;
//    }
//    if ([includeArray containsObject:NSStringFromClass([self class])]) {
//        result=YES;
//    }
//    
//    return result;
}
@end

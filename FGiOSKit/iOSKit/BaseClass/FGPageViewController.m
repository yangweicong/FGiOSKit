//
//  FGPageViewController.m
//  figoioskit
//
//  Created by qiuxiaofeng on 2018/2/27.
//  Copyright © 2018年 qiuxiaofeng. All rights reserved.
//

#import "FGPageViewController.h"
#import "FGBaseNavigationController.h"



@interface WMPanGestureRecognizer : UIPanGestureRecognizer<UIGestureRecognizerDelegate>

@end


@implementation WMPanGestureRecognizer

- (instancetype)initWithTarget:(id)target action:(SEL)action {
    if (self = [super initWithTarget:target action:action]) {
        self.delegate = self;
    }
    return self;
}

#pragma mark - Gesture Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"WMScrollView")]) {
        return NO;
    }
    return YES;
}
@end




@interface FGPageViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) NSArray *viewControllers;
//@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, assign) CGPoint lastPoint;
@property (nonatomic, assign) CGFloat viewTop;
@property (nonatomic, strong) WMPanGestureRecognizer *panGesture;

@end


@implementation FGPageViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIViewController *viewController = self.navigationController.viewControllers.firstObject;
    if (![viewController isEqual:self]) {
        //自定义任意位置侧滑返回
        self.customBackGestureEnabel = YES;
        self.customBackGestureEdge = ScreenWidth_N();
    }
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithRed:168.0/255.0 green:20.0/255.0 blue:4/255.0 alpha:1];
        _lineView.backgroundColor = UIColorFromHex(kColorLine);
    }
    return _lineView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.menuViewStyle == WMMenuViewStyleTriangle || self.menuViewStyle == WMMenuViewStyleLine) {
        [self.view addSubview:self.lineView];
    }
     
    if (self.parentViewController &&  [self.parentViewController isMemberOfClass:[FGBaseNavigationController class]]) {
        [self.navigationView setTitle:@""];

    }
    
    if (self.showOnNavigationBar) {
        [self.navigationView removeAllLeftButton];
    }
    
}

- (void)setupViewcontrollers:(NSArray *)controllers titles:(NSArray *)titles
{
    NSAssert(controllers.count == titles.count, @"标题与子控制器数量不对应！");
    self.titles = titles;
    self.viewControllers = controllers;
    if (self.headerView) {
        self.showOnNavigationBar = NO;
    }
    [self reloadData];
}

- (void)setHeaderView:(UIView *)headerView
{
    _headerView = headerView;
    
//    self.titleSizeNormal = 15;
//    self.titleSizeSelected = 15;
//    self.menuItemWidth = [UIScreen mainScreen].bounds.size.width / self.titles.count;
    self.viewTop = NavigationHeight_N() + headerView.frame.size.height;
//    self.titleColorSelected = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
//    self.titleColorNormal = [UIColor colorWithRed:0.4 green:0.8 blue:0.1 alpha:1.0];
    
    [self.view addSubview:headerView];
    self.panGesture = [[WMPanGestureRecognizer alloc] initWithTarget:self action:@selector(panOnView:)];
    [self.view addGestureRecognizer:self.panGesture];
}

- (void)panOnView:(WMPanGestureRecognizer *)recognizer {
    
    CGPoint currentPoint = [recognizer locationInView:self.view];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.lastPoint = currentPoint;
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint velocity = [recognizer velocityInView:self.view];
        CGFloat targetPoint = velocity.y < 0 ? NavigationHeight_N() : NavigationHeight_N() + self.headerView.frame.size.height;
        NSTimeInterval duration = fabs((targetPoint - self.viewTop) / velocity.y);
        
        if (fabs(velocity.y) * 1.0 > fabs(targetPoint - self.viewTop)) {
            NSLog(@"velocity: %lf", velocity.y);
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.viewTop = targetPoint;
            } completion:nil];
            
            return;
        }
        
    }
    CGFloat yChange = currentPoint.y - self.lastPoint.y;
    
    self.viewTop += yChange;
    self.lastPoint = currentPoint;
}

// MARK: ChangeViewFrame (Animatable)
- (void)setViewTop:(CGFloat)viewTop {
    _viewTop = viewTop;
    
    if (_viewTop <= NavigationHeight_N()) {
        _viewTop = NavigationHeight_N();
    }
    
    if (_viewTop > self.headerView.frame.size.height + NavigationHeight_N()) {
        _viewTop = self.headerView.frame.size.height + NavigationHeight_N();
    }
    
    self.headerView.frame = ({
        CGRect oriFrame = self.headerView.frame;
        oriFrame.origin.y = _viewTop - self.headerView.frame.size.height;
        oriFrame;
    });
    
    [self forceLayoutSubviews];
}

//重写父类方法，把menuview添加到自定义导航栏
- (void)wm_addMenuView {
    WMMenuView *menuView = [[WMMenuView alloc] initWithFrame:CGRectZero];
    menuView.delegate = self;
    menuView.dataSource = self;
    menuView.style = self.menuViewStyle;
    menuView.layoutMode = self.menuViewLayoutMode;
    menuView.progressHeight = self.progressHeight;
    menuView.contentMargin = self.menuViewContentMargin;
    menuView.progressViewBottomSpace = self.progressViewBottomSpace;
    menuView.progressWidths = self.progressViewWidths;
    menuView.progressViewIsNaughty = self.progressViewIsNaughty;
    menuView.progressViewCornerRadius = self.progressViewCornerRadius;
    menuView.showOnNavigationBar = NO;
    if (self.titleFontName) {
        menuView.fontName = self.titleFontName;
    }
    if (self.progressColor) {
        menuView.lineColor = self.progressColor;
    }
    if (self.showOnNavigationBar && self.navigationView) {
        [self.navigationView addTitleView:menuView];
    } else {
        [self.view addSubview:menuView];
    }
    self.menuView = menuView;
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.lineView.frame = CGRectMake(0, CGRectGetMaxY(self.menuView.frame) - kOnePixel, self.view.frame.size.width, kOnePixel);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.viewControllers.count;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    if (self.titles.count > index) {
            return self.titles[index];
    }
    return @"";
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    if (self.viewControllers.count > index) {
            return self.viewControllers[index];
    }
    return [UIViewController new];
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    CGFloat width = [super menuView:menu widthForItemAtIndex:index];
    return width + 20;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    if (self.headerView) {
        return CGRectMake(0, _viewTop, self.view.frame.size.width, kWMMenuViewHeight);
    }
    
    if (self.menuViewPosition == WMMenuViewPositionBottom) {
        menuView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        return CGRectMake(0, self.view.frame.size.height - kWMMenuViewHeight, self.view.frame.size.width, kWMMenuViewHeight);
    }
    CGFloat leftMargin = self.showOnNavigationBar ? 0 : 0;
    CGFloat originY = self.showOnNavigationBar ? StatusBarHeight_N() : CGRectGetMaxY(self.navigationController.navigationBar.frame);
    return CGRectMake(leftMargin, originY, self.view.frame.size.width - 2*leftMargin, kWMMenuViewHeight);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    if (self.headerView) {
        CGFloat originY = _viewTop + kWMMenuViewHeight;
        return CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
    }
    
    if (self.menuViewPosition == WMMenuViewPositionBottom) {
        return CGRectMake(0, NavigationHeight_N(), self.view.frame.size.width, self.view.frame.size.height - NavigationHeight_N() - kWMMenuViewHeight);
    }
    CGFloat originY =  CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
    if (self.menuViewStyle == WMMenuViewStyleTriangle) {
        originY += self.lineView.frame.size.height;
    }
    return CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
}

@end

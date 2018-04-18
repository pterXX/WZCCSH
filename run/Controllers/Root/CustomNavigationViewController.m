//
//  CustomNavigationViewController.m
//  proj
//
//  Created by asdasd on 2017/9/27.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import "CustomNavigationViewController.h"
#import <objc/runtime.h>
#import "xq_BarButtonItem.h"
#import "RVHeadPortrait.h"
@interface CustomNavigationViewController ()

@end

@implementation CustomNavigationViewController
-(instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if (self)
    {
        [self styleMethod];
        self.delegate = self;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self styleMethod];
        self.delegate = self;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    //    //  设置透明的导航栏
//    [CustomNavigationViewController setTransparentVisibleVc:[[CustomNavigationViewController getCurrentVc] class]];
//    //    //  设置标题颜色
//    [CustomNavigationViewController setTitleColorVisibleVc:[[CustomNavigationViewController getCurrentVc] class]];

    //
    if (self.sideMenuViewController && self.viewControllers[0] == self.topViewController) {
        __weak typeof(self) weakSelf = self;
        RVHeadPortrait *rv = [RVHeadPortrait defaultHeadPortraitForBlock:^{
            //  打开菜单栏
            [weakSelf.sideMenuViewController presentLeftMenuViewController];
        }];
        self.topViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rv];
        ///NOTE:RAC 通知
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:KChangeEadPoretraitIconNoteKey object:nil] subscribeNext:^(NSNotification * _Nullable x) {
            [rv.headImgView sd_setImageWithURL:[NSURL URLWithString:x.object] placeholderImage:DEFAULT_HEAD_ICON];
        }];
    }
}

#pragma mark - Public Mothods
- (void)styleMethod
{
//    self.navigationBar.barTintColor = COLOR_MAIN;
    self.navigationBar.tintColor = COLOR_IMPORTANT;
    self.navigationBar.barTintColor = COLOR_EEEEEE;
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_IMPORTANT}];
    [self.navigationBar setTranslucent:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;//禁用掉自动设置的内边距，自行控制controller上index为0的控件以及scrollview控件的位置
    self.edgesForExtendedLayout = UIRectEdgeNone; //这种方式设置，不需要再重新设置index为0的控件的位置以及scrollview的位置，（0，0）默认的依然是从导航栏下面开始算起

//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - UINavigationController Delegate
- (void)restBackItmes:(UIViewController * _Nonnull)viewController {
    viewController.navigationItem.hidesBackButton = YES;
        __weak typeof(self) wkself = self;
    if (self.viewControllers.firstObject != viewController) {
        //  重写返回按钮
        viewController.navigationItem.leftBarButtonItem =  [xq_BarButtonItem backItemWithTouchBlock:^(xq_BarButtonItem *barItem) {
            if (wkself.viewControllers.count == 1)
            {
                [wkself dismissViewControllerAnimated:YES completion:nil];
            }else
            {
                [wkself popViewControllerAnimated:YES];
            }
        }];

    }

    viewController.navigationItem.leftBarButtonItem.tintColor = COLOR_IMPORTANT;

}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//    Class class = [viewController class];
    //  重写返回按钮
    [self restBackItmes:viewController];
//    //  设置透明的导航栏
//    [CustomNavigationViewController setTransparentVisibleVc:class];
//    //  设置标题颜色
//    [CustomNavigationViewController setTitleColorVisibleVc:class];
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [super pushViewController:viewController animated:YES];
}

- (void)mainStyle
{
    self.navigationBar.barTintColor = COLOR_BACKGRORD;
    self.navigationBar.tintColor = COLOR_IMPORTANT;
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_IMPORTANT}];
}

- (void)otherStyle
{
    UITabBarController *tabvc = self.visibleViewController.tabBarController;
    if (tabvc)
    {
        self.navigationBar.barTintColor = tabvc.selectedViewController.view.backgroundColor;
    }else if(self.visibleViewController)
    {
        self.navigationBar.barTintColor = self.visibleViewController.view.backgroundColor;

    }else
    {
        self.navigationBar.barTintColor =  COLOR_MAIN;
    }
    self.navigationBar.tintColor = COLOR_IMPORTANT;
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :COLOR_IMPORTANT}];
}

+ (BOOL)transparentVc:(__unsafe_unretained Class)class{
    NSArray *array = [CustomNavigationViewController transparentVcClass];
    for (NSString *vcClass in array) {
        if ([NSStringFromClass(class) isEqualToString:vcClass]) {
            return YES;
        }
    };
    return NO;
}

+ (UINavigationController *)c_navViewController {
    UINavigationController *resultVC;
    resultVC = [self c_t_navViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self c_t_navViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UINavigationController *)c_t_navViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self c_t_navViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}


+ (UIViewController *)c_topViewController {
    UIViewController *resultVC;
    resultVC = [self c_t_topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self c_t_topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)c_t_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self c_t_topViewController:[(UINavigationController *)vc visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self c_t_topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}


+ (UINavigationController *)getCurrentNav{
    UIViewController *vc = [self c_navViewController];
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)vc;
    }else if ([vc isKindOfClass:[UITabBarController  class]]){
        if ([((UITabBarController *)vc).selectedViewController isKindOfClass:[UINavigationController  class]]){
            return ((UITabBarController *)vc).selectedViewController;
        }
    }
    return nil;
}

+ (UIViewController *)getCurrentVc{
    UIViewController *vc = [self c_topViewController];
    return vc;
}

+ (void)setTitleColorVisibleVc:(__unsafe_unretained Class)class {
    UINavigationController *nav = [self getCurrentNav];
    if (nav) {
        NSDictionary *dict = [NSDictionary dictionaryWithObject:[CustomNavigationViewController getTitleColorForVcClass:class] forKey:NSForegroundColorAttributeName];
        nav.navigationBar.titleTextAttributes = dict;
    }
}

+ (void)setTransparentVisibleVc:(__unsafe_unretained Class)class {
    UINavigationController *nav = [self getCurrentNav];
    if (nav) {
        MLLog(@"vc Class %@",NSStringFromClass(class));
        UIViewController *vc = [self getCurrentVc];
        
        //  设置透明的导航栏
        if ([self transparentVc:[vc class]]) {
            [nav.navigationBar setShadowImage:[UIImage new]];
            [nav.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        }else{
            UIColor *shadowColor = [self getShadowImageColorForVcClass:[vc class]];
            [nav.navigationBar setShadowImage:shadowColor?[UIImage imageWithColor:shadowColor withSize:CGSizeMake(1, 1)]:nil];
            CGRect frame = nav.navigationBar.frame;
            UIColor *barColor = [self getNavigationBarColorForVcClass:[vc class]];
            [nav.navigationBar setBackgroundImage:[UIImage imageWithColor:barColor withSize:frame.size] forBarMetrics:UIBarMetricsDefault];
        }
    }else{

    }
}

+ (void)setNotTransparentVisibleVc:(__unsafe_unretained Class)class {

}


#pragma mark - Setter
#define kCurtomNavTransparentVcKey @"kCurtomNavTransparentVcKey"
+ (void)setTransparentVcClass:(NSArray *)transparentVcClass
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCurtomNavTransparentVcKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    });

    if (transparentVcClass != nil) {
        NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:kCurtomNavTransparentVcKey];
        if (array == nil) {
            array = [NSArray array];
        }
        NSMutableArray *classArray = [NSMutableArray arrayWithArray:array];
        for (Class class in transparentVcClass) {
            BOOL iskind = NO;
            for (NSString *clStr in array) {
                Class cs =  NSClassFromString(clStr);
                if ([cs isKindOfClass:class]) {
                    iskind = YES;
                    break;
                }
            }
            if (iskind == NO) {
                [classArray addObject:NSStringFromClass(class)];
            }
        }
        [[NSUserDefaults standardUserDefaults] setObject:classArray forKey:kCurtomNavTransparentVcKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NSArray *)transparentVcClass
{
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:kCurtomNavTransparentVcKey];
    if (array == nil) {
        array = [NSArray array];
    }
    return array.mutableCopy;
}

#define AppearanceNavigationBarColorKey [NSString stringWithFormat:@"AppearanceNavigationBarColor%@",[UIDevice appCurVersion]]
#define AppearanceShadowImageColorKey [NSString stringWithFormat:@"AppearanceShadowImageColor%@",[UIDevice appCurVersion]]
#define AppearanceTitleColorKey [NSString stringWithFormat:@"AppearanceTitleColor%@",[UIDevice appCurVersion]]

#define ColorKey(colorprefix,vcClass) [NSString stringWithFormat:@"%@%@%@",colorprefix,vcClass,[UIDevice appCurVersion]]
#define NavigationBarColorKey(vcClass) ColorKey(@"NavigationBarColor",vcClass)
#define ShadowImageColorKey(vcClass) ColorKey(@"ShadowImageColor",vcClass)
#define TitleColorKey(vcClass) ColorKey(@"TitleColor",vcClass)

#pragma mark - Public
+ (NSString *)textDefaultColorStr:(UIColor *)color{
    UIColor *textDefaultColor = color;
    CGColorRef textDefaultColorRef = textDefaultColor.CGColor;
    NSString *textDefaultColorStr = [CIColor colorWithCGColor:textDefaultColorRef].stringRepresentation;
    return textDefaultColorStr;
}

+ (UIColor *)colorWithtextDefaultStr:(NSString *)str
{
    if (str) {
       CIColor *ciColor = [CIColor colorWithString:str];
        if (ciColor == nil) {
            return nil;
        }
//        MLLog(@"CIColor %@",[UIColor colorWithCIColor:ciColor]);
        return [UIColor colorWithRed:ciColor.red green:ciColor.green blue:ciColor.blue alpha:ciColor.alpha];
    }
    return nil;
}

+ (void)removeUserDefaultsKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setUserdefaults:(UIColor *)color forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:[self textDefaultColorStr:color] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (UIColor *)getUserDefaultsColor:(NSString *)key {
    return [self colorWithtextDefaultStr:[[NSUserDefaults standardUserDefaults] objectForKey:key]];
}

+ (void)setAppearanceNavigationBarColor:(UIColor *)color{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:AppearanceNavigationBarColorKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    });
    if (color) {
        [self setUserdefaults:color forKey:AppearanceNavigationBarColorKey];
    }
}

+ (UIColor *)appearanceNavigationBarColor{
    return [self getUserDefaultsColor:AppearanceNavigationBarColorKey]?:[UIColor whiteColor];;
}

+ (void)setAppearanceShadowImageColor:(UIColor *)color{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:AppearanceShadowImageColorKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    });
    if (color) {
        [self setUserdefaults:color forKey:AppearanceShadowImageColorKey];
    }
}

+ (UIColor *)appearanceShadowImageColor{
    return [self getUserDefaultsColor:AppearanceShadowImageColorKey]?:nil;
}

+ (void)setAppearanceTitleColor:(UIColor *)color{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:AppearanceTitleColorKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    });
    if (color) {
        [self setUserdefaults:color forKey:AppearanceTitleColorKey];
    }
}

+ (UIColor *)appearanceTitleColor{
    return [self getUserDefaultsColor:AppearanceTitleColorKey]?:[UIColor blackColor];
}


+ (UIColor *)getNavigationBarColorForVcClass:(Class)vcClass{
    return  [self getUserDefaultsColor:NavigationBarColorKey(NSStringFromClass(vcClass))]?:[self appearanceNavigationBarColor];
}

+ (void)setNavigationBarColor:(UIColor *)color forVcClass:(Class)vcClass{
    
    if (vcClass) {
        [self setUserdefaults:color forKey:NavigationBarColorKey(NSStringFromClass(vcClass))];
    }
}

+ (void)removeNavigationBarColorForVcClass:(Class)vcClass{
    [self removeUserDefaultsKey:NavigationBarColorKey(NSStringFromClass(vcClass))];
}

+ (UIColor *)getShadowImageColorForVcClass:(Class)vcClass{
    return [self getUserDefaultsColor:ShadowImageColorKey(NSStringFromClass(vcClass))]?:[self appearanceShadowImageColor];
}

+ (void)setShadowImageColor:(UIColor *)color forVcClass:(Class)vcClass{
    if (vcClass) {
        [self setUserdefaults:color forKey:ShadowImageColorKey(NSStringFromClass(vcClass))];
    }
}

+ (void)removeShadowImageColorForVcClass:(Class)vcClass
{
    [self removeUserDefaultsKey:ShadowImageColorKey(NSStringFromClass(vcClass))];
}


+ (UIColor *)getTitleColorForVcClass:(Class)vcClass{
    return [self getUserDefaultsColor:TitleColorKey(NSStringFromClass(vcClass))]?:[self appearanceTitleColor];
}

+ (void)setTitleColor:(UIColor *)color forVcClass:(Class)vcClass
{
    if (vcClass) {
        [self setUserdefaults:color forKey:TitleColorKey(NSStringFromClass(vcClass))];
    }
}

+ (void)removeTitleColorForVcClass:(Class)vcClass{
    [self removeUserDefaultsKey:TitleColorKey(NSStringFromClass(vcClass))];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

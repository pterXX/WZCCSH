//
//  CustomTabBarViewController.m
//  proj
//
//  Created by asdasd on 2017/9/27.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import "CustomTabBarViewController.h"
#import "RVHeadPortrait.h"
@interface CustomTabBarViewController ()<UITabBarControllerDelegate>
@property (nonatomic ,strong) RVHeadPortrait *rav;
@end

@implementation CustomTabBarViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self tabbarStyle];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self tabbarStyle];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //  如果根视图不是当前导航栏的话就直接menu的头像,这个只有存在菜单栏的时候才会生效
    if ([[UIApplication sharedApplication].keyWindow.rootViewController isEqual:self.navigationController] == NO && self.sideMenuViewController) {
        __weak typeof(self) weakSelf = self;
        RVHeadPortrait *rv = [RVHeadPortrait defaultHeadPortraitForBlock:^{
            //  打开菜单栏
            [weakSelf.sideMenuViewController presentLeftMenuViewController];
        }];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rv];
        ///NOTE:RAC 通知
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:NSKeyValueChangeNotificationIsPriorKey object:nil] subscribeNext:^(NSNotification * _Nullable x) {
            [rv.headImgView sd_setImageWithURL:[NSURL URLWithString:x.object] placeholderImage:DEFAULT_HEAD_ICON];
        }];
    }

     [self tababrTitle];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self tababrTitle];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [self tababrTitle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Public Methods
- (void)tabbarStyle
{
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.delegate = self;
    self.tabBar.backgroundColor = COLOR_TABBAR_BACKGROUND;
    self.tabBar.tintColor = COLOR_TAB_FONT_SELECTED;
}

//  tabbar 的标题
- (void)tababrTitle
{

}



#pragma mark - Class Methods
+ (id)tabbarItem:(UIImage *)itemImg selectImg:(UIImage *)selectImg vcClass:(Class)vcClass title:(NSString *)title{
    UIViewController  *vc = [[vcClass alloc] init];
    vc.title = title;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [itemImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [selectImg  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return vc;
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

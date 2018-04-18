//
//  SJOtherUtil.h
//  proj
//
//  Created by asdasd on 2017/9/25.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#ifndef SJOtherUtil_h
#define SJOtherUtil_h


// 是否为iOS7
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)
#define iOS10Later ([UIDevice currentDevice].systemVersion.floatValue >= 10.0f)




//  弱引用 强引用
#define XQWeakSelf(type)  __weak typeof(type) weak##type = type;
#define XQStrongSelf(type)  __strong typeof(type) type = weak##type;

//  设置 view 圆角和边框
#define XQViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// 设置 view的阴影
#define XQViewShadow(view,radius,color,opacity,Offset)\
view.layer.shadowColor = color;\
view.layer.shadowOpacity = opacity;\
view.layer.shadowRadius = radius;\
view.layer.shadowOffset = Offset;\


//获取图片资源
#define kGetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]

// 加载
#define kShowNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = YES

// 收起加载
#define HideNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO

// 设置加载
#define NetworkActivityIndicatorVisible(x)  [UIApplication sharedApplication].networkActivityIndicatorVisible = x

//  获取window
#define kWindow [UIApplication sharedApplication].keyWindow
//#define kBackView         for (UIView *item in kWindow.subviews) { \
//if(item.tag == 10000) \
//{ \
//[item removeFromSuperview]; \
//UIView * aView = [[UIView alloc] init]; \
//aView.frame = [UIScreen mainScreen].bounds; \
//aView.tag = 10000; \
//aView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3]; \
//[kWindow addSubview:aView]; \
//} \
//} \
//#define kShowHUDAndActivity kBackView;[MBProgressHUD showHUDAddedTo:kWindow animated:YES];kShowNetworkActivityIndicator()
//#define kHiddenHUD [MBProgressHUD hideAllHUDsForView:kWindow animated:YES]
//#define kRemoveBackView         for (UIView *item in kWindow.subviews) { \
//if(item.tag == 10000) \
//{ \
//[UIView animateWithDuration:0.4 animations:^{ \
//item.alpha = 0.0; \
//} completion:^(BOOL finished) { \
//[item removeFromSuperview]; \
//}]; \
//} \
//} \
//#define kHiddenHUDAndAvtivity kRemoveBackView;kHiddenHUD;HideNetworkActivityIndicator()


//  判断真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device
#endif
#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif


//获取temp
#define kPathTemp NSTemporaryDirectory()
//获取沙盒 Document
#define kPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒 Cache
#define kPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]




//GCD - 一次性执行
#define kDISPATCH_ONCE_BLOCK(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);
//GCD - 在Main线程上运行
#define kDISPATCH_MAIN_THREAD(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), ^{mainQueueBlock});
//GCD - 开启异步线程
#define kDISPATCH_GLOBAL_QUEUE_DEFAULT(globalQueueBlock) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{globalQueueBlock});



//消除一些不必要警告
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


//  打印信息
#ifdef DEBUG
#define MLLog(...) printf("[%s] %s [第%d行]: %s\n", __TIME__ ,__PRETTY_FUNCTION__ ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#else
#define MLLog(...)
#endif


//  字符串长度
#define KLenStr(str) (str.length)
//  删除字符串空格
#define KRemoveNullCharacter(kstr) [kstr stringByReplacingOccurrencesOfString:@" " withString:@""]

//  格式话字符串
#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]
#define KNumberFormat(value) NSStringFormat(@"%@",@(value))

//  当前所在的方法名
#define ML__CMD__  MLLog(@"Method %@",NSStringFromSelector(_cmd));

//  显示当前执行方法的地方
#define ML_SHOW_MESSAGE(message) [MessageToast showMessage:message]; ML__CMD__ ;

//  弹出当前所在方法的方法名
#define ML_SHOW_CMD_ ML_SHOW_MESSAGE(NSStringFromSelector(_cmd))

//  功能暂未实现的 弹出框
#define ML_MESSAGE ML_SHOW_MESSAGE(@"功能暂未实现");return;

#define ML_MESSAGE_NETWORKING ML_SHOW_MESSAGE(@"网络已失联...");

//  便利图片初始化
#define Img(name)  [UIImage imageNamed:name]


#define NONATOMIC_STRONG @property (nonatomic, strong)
#define NONATOMIC_ASSIGN @property (nonatomic, assign)
#define NONATOMIC_COPY @property (nonatomic, copy)

#define KALLVIEW_END_EDITING [[[UIApplication sharedApplication] keyWindow] endEditing:YES]  //  结束编辑
#endif /* SJOtherUtil_h */

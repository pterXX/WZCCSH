//
//  UIScrollView+DataEmptyView.m
//  running man
//
//  Created by asdasd on 2018/3/30.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "UIScrollView+DataEmptyView.h"
#import <YYText.h>
#import <objc/runtime.h>

@implementation UIScrollView (DataEmptyView)
///  设置显示的类型
- (void)setEmptyViewType:(DataEmptyViewType)emptyViewType{
    objc_setAssociatedObject(self, @selector(emptyViewType), @(emptyViewType), OBJC_ASSOCIATION_RETAIN);

    self.emptyImg = nil;
    self.descriptionText = nil;
    self.titleText = nil;
    self.btnImg = nil;
    self.buttonTitle = nil;

    //  如果是自定义加载动画，需要先将加载动画取消掉
    [self.customView xq_stopLoadingAnimation];
    self.customView = nil;
    self.verticalOffset = - self.height / 3.5;

    switch (emptyViewType) {
        case DataEmptyViewTypeNone:
        {

        }
            break;

        case DataEmptyViewTypeNoOrderData:
        {
            self.emptyImg = [UIImage reSizeImage:[UIImage imageNamed:@"order_empty"]
                                          toSize:CGSizeMake(SJAdapter(176), SJAdapter(208))];
            self.descriptionText = [self attributedStringWithString:@"“休息一会儿再“刷新列表”试试"];
            NSString *title = @"附近暂时没有任务";
            NSDictionary *attributes = @{
                                         NSFontAttributeName:[UIFont adjustFont:12],
                                         NSForegroundColorAttributeName:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f]
                                         };
            self.titleText =  [[NSMutableAttributedString alloc] initWithString:title attributes:attributes];
            self.verticalOffset = - SJAdapter(360);
        }
            break;

        case DataEmptyViewTypeCheck:
        {
            self.emptyImg = [UIImage imageNamed:@"data_ empty1"];
            NSString *title = @"您的帐号正在审核中，通过后可接单\n我们会在3个工作日内完成审核，请保持电话畅通";
            self.descriptionText = [self attributedStringWithString:title];
            self.verticalOffset = - SJAdapter(280);
        }
            break;

        case DataEmptyViewTypeStarts:
        {
            self.emptyImg = [UIImage imageNamed:@"data_ empty2"];
            NSString *title = @"你当前处于收工状态，无法接单";
            self.descriptionText = [self attributedStringWithString:title];
            self.verticalOffset = 20;
            self.buttonTitle = [self buttonAttributedStringWithString:@"开工"];
            self.customView = [self dataEmptyViewTypeStartsCustomView];
        }
            break;

        case DataEmptyViewTypeApply:
        {
            self.emptyImg = [UIImage imageNamed:@"apply_data_empty"];
            self.descriptionText = [self attributedStringWithString:@"“不被工作所困，体验不同人生”"];
            self.titleText = [self titleAttributedStringWithString:@"兼职赚钱，灵活自由"];
            self.buttonTitle = [self buttonAttributedStringWithString:@"申请成为跑腿员"];
            self.verticalOffset = 0;
            self.customView = [self dataEmptyViewTypeApplyCustomView];
        }
            break;

        case DataEmptyViewTypeWeChat:
        {
            self.emptyImg = [UIImage imageNamed:@"wallet_icon_weChat"];
            NSString *title = @"你还没有绑定微信，绑定后，提现金额将打到你绑定的微信";
            self.descriptionText = [self attributedStringWithString:title];
            self.verticalOffset = 0;
            self.buttonTitle = [self buttonAttributedStringWithString:@"去绑定"];
            self.customView = [self dataEmptyViewTypeWeChatCustomView];
        }
            break;

        case DataEmptyViewTypeSuccess:
        {
            self.emptyImg = [UIImage imageNamed:@"run_success"];
            NSString *title = @"绑定成功";
            self.descriptionText = [self attributedStringWithString:title];
            self.verticalOffset = - SJAdapter(360);
        }
            break;
        case DataEmptyViewTypeFail:
        {
            self.emptyImg = [UIImage imageNamed:@"run_fail"];
            NSString *title = @"绑定失败";
            self.descriptionText = [self attributedStringWithString:title];
            self.verticalOffset = - SJAdapter(360);
        }
            break;
        case DataEmptyViewTypeNotMsg:
        {
            self.emptyImg = [UIImage imageNamed:@"msg_icon_empty"];
            NSString *title = @"你还没有收到消息呦";
            self.descriptionText = [self attributedStringWithString:title];
            self.verticalOffset = - SJAdapter(360);
        }
            break;

        case DataEmptyViewTypeNoNetwork:
        {
            self.emptyImg = [UIImage imageNamed:@"no_network"];
            NSString *title = @"网络连接失败";
            self.descriptionText = [self attributedStringWithString:title];
            self.verticalOffset = 0;
            self.buttonTitle = [self buttonAttributedStringWithString:@"点击刷新"];
            self.customView = [self dataEmptyViewTypeNoNotworkView];
        }
            break;

        case DataEmptyViewTypeLoading:
        {

            self.verticalOffset = 0;
            self.customView = [self dataEmptyViewTypeLoadingView];
        }
            break;

        case DataEmptyViewTypeOhter:
        {

        }
            break;
        default:
            break;
    }

    [self reloadEmptyDataSet];
}

- (DataEmptyViewType)emptyViewType{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}



///  判断是否显示空数据图
- (void)setIsShowDataEmpty:(BOOL)isShowDataEmpty{

    objc_setAssociatedObject(self, @selector(isShowDataEmpty), @(isShowDataEmpty), OBJC_ASSOCIATION_RETAIN);

    if ([self isMemberOfClass:[UIScrollView class]] && isShowDataEmpty) {
        NSMutableArray *array = [NSMutableArray array];
        for (UIView *subView in self.subviews) {
            if (subView.isHidden == YES) {
                [array addObject:subView];
            }
        }
        //  保存本身已经隐藏的视图
        [self setXqHiddenArr:array];

        for (UIView *subView in self.subviews) {
            subView.hidden = YES;
        }
    }else{
        //  获取在动画没有开始之前本身已经隐藏的视图
        NSArray *array  = [self xqHiddenArr];
        for (UIView *subView in self.subviews) {
            if (array && [array containsObject:subView]) {
                subView.hidden = YES; //   本身已经隐藏的就不需要再加载
            }else{
                subView.hidden = NO;
            }
        }
    }

    if (isShowDataEmpty) {
        self.emptyDataSetSource = self;
        self.emptyDataSetDelegate = self;
    }else{
        self.emptyDataSetSource = nil;
        self.emptyDataSetDelegate = nil;
        [self reloadEmptyDataSet];
    }
}

- (void)setXqHiddenArr:(NSArray *)array{
    objc_setAssociatedObject(self, @selector(xqHiddenArr),array, OBJC_ASSOCIATION_RETAIN);
}
- (NSArray *)xqHiddenArr{
    return objc_getAssociatedObject(self, _cmd);
}

- (BOOL)isShowDataEmpty{
      return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsShowDataEmpty:(BOOL)isShowDataEmpty emptyViewType:(DataEmptyViewType)emptyViewType{
    [self setIsShowDataEmpty:isShowDataEmpty];
    [self setEmptyViewType:emptyViewType];
}


- (void)setVerticalOffset:(CGFloat)verticalOffset{
    objc_setAssociatedObject(self, @selector(verticalOffset), @(verticalOffset), OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)verticalOffset{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setEmptyImg:(UIImage *)emptyImg{
     objc_setAssociatedObject(self, @selector(emptyImg),emptyImg, OBJC_ASSOCIATION_RETAIN);
}

- (UIImage *)emptyImg{
     return objc_getAssociatedObject(self, _cmd);
}

- (void)setBtnImg:(UIImage *)btnImg{
    objc_setAssociatedObject(self, @selector(btnImg),btnImg, OBJC_ASSOCIATION_RETAIN);
}

- (UIImage *)btnImg{
    return objc_getAssociatedObject(self, _cmd);
}

- (UIView *)customView{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCustomView:(UIView *)customView{
    objc_setAssociatedObject(self, @selector(customView),customView, OBJC_ASSOCIATION_RETAIN);
}

- (void)setTitleText:(NSMutableAttributedString *)titleText{
    objc_setAssociatedObject(self, @selector(titleText),titleText, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableAttributedString *)titleText{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setButtonTitle:(NSMutableAttributedString *)buttonTitle{
    objc_setAssociatedObject(self, @selector(buttonTitle),buttonTitle, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableAttributedString *)buttonTitle{
    return objc_getAssociatedObject(self, _cmd);
}


- (void)setDescriptionText:(NSMutableAttributedString *)descriptionText{
    objc_setAssociatedObject(self, @selector(descriptionText),descriptionText, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableAttributedString *)descriptionText{
     return objc_getAssociatedObject(self, _cmd);
}

- (void)setDataEmptyBtnTapedBlock:(void (^)(void))dataEmptyBtnTapedBlock
{
     objc_setAssociatedObject(self, @selector(dataEmptyBtnTapedBlock),dataEmptyBtnTapedBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(void))dataEmptyBtnTapedBlock{
    return objc_getAssociatedObject(self, _cmd);
}

- (NSMutableAttributedString *)attributedStringWithString:(NSString *)str{
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont adjustFont:12],
                                 NSForegroundColorAttributeName:COLOR_666666
                                 };
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str attributes:attributes];
    [text yy_setAlignment:NSTextAlignmentCenter range:text.yy_rangeOfAll];
    [text yy_setLineSpacing:5 range:text.yy_rangeOfAll];
    return text;
}

- (NSMutableAttributedString *)buttonAttributedStringWithString:(NSString *)str{
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont adjustFont:16],
                                 NSForegroundColorAttributeName:COLOR_FFFFFF
                                 };
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str attributes:attributes];
    [text yy_setAlignment:NSTextAlignmentCenter range:text.yy_rangeOfAll];
    return text;
}

- (NSMutableAttributedString *)titleAttributedStringWithString:(NSString *)str{
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont adjustFont:19],
                                 NSForegroundColorAttributeName:COLOR_353535
                                 };
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str attributes:attributes];
    [text yy_setAlignment:NSTextAlignmentCenter range:text.yy_rangeOfAll];
    return text;
}

//  停止加载动画
- (void)stopLoadingAnimation{
    [self.customView xq_stopLoadingAnimation];
}

#pragma mark - DZNEmptyDataSetSource,DZNEmptyDataSetDelegate
/// 空白页显示图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return self.emptyImg;
}

///  空白页显示详细描述
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    return self.descriptionText;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    return self.titleText;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    return SJAdapter(40);
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return self.verticalOffset;
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    return self.customView;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return self.customView?NO:YES;
}


/**
 等待开工的图片自定义视图
 */
- (UIView *)dataEmptyViewTypeStartsCustomView{
    UIView *view = [[UIView alloc] init];
    view.userInteractionEnabled = YES;
    view.width = KWIDTH;
    view.height = self.height;

    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.emptyImg];
    [view addSubview:imageView];

    YYLabel *label = [YYLabel new];
    label.attributedText = self.descriptionText;
    [view addSubview:label];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.userInteractionEnabled = YES;
    UIImage *image = [UIImage imageWithColor:COLOR_FE9928 withSize:CGSizeMake(SJAdapter(500), SJAdapter(88))];
    [btn setBackgroundImage:[image roundedCornerRadius:SJAdapter(6)] forState:UIControlStateNormal];
    [btn setAttributedTitle:self.buttonTitle forState:UIControlStateNormal];

    [view addSubview:btn];

    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.with.sizeOffset(CGSizeMake(SJAdapter(342), SJAdapter(316)));
        make.centerX.equalTo(view);
        make.top.equalTo(view.mas_top).with.offset(SJAdapter(120));
    }];

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.with.sizeOffset(CGSizeMake(SJAdapter(500), SJAdapter(36)));
        make.centerX.equalTo(view);
        make.top.equalTo(imageView.mas_bottom).with.offset(SJAdapter(40));
    }];

    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.with.sizeOffset(CGSizeMake(SJAdapter(700), SJAdapter(88)));
        make.centerX.equalTo(view);
        make.top.equalTo(label.mas_bottom).with.offset(SJAdapter(200));
    }];

    [btn addTarget:self action:@selector(dataEmptyBtnTaped) forControlEvents:UIControlEventTouchUpInside];

    return view;
}

/**
 申请成为跑腿员自定义视图
 */
- (UIView *)dataEmptyViewTypeApplyCustomView{
    UIView *view = [[UIView alloc] init];
    view.userInteractionEnabled = YES;
    view.width = KWIDTH;
    view.height = self.height;

    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.emptyImg];
    [view addSubview:imageView];

    YYLabel *titlelabel = [YYLabel new];
    titlelabel.attributedText = self.titleText;
    [view addSubview:titlelabel];

    YYLabel *label = [YYLabel new];
    label.attributedText = self.descriptionText;
    [view addSubview:label];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.userInteractionEnabled = YES;
    UIImage *image = [UIImage imageWithColor:COLOR_FE9928 withSize:CGSizeMake(SJAdapter(300), SJAdapter(88))];
    [btn setBackgroundImage:[image roundedCornerRadius:SJAdapter(6)] forState:UIControlStateNormal];
    [btn setAttributedTitle:self.buttonTitle forState:UIControlStateNormal];

    [view addSubview:btn];

    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.with.sizeOffset(CGSizeMake(SJAdapter(396), SJAdapter(552)));
        make.centerX.equalTo(view);
        make.top.equalTo(view.mas_top).with.offset(SJAdapter(110));
    }];

    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.with.sizeOffset(CGSizeMake(SJAdapter(400), SJAdapter(50)));
        make.centerX.equalTo(view);
        make.top.equalTo(imageView.mas_bottom).with.offset(SJAdapter(110));
    }];

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.with.sizeOffset(CGSizeMake(SJAdapter(400), SJAdapter(36)));
        make.centerX.equalTo(view);
        make.top.equalTo(titlelabel.mas_bottom).with.offset(SJAdapter(28));
    }];

    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.with.sizeOffset(CGSizeMake(SJAdapter(300), SJAdapter(88)));
        make.centerX.equalTo(view);
        make.top.equalTo(label.mas_bottom).with.offset(SJAdapter(60));
    }];

    [btn addTarget:self action:@selector(dataEmptyBtnTaped) forControlEvents:UIControlEventTouchUpInside];

    return view;
}


/**
 微信提现的图片自定义视图
 */
- (UIView *)dataEmptyViewTypeWeChatCustomView{
    UIView *view = [[UIView alloc] init];
    view.userInteractionEnabled = YES;
    view.width = KWIDTH;
    view.height = self.height;

    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.emptyImg];
    [view addSubview:imageView];

    YYLabel *label = [YYLabel new];
    label.attributedText = self.descriptionText;
    [view addSubview:label];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.userInteractionEnabled = YES;
    UIImage *image = [UIImage imageWithColor:COLOR_FE9928 withSize:CGSizeMake(SJAdapter(500), SJAdapter(88))];
    [btn setBackgroundImage:[image roundedCornerRadius:SJAdapter(6)] forState:UIControlStateNormal];
    [btn setAttributedTitle:self.buttonTitle forState:UIControlStateNormal];

    [view addSubview:btn];

    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.with.sizeOffset(CGSizeMake(SJAdapter(242), SJAdapter(250)));
        make.centerX.equalTo(view);
        make.top.equalTo(view.mas_top).with.offset(SJAdapter(120));
    }];

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.with.sizeOffset(CGSizeMake(SJAdapter(500), SJAdapter(36)));
        make.centerX.equalTo(view);
        make.top.equalTo(imageView.mas_bottom).with.offset(SJAdapter(100));
    }];

    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.with.sizeOffset(CGSizeMake(SJAdapter(500), SJAdapter(88)));
        make.centerX.equalTo(view);
        make.top.equalTo(label.mas_bottom).with.offset(SJAdapter(100));
    }];

    [btn addTarget:self action:@selector(dataEmptyBtnTaped) forControlEvents:UIControlEventTouchUpInside];

    return view;
}


/**
 微信提现的图片自定义视图
 */
- (UIView *)dataEmptyViewTypeNoNotworkView{
    UIView *view = [[UIView alloc] init];
    view.userInteractionEnabled = YES;
    view.width = KWIDTH;
    view.height = self.height;

    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.emptyImg];
    [view addSubview:imageView];

    YYLabel *label = [YYLabel new];
    label.attributedText = self.descriptionText;
    [view addSubview:label];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.userInteractionEnabled = YES;
    UIImage *image = [UIImage imageWithColor:COLOR_FE9928 withSize:CGSizeMake(SJAdapter(200), SJAdapter(60))];
    [btn setBackgroundImage:[image roundedCornerRadius:SJAdapter(30)] forState:UIControlStateNormal];
    [btn setAttributedTitle:self.buttonTitle forState:UIControlStateNormal];

    [view addSubview:btn];

    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.with.sizeOffset(CGSizeMake(SJAdapter(446), SJAdapter(156)));
        make.centerX.equalTo(view);
        make.top.equalTo(view.mas_top).with.offset(SJAdapter(120));
    }];

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.with.sizeOffset(CGSizeMake(SJAdapter(500), SJAdapter(36)));
        make.centerX.equalTo(view);
        make.top.equalTo(imageView.mas_bottom).with.offset(SJAdapter(100));
    }];

    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.with.sizeOffset(CGSizeMake(SJAdapter(200), SJAdapter(60)));
        make.centerX.equalTo(view);
        make.top.equalTo(label.mas_bottom).with.offset(SJAdapter(80));
    }];

    [btn addTarget:self action:@selector(dataEmptyBtnTaped) forControlEvents:UIControlEventTouchUpInside];

    return view;
}


/**
 加载动画的自定义视图
 */
- (UIView *)dataEmptyViewTypeLoadingView{
    UIView *view = [[UIView alloc] init];
    //  显示加载动画
    [view xq_startLoadingAnimation];
    return view;
}

- (void)dataEmptyBtnTaped{
    !self.dataEmptyBtnTapedBlock?:self.dataEmptyBtnTapedBlock();
}


@end

//
//  xq_ShareBottomView.m
//  proj
//
//  Created by asdasd on 2018/1/6.
//  Copyright © 2018年 asdasd. All rights reserved.
//

#import "xq_ShareBottomView.h"
#import "UIButton+Layout.h"
#import "xq_line.h"
#import "ShareUtil.h"
#import "XQLoginExample.h"

@implementation ShareItem


@end

@implementation xq_share : UIView


- (void)shareWithType:(NSInteger)type{

    if (self.shareViewTapBlock){
        self.shareViewTapBlock();
    }
    ShareItem *item = nil;
    if (self.delegate.shareItem)
    {
        item = self.delegate.shareItem;

    }else
    {
        item = self.shareItem;
    }
    NSAssert(item != nil, @"shareItem 不能为空");

    if (item.fileUrl) {
        //  NOTE:分享视频
        [ShareUtil shareShowWithVideoFileUrl:item.fileUrl title:item.title text:item.desc sharetypeNum:type onSuccess:^{

            if (self.shareViewSuccessBlock){
                self.shareViewSuccessBlock();
            }
            //  判断是否有分享的类型
            if (item.atype){
//                [MLHTTPRequest POSTWithURL:ZY_USER_SHARE_LOG parameters:@{@"type":item.atype?:@"0",@"item_id":item.aid?:@""} success:^(MLHTTPRequestResult *result) {
//
//                } failure:^(NSError *error) {
//
//                }];
            }
        }];
    }else{
        //  NOTE:普通分享
        [ShareUtil shareShowWithImage:item.thumb title:item.title url:item.url description:item.desc sharetypeNum:type onSuccess:^{

//
//            //  判断是否有分享的类型
//            if (item.atype){
//                [MLHTTPRequest POSTWithURL:ZY_USER_SHARE_LOG parameters:@{@"type":item.atype?:@"0",@"item_id":item.aid?:@""} success:^(MLHTTPRequestResult *result) {
//
//                } failure:^(NSError *error) {
//
//                }];
//            }
        }];
    }
}

+(CGFloat)head_fixedHeight{
    return 0;
}



+ (void)showShareItem:(ShareItem *)shareItem success:(void(^)(void))success{
    CGRect rect = CGRectMake(0, 0, KWIDTH,[[self class] head_fixedHeight]);
    xq_share *pView = [[[self class] alloc] initWithFrame:rect];
    pView.shareItem = shareItem;

    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [pView setShareViewTapBlock:^{
        [vc.zh_popupController dismiss];
    }];

    [pView setShareViewSuccessBlock:success];

    vc.zh_popupController = [zhPopupController new];
    vc.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
    vc.zh_popupController.dismissOnMaskTouched = YES;
    //    vc.zh_popupController.allowPan = YES;
    [vc.zh_popupController presentContentView:pView];
}

//  微信分享
- (void)shareWeChat{
    [self shareWithType:0];
}

/**
 只分享图片

 @param image 图片
 @param success 成功的回调
 */
+ (void)shareImg:(UIImage *)image success:(void(^)(void))success{
    ShareItem *item = [[ShareItem alloc] init];
    item.thumb = image;
//    item.desc = SHARE_DEFAULT_TITLE;
    [self showShareItem:item success:success];
}


@end

@interface xq_ShareBottomView ()
- (void)_setupViews;
@end

@implementation xq_ShareBottomView
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _setupViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setupViews];
    }
    return self;
}


- (void)_setupViews
{
    self.backgroundColor = [UIColor whiteColor];
    //  占位 Label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SJAdapter(240), 0, KWIDTH / 2, SJAdapter(120))];
    label.textColor = [UIColor colorWithRed:35.0f/255.0f green:35.0f/255.0f blue:35.0f/255.0f alpha:1.0f];
    label.font = [UIFont adjustFont:32];
    label.text = @"分享到";
    [self addSubview:label];

    NSMutableArray<UIButton *> *iconBtnArr = [NSMutableArray array];
    NSArray *iconArray = @[@"share_weixin_50",@"share_pyq_50",@"share_qq_50",@"share_zone_50"];
    NSArray *titleArray = @[@"微信好友",@"朋友圈",@"QQ好友",@"QQ空间"];
    for (NSString *icon in iconArray)
    {
        NSInteger index =  [iconArray indexOfObject:icon];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(shareBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:titleArray[index] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont adjustFont:28]];
        [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [btn setTitleColor:[UIColor colorWithRed:35.0f/255.0f green:35.0f/255.0f blue:35.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [self addSubview:btn];
        btn.tag = 100 + index;
        [iconBtnArr addObject:btn];
    }

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"文章去广告，开通VIP会员" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont adjustFont:28]];
    [btn setTitleColor:[UIColor colorWithRed:242.0f/255.0f green:48.0f/255.0f blue:48.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(shareBigBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];

    xq_line *line = [xq_line new];
    [self addSubview:line];

    __weak typeof(self) wkself = self;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(wkself.mas_width).with.offset(335.0f/375.0f);
        make.height.with.offset(SJAdapter(90));
        make.top.equalTo(wkself).with.offset(0);
        make.left.equalTo(wkself.mas_left).with.offset(SJAdapter(40));
    }];

    [iconBtnArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:SJAdapter(120) leadSpacing:SJAdapter(48) tailSpacing:SJAdapter(48)];

    [iconBtnArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.with.offset(SJAdapter(160));
        make.top.equalTo(label.mas_bottom);
    }];


    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.left.and.right.equalTo(wkself).with.offset(0);
        make.height.equalTo(btn.mas_width).multipliedBy(50.f/375.0f);
    }];

    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(wkself).with.offset(0);
        make.bottom.equalTo(btn.mas_top).with.offset(0);
        make.height.equalTo(btn.mas_width).multipliedBy(12.f/375.0f);
    }];

    self.bounds = CGRectMake(0, 0, KWIDTH, SJAdapter(400));
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]])
        {
            if (((UIButton *)obj).currentImage) {
                 [((UIButton *)obj) setImgePosition:UIButtonImagePositionTop spacer:SJAdapter(18)];
            }
        }
    }];
}


#pragma mark - Prvate Method

#pragma mark - Action Method
- (void)shareBtnTaped:(UIButton *)sender
{
    [self shareWithType:sender.tag % 100];
}

- (void)shareBigBtnTaped:(UIButton *)sender
{

//    [OpenVipViewController showOpenVip];
    ML_SHOW_MESSAGE(sender.currentTitle);
}





+ (CGFloat)head_fixedHeight
{
    return SJAdapter(350) + (iPhoneX?20:0);
}

@end

@implementation xq_ShareView
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _setupViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setupViews];
    }
    return self;
}


- (void)_setupViews
{
    self.backgroundColor = [UIColor whiteColor];
    NSMutableArray<UIButton *> *iconBtnArr = [NSMutableArray array];
    NSArray *iconArray = @[@"share_weixin_50",@"share_pyq_50",@"share_qq_50",@"share_zone_50"];
    NSArray *titleArray = @[@"微信好友",@"朋友圈",@"QQ好友",@"QQ空间"];
    for (NSString *icon in iconArray)
    {
        NSInteger index =  [iconArray indexOfObject:icon];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(shareBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:titleArray[index] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont adjustFont:28]];
        [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [btn setTitleColor:[UIColor colorWithRed:35.0f/255.0f green:35.0f/255.0f blue:35.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [self addSubview:btn];
        btn.tag = 100 + index;
        [iconBtnArr addObject:btn];
    }


    __weak typeof(self) wkself = self;
    [iconBtnArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:SJAdapter(120) leadSpacing:SJAdapter(48) tailSpacing:SJAdapter(48)];

    [iconBtnArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(wkself.mas_height);
        make.top.equalTo(wkself.mas_top).with.offset(SJAdapter(24));
    }];

    self.bounds = CGRectMake(0, 0, KWIDTH, [xq_ShareView head_fixedHeight]);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]])
        {
            if (((UIButton *)obj).currentImage) {
                [((UIButton *)obj) setImgePosition:UIButtonImagePositionTop spacer:SJAdapter(18)];
            }
        }
    }];
}

#pragma mark - Prvate Method

#pragma mark - Actions
- (void)shareBtnTaped:(UIButton *)sender
{
    [self shareWithType:sender.tag % 100];
}

#pragma mark - Pulbic
+ (CGFloat)head_fixedHeight
{
    return SJAdapter(200) + (iPhoneX?20:0);
}

@end




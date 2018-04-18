//
//  UpgradeView.h
//  running man
//
//  Created by asdasd on 2018/4/3.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "XQView.h"
#import <YYText.h>
@interface UpgradeView : UIView
@property (nonatomic ,strong) UIImageView *bassImg;
@property (nonatomic ,strong) UIButton *closeBtn;
@property (nonatomic ,strong) UIButton *sureBtn;
@property (nonatomic ,strong) YYLabel *titleLabel;
@property (nonatomic ,strong) YYLabel *detailLabel;

@property (nonatomic ,copy) void (^sureBtnTapBlock)(void);
@property (nonatomic ,copy) void (^closeBtnTapBlock)(void);
+ (void)show:(NSString *)title info:(NSString *)info trackViewUrl:(NSString *)trackViewUrl;
@end

//
//  UserDataViewModel.h
//  running man
//
//  Created by asdasd on 2018/4/2.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "XQViewModel.h"
#import "ToolModel.h"
#import "UserDataModel.h"
@interface UserDataViewModel : XQViewModel <XQViewModelProtocol>

@property (nonatomic ,strong) UserDataModel *model;
@property (nonatomic ,strong) NSArray <NSArray <ToolModel *>*> *toolModels;
@property (nonatomic ,assign) BOOL enableAutoToolbar; //  是否禁用页面的键盘ToolBar

@property (nonatomic ,strong) NSString *areas;  //地区
@property (nonatomic ,strong) NSString *latitude; //  经度
@property (nonatomic ,strong) NSString *longitude; //  纬度
@property (nonatomic ,strong) NSArray *headAssets;

@property (nonatomic ,strong) NSString *bindType;  // 2解绑 ， 1绑定
@property (nonatomic ,strong) NSString *origin;  //  来源 1-支付宝，2-微信

@property (nonatomic ,strong) RACCommand *getUserInfoCommand;
@property (nonatomic ,strong) RACSubject *headSrcSubject;
@property (nonatomic ,strong) RACSubject *cellClickSubject;
@property (nonatomic ,strong) RACSubject *loginOutSubject;

@property (nonatomic ,strong) RACCommand *saveDataCommand;

@property (nonatomic ,strong) RACCommand *bindCommand; //  绑定和解绑

NSMutableAttributedString * toolTitleAttr(NSString *str);

NSMutableAttributedString * toolDetailAttr(NSString *str);
@end

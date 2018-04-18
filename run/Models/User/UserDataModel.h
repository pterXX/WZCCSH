//
//  UserDataModel.h
//  running man
//
//  Created by asdasd on 2018/4/2.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "XQModel.h"

@interface UserDataModel : XQModel
@property (nonatomic,strong) NSString *user_account;
@property (nonatomic,strong) NSString *mobile;
@property (nonatomic,strong) NSString *birthday;
@property (nonatomic,strong) NSString *area;
@property (nonatomic,strong) NSString *tx_pic;
@property (nonatomic,strong) NSString *signature;
@property (nonatomic,strong) NSString *is_single;
@property (nonatomic,strong) NSString *trade;
@property (nonatomic,strong) NSString *earnings;
@property (nonatomic,strong) NSString *education;
@property (nonatomic,strong) NSString *interest;
@property (nonatomic,strong) NSString *sex;
@property (nonatomic,strong) NSString *age;
@property (nonatomic,strong) NSString *mobile_verify;
@property (nonatomic,strong) NSString *zfb_account; //   支付宝账号
@property (nonatomic,strong) NSString *open_id; //  微信 open_id
@end

//
//  WalletViewModel.h
//  run
//
//  Created by asdasd on 2018/4/10.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "XQViewModel.h"

@interface WalletViewModel : XQViewModel
@property(strong,nonatomic)NSString *open_id;
@property(strong,nonatomic)NSString *zfb_account;
@property(strong,nonatomic)NSString *tishi;
@property(strong,nonatomic)NSString *amount;

- (void)requestData;
@end

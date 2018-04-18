//
//  WalletListModel.h
//  run
//
//  Created by asdasd on 2018/4/10.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "XQModel.h"

@interface WalletListModel : XQModel
@property (nonatomic ,copy) NSString *money;
@property (nonatomic ,copy) NSString *date;
@property (nonatomic ,copy) NSString *group_id;
@property (nonatomic ,copy) NSString *group_name;
@property (nonatomic ,copy) NSString *remark;
@property (nonatomic ,copy) NSString *pay_type;
@end

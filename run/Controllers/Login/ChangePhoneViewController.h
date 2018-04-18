//
//  ChangePhoneViewController.h
//  running man
//
//  Created by asdasd on 2018/4/2.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "XQBassViewController.h"
#import "ChangePhoneViewModel.h"
@interface ChangePhoneViewController : XQBassViewController
@property (nonatomic, strong) ChangePhoneViewModel *viewModel;

@property (nonatomic ,strong) void(^reloadDataBlock)(void);
@end

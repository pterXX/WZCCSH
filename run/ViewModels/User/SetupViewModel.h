//
//  SetupViewModel.h
//  running man
//
//  Created by asdasd on 2018/4/2.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "XQViewModel.h"
#import "ToolModel.h"
@interface SetupViewModel : XQViewModel
@property (nonatomic ,strong) NSArray <NSArray <ToolModel *>*> *toolModels;

@property (nonatomic ,strong) RACSubject *switchBtnClickSubject;

@property (nonatomic ,strong) RACSubject *reloadTableSubject;

@property (nonatomic ,strong) RACSubject *cellClickSubject;
@end

//
//  UserCenterViewModel.h
//  running man
//
//  Created by asdasd on 2018/4/2.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "XQViewModel.h"
#import "ToolModel.h"
#import "UserDataViewModel.h"
@interface UserCenterViewModel : XQViewModel
@property (nonatomic,strong) NSArray<ToolModel *> *toolModels;

@property (nonatomic ,strong) NSString *head_src;
@property (nonatomic ,assign) BOOL is_work;

@property (nonatomic ,strong) UserDataViewModel *dataViewModel;

@property (nonatomic,strong) RACSubject *cellClickSubject; //  cell  点击

@property (nonatomic, strong) RACSubject *userDataClickSubject; //   点击查看资料

@property (nonatomic ,strong) RACCommand *startBtnAndEndBtnCommand; //  开工按钮点击
@end

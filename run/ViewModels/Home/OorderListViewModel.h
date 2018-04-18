//
//  OorderListViewModel.h
//  running man
//
//  Created by asdasd on 2018/4/4.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "XQViewModel.h"
#import "RunOrderListModel.h"
#import "MenuInfo.h"

@interface OorderListViewModel : XQViewModel
@property (nonatomic ,strong) NSString *latitude;

@property (nonatomic ,strong) NSString *longitude;

@property (nonatomic ,assign) NSInteger page;

@property (nonatomic ,strong) NSMutableArray<RunOrderListModel *> *dataSource;

@property (nonatomic ,strong) MenuInfo *menuInfo;

@property (nonatomic ,strong) NSString *selectedId;

@property (nonatomic ,strong) RACSubject *refreshEndSubject;

@property (nonatomic ,strong) RACSubject *refreshUISubject;

@property (nonatomic ,strong) RACSubject *cellClickSubject;

@property (nonatomic ,strong) RACCommand *refreshDataCommand;

@property (nonatomic ,strong) RACCommand *nextPageCommand;

@property (nonatomic ,strong) RACCommand *startBtnAndEndBtnCommand; //  开工按钮点击

@end

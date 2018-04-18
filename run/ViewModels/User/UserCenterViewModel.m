//
//  UserCenterViewModel.m
//  running man
//
//  Created by asdasd on 2018/4/2.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "UserCenterViewModel.h"
#import "XQLoginExample.h"
@implementation UserCenterViewModel
- (void)xq_initialize{
    @weakify(self);
    //  开工和收工按钮的点击的命令
    [self.startBtnAndEndBtnCommand.executionSignals.switchToLatest subscribeNext:^(MLHTTPRequestResult * _Nullable x) {
        @strongify(self);
        if (x == nil) {
            ML_MESSAGE_NETWORKING;
            return ;
        }

        if (x.errcode == 0) {
            ML_SHOW_MESSAGE(x.errmsg);
            //  修改收工和开工状态 成功
            self.is_work = !self.is_work;
            [[VoiceManager shareManager] syntheticVoice:self.is_work?WORK_TITLE:NOT_WORK_TITLE];
            //  开工到收工状态
            [XQNotificationCenter postNotificationName:kWorkingStatuseNotificationKey object:nil];
        }else{
            ML_SHOW_MESSAGE(x.errmsg);
        }
    }];


    //  接收通知判断是否开工,这里的开工收工状态由订单列表请求数据的时候判断是否开工
    [[XQNotificationCenter rac_addObserverForName:kIsWorkingNotificationKey object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        if (x.object) {
            self.is_work = [x.object boolValue];
        }
    }];
}

- (NSArray<ToolModel *> *)toolModels{
    if (_toolModels == nil) {
        ToolModel *tool1 =  [ToolModel homeToolWithTitle:@"我的钱包" icon:@"user_icon_wallet" selector:nil];
        ToolModel *tool2 =  [ToolModel homeToolWithTitle:@"历史订单" icon:@"user_icon_order" selector:nil];
        ToolModel *tool3 =  [ToolModel homeToolWithTitle:@"设置" icon:@"user_icon_setup" selector:nil];
        NSArray *array = @[tool1,tool2,tool3];
        
        _toolModels = array;
    }
    return _toolModels;
}


- (RACSubject *)cellClickSubject {

    if (!_cellClickSubject) {

        _cellClickSubject = [RACSubject subject];
    }

    return _cellClickSubject;
}

- (RACSubject *)userDataClickSubject {

    if (!_userDataClickSubject) {

        _userDataClickSubject = [RACSubject subject];
    }

    return _userDataClickSubject;
}

- (UserDataViewModel *)dataViewModel{
    if (_dataViewModel == nil) {
        _dataViewModel = [[UserDataViewModel alloc] init];
    }
    return _dataViewModel;
}


- (RACCommand *)startBtnAndEndBtnCommand {

    if (!_startBtnAndEndBtnCommand) {
        @weakify(self);
        _startBtnAndEndBtnCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                @strongify(self);
                return [XQLoginExample isWokringServer:!self.is_work];
            }];
    }

    return _startBtnAndEndBtnCommand;
}


- (NSString *)head_src{
    return self.dataViewModel.model.tx_pic;
}
@end

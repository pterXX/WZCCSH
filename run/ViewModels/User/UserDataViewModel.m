//
//  UserDataViewModel.m
//  running man
//
//  Created by asdasd on 2018/4/2.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "UserDataViewModel.h"
#import "XQLoginExample.h"
@implementation UserDataViewModel

- (void)setOrigin:(NSString *)origin{
    _origin = origin;
    [self.bindCommand execute:nil];
}

-(void)xq_initialize{
    @weakify(self);
    [self.getUserInfoCommand.executionSignals.switchToLatest subscribeNext:^(MLHTTPRequestResult * _Nullable x) {
        @strongify(self);
        if (x == nil) {
            ML_MESSAGE_NETWORKING;
             return ;
        }
        if (x.errcode == 0) {
            self.model = [UserDataModel objectWithDictionary:x.data];
        }else{
            self.model = nil;
        }
    }];

    [self.getUserInfoCommand.executionSignals subscribeError:^(NSError * _Nullable error) {
        
    }];

    [self.bindCommand.executionSignals.switchToLatest subscribeNext:^(MLHTTPRequestResult * _Nullable x) {
        @strongify(self);
        if (x == nil) {
            ML_MESSAGE_NETWORKING;
            return ;
        }

        ML_SHOW_MESSAGE(x.errmsg);
        //  重新获取数据
        [self.getUserInfoCommand execute:nil];
    }];

    [self.bindCommand.executionSignals subscribeError:^(NSError * _Nullable error) {
        @strongify(self);
        //  重新获取数据
        [self.getUserInfoCommand execute:nil];
    }];

    [self.saveDataCommand.executionSignals.switchToLatest  subscribeNext:^(MLHTTPRequestResult * _Nullable x) {
        @strongify(self);
        if (x == nil) {
            ML_MESSAGE_NETWORKING;
            return;
        }

        ML_SHOW_MESSAGE(x.errmsg);
        //  重新获取数据
        [self.getUserInfoCommand execute:nil];
    }];
}

- (NSArray<NSArray<ToolModel *> *> *)toolModels{

    if (_toolModels == nil) {
        ToolModel *g1tool1,*g2tool1,*g2tool2,*g2tool3,*g2tool4,*g2tool5,*g2tool6;

        g1tool1 =  [ToolModel homeToolWithTitle:toolTitleAttr(@"头像") icon:@"user_icon_head1" selector:nil];
        g2tool1 =  [ToolModel homeToolWithTitle:toolTitleAttr(@"切换城市") icon:nil selector:nil];
        g2tool2 =  [ToolModel homeToolWithTitle:toolTitleAttr(@"所在地区") icon:nil selector:nil];
        g2tool3 =  [ToolModel homeToolWithTitle:toolTitleAttr(@"更换联系方式") icon:nil selector:nil];
        g2tool4 =  [ToolModel homeToolWithTitle:toolTitleAttr(@"修改密码") icon:nil selector:nil];
        g2tool5 =  [ToolModel homeToolWithTitle:toolTitleAttr(@"支付宝") icon:nil selector:nil];
        g2tool6 =  [ToolModel homeToolWithTitle:toolTitleAttr(@"微信") icon:nil selector:nil];


        NSArray *array = @[@[g1tool1],@[g2tool1,g2tool2,g2tool3,g2tool4,g2tool5,g2tool6]];
        _toolModels = array;
    }
    _toolModels[0][0].iconImage = self.model.tx_pic?self.model.tx_pic:([self.model.sex intValue] == 1?@"user_icon_head1":@"user_icon_head2");
    _toolModels[1][0].detialTitle = toolDetailAttr([XQLoginExample lastCity]);
    _toolModels[1][1].detialTitle = toolDetailAttr(self.model.area);
    _toolModels[1][2].detialTitle = toolDetailAttr(self.model.mobile.length == 11? [self.model.mobile replaceStringWithAsteriskStartLocation:3 lenght:6]:self.model.mobile);

    NSDictionary *dict = @{
                           NSFontAttributeName:[UIFont adjustFont:15],
                           NSForegroundColorAttributeName:COLOR_MAIN
                           };
   NSAttributedString *no = [[NSAttributedString alloc] initWithString:@"未绑定" attributes:dict];
    NSAttributedString *yes = toolDetailAttr(@"已绑定");

   _toolModels[1][4].detialTitle = self.model.zfb_account.length > 0?yes:no;
   _toolModels[1][5].detialTitle = self.model.open_id.length > 0?yes:no;
    return _toolModels;
}

NSMutableAttributedString * toolTitleAttr(NSString *str) {
    NSDictionary *dict = @{
                           NSFontAttributeName:[UIFont adjustFont:15],
                           NSForegroundColorAttributeName:COLOR_353535
                           };

    return str == nil?nil:[[NSMutableAttributedString alloc] initWithString:str attributes:dict];
}

 NSMutableAttributedString * toolDetailAttr(NSString *str) {
    NSDictionary *dict = @{
                           NSFontAttributeName:[UIFont adjustFont:15],
                           NSForegroundColorAttributeName:COLOR_353535
                           };
    return str == nil?nil:[[NSMutableAttributedString alloc] initWithString:str attributes:dict];
}

- (RACSubject *)cellClickSubject {

    if (!_cellClickSubject) {

        _cellClickSubject = [RACSubject subject];
    }

    return _cellClickSubject;
}

- (RACSubject *)headSrcSubject {
    if (!_headSrcSubject) {
        _headSrcSubject = [RACSubject subject];
    }
    return _headSrcSubject;
}

- (RACSubject *)loginOutSubject{
    if (!_loginOutSubject) {
        _loginOutSubject = [RACSubject subject];
    }
    return _loginOutSubject;
}


- (RACCommand *)getUserInfoCommand {
    if (!_getUserInfoCommand) {
        _getUserInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MLHTTPRequest POSTWithURL:CSSH_GET_USER_INFO parameters:nil responseCache:^(MLHTTPRequestResult *result) {
                    [subscriber sendNext:result];
                } success:^(MLHTTPRequestResult *result) {
                    [subscriber sendNext:result];
                    [subscriber sendCompleted];
                } failure:^(NSError *error) {
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _getUserInfoCommand;
}

- (RACCommand *)bindCommand {
    if (!_bindCommand) {
        _bindCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                NSDictionary *dict = @{@"type":self.bindType?:@"2",@"origin":self.origin?:@"1"};
                [MLHTTPRequest POSTWithURL:RUN_BANGDDING parameters:dict responseCache:^(MLHTTPRequestResult *result) {
                    [subscriber sendNext:result];
                } success:^(MLHTTPRequestResult *result) {
                    [subscriber sendNext:result];
                    [subscriber sendCompleted];
                } failure:^(NSError *error) {
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _bindCommand;
}


- (RACCommand *)saveDataCommand {
    if (!_saveDataCommand) {
        @weakify(self);
        _saveDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                NSMutableDictionary *dic = ((NSDictionary *)[self.model dictWithObject]).mutableCopy;
                if (self.areas) {
                    NSString  *areas = [self.areas stringByReplacingOccurrencesOfString:@" " withString:@","];
                     [dic setObject:areas forKey:@"areas"];
                }
                if (self.latitude) {
                    [dic setObject:self.latitude forKey:@"latitude"];
                }

                if (self.longitude) {
                    [dic setObject:self.longitude forKey:@"longitude"];
                }

                [MLHTTPRequest POSTWithURL:CSSH_CHANGE_USER_INFO parameters:[self.model dictWithObject] success:^(MLHTTPRequestResult *result) {
                    [subscriber sendNext:result];
                    [subscriber sendCompleted];
                } failure:^(NSError *error) {
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }

    return _saveDataCommand;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

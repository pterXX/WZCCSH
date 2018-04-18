//
//  SetupViewModel.m
//  running man
//
//  Created by asdasd on 2018/4/2.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "SetupViewModel.h"
#import "XQSetupExample.h"
#import "XQLoginExample.h"
@implementation SetupViewModel
static NSMutableAttributedString * toolDetailAttr(NSString *str) {
    NSDictionary *dict = @{
                           NSFontAttributeName:[UIFont adjustFont:15],
                           NSForegroundColorAttributeName:COLOR_999999
                           };
    return str == nil?nil:[[NSMutableAttributedString alloc] initWithString:str attributes:dict];
}


static NSMutableAttributedString * toolTitleAttr(NSString *str) {
    NSDictionary *dict = @{
                           NSFontAttributeName:[UIFont adjustFont:15],
                           NSForegroundColorAttributeName:COLOR_353535
                           };

    return str == nil?nil:[[NSMutableAttributedString alloc] initWithString:str attributes:dict];
}

- (NSArray<NSArray<ToolModel *> *> *)toolModels{
    if (_toolModels == nil) {
        ToolModel *g1tool1 =  [ToolModel homeToolWithTitle:toolTitleAttr(@"声音") icon:nil selector:nil];
        g1tool1.otherData = @([XQSetupExample canSound]);

        ToolModel *g1tool2 =  [ToolModel homeToolWithTitle:toolTitleAttr(@"震动") icon:nil selector:nil];
         g1tool2.otherData = @([XQSetupExample canCibration]);

        ToolModel *g2tool1 =  [ToolModel homeToolWithTitle:toolTitleAttr(@"消息推送") icon:nil selector:nil];
         g2tool1.otherData = @([XQSetupExample canPush]);

        ToolModel *g3tool1 =  [ToolModel homeToolWithTitle:toolTitleAttr(@"关于我们") icon:nil selector:nil];
        g3tool1.detialTitle = toolDetailAttr(@"");
        ToolModel *g3tool2 =  [ToolModel homeToolWithTitle:toolTitleAttr(@"版本更新") icon:nil selector:nil];
        g3tool2.detialTitle = toolDetailAttr([NSString stringWithFormat:@"V%@",[UIDevice appCurVersion]]);
        NSArray *array = @[@[g1tool1,g1tool2],@[g2tool1],@[g3tool1,g3tool2]];
        [ToolGroup group:array performSelectorBlcok:^SelecetorBlock(ToolModel *model, NSString *selector) {
            return ^(){
                
            };
        }];
        _toolModels = array;
    }
    return _toolModels;
}

- (void)xq_initialize{
    @weakify(self);
    [self.switchBtnClickSubject subscribeNext:^(ToolModel * _Nullable x) {
        @strongify(self);
        NSMutableAttributedString *attr = x.title;
        NSString *title = attr.string;

        if ([title isEqualToString:@"消息推送"]) {
            [XQSetupExample setCanPush:![XQSetupExample canPush]];
        }

        x.otherData = @([XQSetupExample canPush]);
        [self.reloadTableSubject sendNext:nil];
    }];
}

#pragma mark - LazyLoad
- (RACSubject *)switchBtnClickSubject{
    if (_switchBtnClickSubject == nil) {
        _switchBtnClickSubject = [RACSubject subject];
    }
    return _switchBtnClickSubject;
}

- (RACSubject *)reloadTableSubject{
    if (_reloadTableSubject == nil) {
        _reloadTableSubject = [RACSubject subject];
    }
    return _reloadTableSubject;
}

- (RACSubject *)cellClickSubject{
    if (_cellClickSubject == nil) {
        _cellClickSubject = [RACSubject subject];
    }
    return _cellClickSubject;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

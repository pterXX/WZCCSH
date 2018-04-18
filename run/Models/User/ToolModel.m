//
//  ToolModel.m
//  proj
//
//  Created by asdasd on 2017/12/17.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import "ToolModel.h"
#import <objc/runtime.h>
#import "RootViewControllerUtil.h"
@implementation ToolModel


//  根据参数生成model
+ (ToolModel *)homeToolWithTitle:(id)title icon:(NSString *)icon selector:(NSString *)selector
{
    ToolModel *home = [[ToolModel alloc] init];
    home.title = title;
    home.iconImage = icon;
    home.selector = selector;
    return home;
}



//  执行方法
- (void)performSelectorMethod
{
    SelecetorBlock block = objc_getAssociatedObject(self, _cmd);
    if (block)
            {
        block();
    }
}

@end

@implementation ToolGroup
+ (void)group:(id )models performSelectorBlcok:(SelecetorBlock (^)(ToolModel *, NSString *))block
{

    [models enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
            {
        if ([obj isKindOfClass:[NSArray class]])
        {

            NSArray *goup = (NSArray *)obj;
            [self group:goup performSelectorBlcok:block];
        }else if ([obj isKindOfClass:[ToolModel class]])
        {
            ToolModel *model = (ToolModel *)obj;
            objc_setAssociatedObject(model, @selector(performSelectorMethod), block(model,model.selector), OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
    }];
}

@end



@implementation ToolModel (data)

@end

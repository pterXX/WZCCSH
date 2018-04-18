//
//  ToolModel.h
//  proj
//
//  Created by asdasd on 2017/12/17.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SelecetorBlock)(void);
@interface ToolModel : NSObject

@property (nonatomic ,copy) NSString *iconImage;
@property (nonatomic ,copy) id title;
@property (nonatomic ,strong) NSString *selector;

@property (nonatomic ,strong) id detialTitle;
@property (nonatomic ,strong) NSString *detailIcon;
@property (nonatomic ,strong) id otherData;


/**
 如果 selector 为nil  就执行这个方法
 */
- (void)performSelectorMethod;



/**
 根据参数生成model

 @param title 标题
 @param icon 图标
 @param selector 方法
 @return model
 */
+ (ToolModel *)homeToolWithTitle:(id)title icon:(NSString *)icon selector:(NSString *)selector;

@end


@interface ToolGroup: NSMutableArray
+ (void)group:(id)models performSelectorBlcok:(SelecetorBlock(^)(ToolModel *,NSString *selector))block;

@end


@interface ToolModel (data)


@end




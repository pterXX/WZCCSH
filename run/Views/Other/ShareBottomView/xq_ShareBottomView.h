//
//  xq_ShareBottomView.h
//  proj
//
//  Created by asdasd on 2018/1/6.
//  Copyright © 2018年 asdasd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "zhPopupController.h"
@interface ShareItem : NSObject

@property (nonatomic, strong) id thumb;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *desc;

//  分享本地视频可只传视频链接
@property (nonatomic, strong) id fileUrl;

///  类型(1、效果图 2、视频 3、装修知识 4、图片海报 5、小视频 6、活动 7、软文段子)
@property (nonatomic, strong) NSString *atype;
@property (nonatomic, strong) NSString *aid; ///  相关类型的关联的id
@end


@protocol ShareDelegate <NSObject>
@property (nonatomic, strong) ShareItem *shareItem;
@end


@interface xq_share:UIView

@property (nonatomic, weak) id <ShareDelegate> delegate;
@property (nonatomic,strong) ShareItem *shareItem;
@property (nonatomic,copy) void(^shareViewTapBlock)();
@property (nonatomic,copy) void(^shareViewSuccessBlock)();

//  微信分享
- (void)shareWeChat;

+ (CGFloat)head_fixedHeight;

+ (void)showShareItem:(ShareItem *)shareItem success:(void(^)(void))success;

/**
 只分享图片

 @param image 图片
 @param success 成功的回调
 */
+ (void)shareImg:(UIImage *)image success:(void(^)(void))success;
@end

IB_DESIGNABLE

@interface xq_ShareBottomView : xq_share

@end

IB_DESIGNABLE
@interface xq_ShareView : xq_share

@end

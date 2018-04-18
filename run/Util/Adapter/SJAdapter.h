//
//  SJAdapter.h
//  city
//
//  Created by 3158 on 17/4/26.
//  Copyright © 2017年 sjw. All rights reserved.
//

#define QS_INLNE static inline
//****************************适配************************************************


#define kBaseWidth 750
#define kBaseHeight 1334

//  屏幕的宽高度
#define KWIDTH [UIScreen mainScreen].bounds.size.width
#define KHEIGHT [UIScreen mainScreen].bounds.size.height

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define SafeAreaTopHeight (iPhoneX ? 88 :64)

static inline CGFloat SJAdapterW()
{
    return  KWIDTH / kBaseWidth;
}


QS_INLNE CGFloat SJAdapter( CGFloat ad )
{
    return SJAdapterW() * ad;
}

QS_INLNE CGRect SJRect(CGRect Rect)
{
   CGFloat AdapterW = SJAdapterW();
    CGFloat width = AdapterW * Rect.size.width;
    CGFloat height = AdapterW * Rect.size.height;
    CGFloat x = AdapterW * Rect.origin.x;
    CGFloat y = AdapterW * Rect.origin.y;
    return CGRectMake(x, y, width, height);
}

QS_INLNE CGRect SJRectMake(CGFloat x, CGFloat y,CGFloat width,CGFloat height)
{
    CGRect rect = CGRectMake(x, y, width, height);
    return SJRect(rect);
}

QS_INLNE CGFloat SJRectGetMaxX(CGRect frame)
{
    return CGRectGetMaxX(frame) / SJAdapterW();
}

QS_INLNE CGFloat SJRectGetMinX(CGRect frame)
{
    return CGRectGetMinX(frame) / SJAdapterW();
}

QS_INLNE CGFloat SJRectGetMinY(CGRect frame)
{
     return CGRectGetMinY(frame) / SJAdapterW();
}

QS_INLNE CGFloat SJRectGetMaxY(CGRect frame)
{
    return CGRectGetMaxY(frame) / SJAdapterW();
}

QS_INLNE CGFloat SJRectGetWidth(CGRect frame)
{
    return CGRectGetWidth(frame) / SJAdapterW();
}

QS_INLNE CGFloat SJRectGetHeight(CGRect frame)
{
    return CGRectGetHeight(frame) / SJAdapterW();
}


QS_INLNE CGFloat SJRectGetMidY(CGRect frame)
{
    return CGRectGetMidY(frame) / SJAdapterW();
}

QS_INLNE CGFloat SJRectGetMidX(CGRect frame)
{
    return CGRectGetMidX(frame) / SJAdapterW();
}


QS_INLNE CGSize SJSize(CGSize size)
{
    CGFloat AdapterW = SJAdapterW();
    CGFloat width = AdapterW * size.width;
    CGFloat height = AdapterW * size.height;
    return CGSizeMake(width, height);
}

QS_INLNE CGSize SJSizeMake(CGFloat width,CGFloat height)
{
    return SJSize(CGSizeMake(width, height));
}

QS_INLNE CGPoint SJPoint(CGPoint point) {
    
    CGFloat AdapterW = SJAdapterW();
    CGFloat newX = point.x * AdapterW;
    CGFloat newY = point.x * AdapterW;
    return  CGPointMake(newX, newY);
}

QS_INLNE CGPoint SJPointMake(CGFloat x, CGFloat y) {
    return SJPoint(CGPointMake(x, y));
}

//  字体适配
QS_INLNE UIFont *SJFont(CGFloat fontSzie)
{
    return [UIFont systemFontOfSize:fontSzie * SJAdapterW()];
}
















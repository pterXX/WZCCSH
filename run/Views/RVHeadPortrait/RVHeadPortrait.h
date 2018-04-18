//
//  RVHeadPortrait.h
//  proj
//
//  Created by asdasd on 2017/10/10.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HeadTap)(void) ;
#define KChangeEadPoretraitIconNoteKey @"KChangeEadPoretraitIconNoteKey"

@interface RVHeadPortrait : UIView

+ (RVHeadPortrait *)defaultHeadPortraitForBlock:(HeadTap)headTap;

@property (nonatomic ,strong) UIImageView *headImgView;

//  头像点击
@property (nonatomic ,copy) HeadTap headTap;


@end

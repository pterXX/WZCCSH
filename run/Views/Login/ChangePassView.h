//
//  ChangePassView.h
//  running man
//
//  Created by asdasd on 2018/3/29.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "XQView.h"
#import "ChangePasswordViewModel.h"
@interface ChangePassView : XQView
@property (nonatomic ,strong) XQTextField *oPassText;
@property (nonatomic ,strong) XQTextField *nPassText;
@property (nonatomic ,strong) XQTextField *sPassText;
@property (nonatomic ,strong) XQButton *sureBtn;
@end

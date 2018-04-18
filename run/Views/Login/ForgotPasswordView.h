//
//  ForgotPasswordView.h
//  running man
//
//  Created by asdasd on 2018/4/10.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "XQView.h"
#import "ForgotPasswordViewModel.h"
@interface ForgotPasswordView : XQView
@property (nonatomic ,strong) XQTextField *phoneText;
@property (nonatomic ,strong) XQTextField *codeText;
@property (nonatomic ,strong) XQButton *nextBtn;
@end

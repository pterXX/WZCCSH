//
//  LoginView.h
//  running man
//
//  Created by asdasd on 2018/3/28.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "XQView.h"
#import "LoginViewModel.h"

@interface LoginView : XQView
@property (nonatomic ,strong) XQTextField *phoneText;
@property (nonatomic ,strong) XQTextField *passwordText;
@property (nonatomic ,strong) XQButton *loginBtn;
@end

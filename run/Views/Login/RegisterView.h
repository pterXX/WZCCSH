//
//  RegisterView.h
//  running man
//
//  Created by asdasd on 2018/3/29.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "XQView.h"
#import "RegisterViewModel.h"
@interface RegisterView : XQView
@property (nonatomic ,strong) XQTextField *phoneText;
@property (nonatomic ,strong) XQTextField *passwordText;
@property (nonatomic ,strong) XQTextField *codeText;
@property (nonatomic ,strong) XQTextField *nicknameText;
@property (nonatomic ,strong) XQButton *registerBtn;
@end

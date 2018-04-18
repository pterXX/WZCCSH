//
//  CallGoodsPupView.m
//  city
//
//  Created by 3158 on 2018/2/5.
//  Copyright © 2018年 sjw. All rights reserved.
//

#import "CallGoodsPupView.h"
#import "UIView+Category.h"
#import "OtherKitExample.h"
#import "zhPopupController.h"

@interface CallGoodsPupView()<YNTextFieldDelegate>
@property (nonatomic ,strong)  NSMutableArray<YNTextField *> *textFieldArray;
@property (nonatomic ,strong)  UIButton *sureBtn;
@end

@implementation CallGoodsPupView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_setupViews];
    }
    return self;
}

- (void)p_setupViews
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = SJAdapter(20);
    self.layer.masksToBounds = YES;
    
    //层级：2，父视图：UIView 的UILabel
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,20.00f,150.00f,15.00f)];
    titleLabel.text = @"请输入四位收货码";
    titleLabel.textColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
    titleLabel.backgroundColor = [UIColor colorWithRed:0.00f green:0.00f blue:0.00f alpha:0.00f] ;
    titleLabel.font = [UIFont systemFontOfSize:15.00f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 1;
    [self addSubview:titleLabel];
    self.title = titleLabel;
    

    [self addSubview:[self textFieldWithRect:CGRectMake(42.50f,60.00f,40.00f,40.00f)]];
    [self addSubview:[self textFieldWithRect:CGRectMake(92.50f,60.00f,40.00f,40.00f)]];
    [self addSubview:[self textFieldWithRect:CGRectMake(142.50f,60.00f,40.00f,40.00f)]];
    [self addSubview:[self textFieldWithRect:CGRectMake(192.50f,60.00f,40.00f,40.00f)]];

    
    //层级：3，父视图：UIStackView 的UIButton
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0.00f, 125.00f, 137.00f,50.00f);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15.00f];
    [cancelBtn addTarget:self action:@selector(cancelBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    
    //层级：3，父视图：UIStackView 的UIButton
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(138.00f, 125.00f, 137.00f,50.00f);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f] forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor colorWithRed:0.60f green:0.60f blue:0.60f alpha:1.00f] forState:UIControlStateDisabled];
    sureBtn.enabled = NO;
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15.00f];
    [sureBtn addTarget:self action:@selector(sureBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
    self.sureBtn = sureBtn;
    [self addSubview:sureBtn];
    
    [self adaptSizeSubViewsYouUIScreenWidth:375.0];
    [OtherKitExample createViewHorizontalShapeLayerWithView:self startPoint:CGPointMake(0, cancelBtn.top - 1) width:self.width];
    [OtherKitExample createViewVerticalShapeLayerWithView:self startPoint:CGPointMake(cancelBtn.right, cancelBtn.top) height:cancelBtn.height];
    self.title.width = self.width;
    
    [self.textFieldArray.firstObject becomeFirstResponder];

}

- (YNTextField *)textFieldWithRect:(CGRect)rect
{
    YNTextField *thirdTextF = [[YNTextField alloc]initWithFrame:rect];
    thirdTextF.borderStyle = UITextBorderStyleRoundedRect;
    thirdTextF.backgroundColor = [UIColor colorWithRed:0.00f green:0.00f blue:0.00f alpha:0.00f];
    thirdTextF.font = [UIFont systemFontOfSize:24.0f];
    thirdTextF.textColor = [UIColor colorWithRed:0.00f green:0.00f blue:0.00f alpha:1.00f];
    thirdTextF.secureTextEntry = NO;
    thirdTextF.autocorrectionType = UITextAutocorrectionTypeDefault;
    thirdTextF.keyboardType = UIKeyboardTypeNumberPad;
    thirdTextF.returnKeyType = UIReturnKeyDefault;
    thirdTextF.textAlignment = NSTextAlignmentCenter;
    thirdTextF.enabled = NO;
    thirdTextF.yn_delegate = self;
    [thirdTextF addTarget:self action:@selector(textValueChange:) forControlEvents:UIControlEventEditingChanged];
    if (self.textFieldArray == nil) {
        self.textFieldArray = [NSMutableArray array];
        //  第一个输入框可以输入
        thirdTextF.enabled = YES;
    }
    [self.textFieldArray addObject:thirdTextF];
    return thirdTextF;
}

#pragma mark - Evnet Methods
- (void)textValueChange:(YNTextField *)textField
{
    self.title.text = @"请输入四位收货码";
    self.title.textColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
    if (textField.text.length > 0) {
        textField.text = [textField.text substringToIndex:1];
        [self p_nextTextField:textField];
    }else if(textField.text.length < 1)
    {
         [self p_previousTextField:textField];
    }
    NSMutableString *str = [NSMutableString string];
    [self.textFieldArray enumerateObjectsUsingBlock:^(UITextField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [str appendString:obj.text];
    }];
    self.password = str;
    
    BOOL isSure = YES;
    for (YNTextField *textF in self.textFieldArray) {
        if (textF.text.length == 0) {
            isSure = NO;
            break;
        }
    }
}

- (void)sureBtnTaped:(UIButton *)sender
{
    self.sureBtnBlcok?self.sureBtnBlcok(self.password,self):nil;
}

- (void)cancelBtnTaped:(UIButton *)sender
{
    self.cacanlBtnBlcok?self.cacanlBtnBlcok(self.password,self):nil;
}


#pragma mark - YNTextFieldDelegate
//  删除按钮
- (void)ynTextFieldDeleteBackward:(YNTextField *)textField
{
     [self p_previousTextField:textField];
}

#pragma mark - Private
//  查找下一个textField
- (void)p_nextTextField:(YNTextField *)textField
{
    NSInteger index = [self.textFieldArray indexOfObject:textField];
    if (index < self.textFieldArray.count - 1) {
        // 把当前的textField 设置为禁用
        [textField setEnabled:NO];
        [[self.textFieldArray objectAtIndex:index + 1] setEnabled:YES];
        [[self.textFieldArray objectAtIndex:index + 1] becomeFirstResponder];
    }
    
    if (index == self.textFieldArray.count - 1) {
        self.sureBtn.enabled = YES;
    }
}

//  查找上一个textField
- (void)p_previousTextField:(YNTextField *)textField
{
    NSInteger index = [self.textFieldArray indexOfObject:textField];
    if (index < self.textFieldArray.count) {
        // 把当前的textField 设置为禁用
        [textField setEnabled:NO];
        YNTextField *text = [self.textFieldArray objectAtIndex:(index - 1) >= 0 ?index - 1:0];
        [text setEnabled:YES];
        [text becomeFirstResponder];
    }
}

+ (void)dismss
{
    [kWindow.rootViewController.zh_popupController dismiss];
}

//  显示弹框
+ (void)showPasswordWithSureBlock:(CallGoodsCallBack)sureBlock
                      cecanlBlock:(CallGoodsCallBack)cecanBlock
{
    CallGoodsPupView *view = [[CallGoodsPupView alloc] initWithFrame:CGRectMake(0, 0, SJAdapter(550), SJAdapter(350))];
    [view setSureBtnBlcok:^(NSString *password, CallGoodsPupView *callGoodsView) {
        sureBlock(password,callGoodsView);
    }];
    
    [view setCacanlBtnBlcok:^(NSString *password, CallGoodsPupView *callGoodsView) {
        [kWindow.rootViewController.zh_popupController dismiss];
        cecanBlock(password,callGoodsView);
    }];
    kWindow.rootViewController.zh_popupController = [zhPopupController popupControllerWithMaskType:zhPopupMaskTypeBlackBlur];
    kWindow.rootViewController.zh_popupController.layoutType = zhPopupLayoutTypeCenter;
    kWindow.rootViewController.zh_popupController.dismissOnMaskTouched = NO;
    [kWindow.rootViewController.zh_popupController presentContentView:view duration:0.25 springAnimated:NO];
}
@end


@implementation YNTextField

- (void)deleteBackward {
    ///！！！这里要调用super方法，要不然删不了东西
    [super deleteBackward];
    
    if ([self.yn_delegate respondsToSelector:@selector(ynTextFieldDeleteBackward:)]) {
        [self.yn_delegate ynTextFieldDeleteBackward:self];
    }
}
@end

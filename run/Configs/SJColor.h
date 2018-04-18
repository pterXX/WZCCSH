//
//  SJColor.h
//  proj
//
//  Created by asdasd on 2017/9/27.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#ifndef SJColor_h
#define SJColor_h

#define RGB(r,g,b,a)  [UIColor colorWithRed:(double)r/255.0f green:(double)g/255.0f blue:(double)b/255.0f alpha:a]

#define COLOR_353535 RGB(53,53,53,1.0) //
#define COLOR_EEEEEE RGB(238,238,238,1.0)
#define COLOR_FF8803 RGB(255,136,3,1.0) //
#define COLOR_999999 RGB(153,153,153,1.0) //
#define COLOR_666666 RGB(102,102,102,1.0) //
#define COLOR_3C74A9    [UIColor hexString:@"3c74a9"] //   协议、注册字体颜色
#define COLOR_FFFFFF RGB(255,255,255,1.0) //
#define COLOR_F5F5F5 RGB(245,245,245,1.0) //
#define COLOR_999999 RGB(153,153,153,1.0) //
#define COLOR_BBBBBB RGB(187,187,187,1.0) //  分割线
#define COLOR_FE9928 RGB(254,153,40,1.0)  //  按钮颜色
#define COLOR_FFE1AA RGB(255,225,170,1.0) //  按钮的禁用的颜色

#define COLOR_MAIN RGB(242,48,48,1.0)  //品牌色，图标重要文字
#define COLOR_SPECIAL RGB(255,180,18,1.0)   //  特殊提醒
#define COLOR_IMPORTANT RGB(35,35,35,1.0) // 用于重要文字内容，内容标题内容太
#define COLOR_CONMMNT RGB(35,35,35,1.0)  // 普通段落文字用色
#define COLOR_FALG RGB(153,153,153,1.0)      //  用于标注解释性文字
#define COLOR_FALG1 RGB(102,102,102,1.0)      //  用于标注解释性文字
#define COLOR_TEXTFIELD_BORADER RGB(210,210,210,1.0)  //  用于输入框的边框线
#define COLOR_DIVIDER RGB(240,240,247,1.0)  //  用于分割线
#define COLOR_BACKGRORD RGB(243,243,243,1.0)  //  用于整体背景色

#define  COLOR_TABBAR_BACKGROUND RGB(255, 255, 255, 1.0)  // tabbar的背景色
#define COLOR_TAB_FONT_SELECTED       COLOR_MAIN    //tabbar选中字体颜色

#define XQRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

#endif /* SJColor_h */

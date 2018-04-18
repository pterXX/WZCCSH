//
//  UIWebView+Category.m
//  proj
//
//  Created by asdasd on 2017/10/10.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import "UIWebView+Category.h"

@implementation UIWebView (Category)

/**
 加载一个网页

 @param obj 只支持NSString NSURL
 */
- (void)loadWithObject:(id)obj{
    if ([obj isKindOfClass:[NSURL class]]) {
        [self loadRequest:[NSURLRequest requestWithURL:obj]];
    }else if ([obj isKindOfClass:[NSString class]]) {
        NSString *str = obj;
        if ( [str hasPrefix:@"http"]) {
            [self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        }else{
            [self loadHTMLString:str baseURL:nil];
        }
    }
}
@end

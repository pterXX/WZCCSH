//
//  MessgaeDetailViewController.m
//  running man
//
//  Created by asdasd on 2018/4/2.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "MessgaeDetailViewController.h"

@interface MessgaeDetailViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation MessgaeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)xq_addSubViews{
    self.webView.delegate = self;
    self.webView.scrollView.bounces = NO;
    self.webView.backgroundColor = [UIColor whiteColor];
//    self.webView.scrollView.contentInset = UIEdgeInsetsMake(0, SJAdapter(20),0, SJAdapter(20));
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
}

- (void)xq_layoutNavigation{
      self.title = @"消息详情";
}

- (void)xq_getNewData{
    [MLHTTPRequest GETWithURL:RUN_MSG_INFO parameters:@{@"id":self.aid?:@"",@"type":self.msg_type?:@""} success:^(MLHTTPRequestResult *result) {
        self.timeLabel.text = result.data[@"dateline"];
        self.titleLabel.text = result.data[@"title"];
        [self.webView loadHTMLString:result.data[@"content"] baseURL:[NSURL URLWithString:H5_URL]];
    } failure:^(NSError *error) {
        ML_MESSAGE_NETWORKING;
    } isResponseCache:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.webView scalesPageToFit];

    //字体大小
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '80%'"];
    //字体颜色
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#666666'"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

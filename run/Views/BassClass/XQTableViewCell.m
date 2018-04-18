//
//  XQTableViewCell.m
//  running man
//
//  Created by asdasd on 2018/4/2.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "XQTableViewCell.h"

@implementation XQTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self xq_setupViews];
        [self xq_bindViewModel];
    }
    return self;
}

- (instancetype)initWithViewModel:(id<XQViewModelProtocol>)viewModel
{
    self = [super init];
    if (self) {
        [self xq_setupViews];
        [self xq_bindViewModel];
    }
    return self;
}

- (void)xq_bindViewModel{

}

- (void)xq_setupViews{

}


@end

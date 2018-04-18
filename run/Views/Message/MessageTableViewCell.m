//
//  MessageTableViewCell.m
//  running man
//
//  Created by asdasd on 2018/4/2.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

- (void)xq_setupViews{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.titleLabel = [YYLabel new];
    self.titleLabel.textColor = COLOR_353535;
     self.titleLabel.font = [UIFont adjustFont:15];
    [self.contentView addSubview:self.titleLabel];

    self.timeLabel = [YYLabel new];
    self.timeLabel.textColor = COLOR_666666;
    self.timeLabel.font = [UIFont adjustFont:12];
    self.timeLabel.numberOfLines = 0;
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.timeLabel];

    self.mesgLabel = [YYLabel new];
    self.mesgLabel.textColor = COLOR_666666;
    self.mesgLabel.font = [UIFont adjustFont:12];
    self.mesgLabel.numberOfLines = 0;
    [self.contentView addSubview:self.mesgLabel];

    self.redPoint = [UIView new];
    self.redPoint.backgroundColor = [UIColor redColor];
    self.redPoint.layer.cornerRadius = 2.5;
    self.redPoint.layer.masksToBounds = YES;
    self.redPoint.hidden  = YES;
    [self.contentView addSubview:self.redPoint];

    @weakify(self);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.contentView.mas_top).offset(SJAdapter(30));
        make.left.equalTo(self.contentView.mas_left).offset(SJAdapter(40));
        make.right.equalTo(self.timeLabel.mas_left).offset(-SJAdapter(20));
        make.height.offset(SJAdapter(36)).priorityHigh();
    }];

    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.contentView.mas_top).offset(SJAdapter(30));
        make.right.equalTo(self.contentView.mas_right).offset(-SJAdapter(40));
        make.width.offset(50).priorityLow();
         make.height.equalTo(self.titleLabel.mas_height);
    }];

//    [self.mesgLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.mesgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(SJAdapter(20));
        make.left.equalTo(self.contentView.mas_left).offset(SJAdapter(40));
        make.right.equalTo(self.contentView.mas_right).offset(-SJAdapter(40));
        make.bottom.equalTo(self.contentView.mas_bottom).offset( - SJAdapter(20));
        make.height.offset(SJAdapter(70));

    }];

    [self.redPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.size.sizeOffset(CGSizeMake(5, 5));
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.equalTo(self.titleLabel.mas_left).offset(- SJAdapter(12));
     }];
}


- (void)setModel:(MessageModel *)model
{
    _model = model;
    self.titleLabel.text = model.title;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:model.content?:@""];
    [str yy_setColor:COLOR_666666 range:str.yy_rangeOfAll];
    [str yy_setFont:[UIFont adjustFont:12] range:str.yy_rangeOfAll];
    [str yy_setLineSpacing:6 range:str.yy_rangeOfAll];
    self.mesgLabel.attributedText = str;
    self.timeLabel.text = model.dateline;
    self.redPoint.hidden= model.is_read == 1;

    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(KWIDTH - SJAdapter(40) * 2, CGFLOAT_MAX) text:str];
    [self.mesgLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(layout.textBoundingSize.height);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  WalletCell.m
//  xiaocheng
//
//  Created by 3158 on 16/7/1.
//  Copyright © 2016年 3158. All rights reserved.
//

#import "WalletCell.h"

@implementation WalletCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.remarkLabel.font = [UIFont adjustFont:16];
    self.rqLabel.font = [UIFont adjustFont:13];
    self.fundLabel.font = [UIFont adjustFont:16];
    self.typeLabel.font = [UIFont adjustFont:14];
}

- (void)setModel:(WalletListModel *)model
{
    _model = model;
    _remarkLabel.text =  model.remark;
    _fundLabel.text = model.money;
    _rqLabel.text = model.date;
    if ([model.money containsString:@"-"]) {
        self.fundLabel.textColor = [UIColor hexString:@"de0000"];
    }else{
        self.fundLabel.textColor = [UIColor hexString:@"35c033"];
    }
    self.typeLabel.text = model.pay_type;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

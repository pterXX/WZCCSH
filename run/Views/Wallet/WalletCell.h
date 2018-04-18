//
//  WalletCell.h
//  xiaocheng
//
//  Created by 3158 on 16/7/1.
//  Copyright © 2016年 3158. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletListModel.h"

@interface WalletCell : UITableViewCell

@property(strong,nonatomic) WalletListModel *model;

@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *rqLabel;
@property (weak, nonatomic) IBOutlet UILabel *fundLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;


@end

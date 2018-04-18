//
//  CallAddressTableViewCell.m
//  city
//
//  Created by 3158 on 2018/2/2.
//  Copyright © 2018年 sjw. All rights reserved.
//

#import "CallAddressTableViewCell.h"
#import "UIView+Category.h"
@interface CallAddressTableViewCell()
@property (nonatomic ,strong) UIImageView *icon;
@property (nonatomic ,strong) UILabel *title;
@property (nonatomic ,strong) UILabel *subTitle;
@end

@implementation CallAddressTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self p_setupViews];
    }
    return self;
}

- (void)p_setupViews
{
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(11, 22, 16, 18)];
    [icon setImage:[UIImage imageNamed:@"search_localtion_icon"]];
    [self.contentView addSubview:icon];
    self.icon = icon;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(42, 15, 310 , 13)];
    [title setText:@"重庆大学出版社数字出版中心（重庆迪帕数字传媒有限公司）"];
    [title setTextColor:[UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f]];
    [title setFont:[UIFont systemFontOfSize:14]];
    title.numberOfLines = 0;
    [self.contentView addSubview:title];
    self.title = title;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(42, 35, 310,11)];
    [label setText:@"黄山大道中段5号"];
    [label setTextColor:[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f]];
    [label setFont:[UIFont systemFontOfSize:11]];
    [self.contentView addSubview:label];
    self.subTitle =  label;
    
    //  自动适应大小
    [self.contentView adaptSizeSubViewsYouUIScreenWidth:375.0f];
}

- (void)setModel:(CallAddressModel *)model
{
    _model = model;
    self.title.text = model.title;
    self.subTitle.text = model.subTitle;
    
}

//  获取值
- (void)getValue:(NSString * _Nullable __autoreleasing * _Nullable)value
{
    *value = @"5";
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

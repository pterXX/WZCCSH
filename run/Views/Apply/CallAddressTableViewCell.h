//
//  CallAddressTableViewCell.h
//  city
//
//  Created by 3158 on 2018/2/2.
//  Copyright © 2018年 sjw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallAddressModel.h"
@interface CallAddressTableViewCell : UITableViewCell
@property (nonatomic ,strong) CallAddressModel * _Nullable model;
- (void)getValue:(NSString * _Nullable __autoreleasing * _Nullable)value;
@end

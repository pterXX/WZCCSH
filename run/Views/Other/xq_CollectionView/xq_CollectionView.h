//
//  xq_CollectionView.h
//  proj
//
//  Created by asdasd on 2017/12/28.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefresh.h>
#import "CHTCollectionViewWaterfallLayout.h"
@interface xq_CollectionView : UICollectionView
@property (nonatomic ,strong) CHTCollectionViewWaterfallLayout *layout ;

//  xib cell;
@property (nonatomic ,strong) NSString *nibCellName;
//  普通的cell
@property (nonatomic ,strong) NSString *normalCellName;

// 数据源
@property (nonatomic ,strong) NSMutableArray *dataArray;

//  给cell 传递数据时 cell属性key
@property (nonatomic ,strong) NSString *cellForKeyPath;

//  设置sectionInset 偏移量
@property (nonatomic ,assign) UIEdgeInsets sectionInset;

//  返回不同的cell
@property (nonatomic ,copy) UICollectionViewCell * (^collectionCellBlock)(UICollectionView *collectionView ,NSIndexPath *indexPath);

//  设置不同cell的大小
@property (nonatomic ,copy) CGSize  (^collectionCellSizeBlock)(UICollectionView *collectionView ,NSIndexPath *indexPath);

//  设置不同section cell 排列的个数
@property (nonatomic ,copy) NSInteger  (^collectionCellColumnCountForSectionBlock)(UICollectionView *collectionView ,NSInteger section);

//  cell 的点击
@property (nonatomic ,copy) void  (^collectionDidSelectedCellBlock)(UICollectionView *collectionView ,NSIndexPath *indexPath);

//  上拉 加载更多，下拉刷新
- (void)refresh:(void(^)())refresh loadMore:(void(^)())loadMore;

// 设置数据源并且设置cell接收值的keyPath
- (void)setupDataArray:(NSMutableArray *)dataArray cellForKeyPath:(NSString *)cellForKeyPath;


#pragma mark - Public Methods
//  便利初始化
+ (instancetype)collectionDataSourceRefresh:(void(^)())refresh
                                   loadMore:(void(^)())loadMore
                               sectionInset:(UIEdgeInsets)sectionInset collectionCellSizeBlock:(CGSize(^)(UICollectionView *collectionView ,NSIndexPath *indexPath))collectionCellSizeBlock
                        collectionCellBlock:(UICollectionViewCell * (^)(UICollectionView *collectionView ,NSIndexPath *indexPath))collectionCellBlock;
@end

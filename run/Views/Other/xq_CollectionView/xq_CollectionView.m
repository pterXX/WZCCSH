//
//  xq_CollectionView.m
//  proj
//
//  Created by asdasd on 2017/12/28.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import "xq_CollectionView.h"
#import "UIScrollView+EmptyDataSet.h"


static NSString  *const ItemIdentifier = @"item";
static NSString *const headerIdentifier = @"header";
static NSString *const footerIdentifier = @"footer";

@interface xq_CollectionView () <UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, copy) NSMutableArray *data;

@end

@implementation xq_CollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    CHTCollectionViewWaterfallLayout *falllayout = [[CHTCollectionViewWaterfallLayout alloc] init];
    falllayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self = [super initWithFrame:frame collectionViewLayout:falllayout];
    if (self) {
        [self setupUp];
    }
    return self;
}

- (instancetype)init
{
    CHTCollectionViewWaterfallLayout *falllayout = [[CHTCollectionViewWaterfallLayout alloc] init];
    falllayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self = [super initWithFrame:CGRectZero collectionViewLayout:falllayout];
    if (self) {
        [self setupUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    CHTCollectionViewWaterfallLayout *falllayout = [[CHTCollectionViewWaterfallLayout alloc] init];
    falllayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self = [super initWithFrame:frame collectionViewLayout:falllayout];
    if (self)
    {
        [self setupUp];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUp];
}

- (void)setupUp{
    self.backgroundColor = [UIColor colorWithRed:243.0f/255.0f green:243.0f/255.0f blue:243.0f/255.0f alpha:1.0];
//    self.backgroundView.backgroundColor = [UIColor colorWithRed:243.0f/255.0f green:243.0f/255.0f blue:243.0f/255.0f alpha:1.0];
    self.layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    self.layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.collectionViewLayout = self.layout;
    self.delegate = self;
    self.dataSource = self;
    self.backgroundColor = [UIColor colorWithRed:23.0f/255.0f green:23.0f/255.0f blue:23.0f/255.0f alpha:1.0f];

    [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ItemIdentifier];
}

//  上拉 加载更多，下拉刷新
- (void)refresh:(void(^)())refresh loadMore:(void(^)())loadMore
{
    self.emptyDataSetSource = self;
    self.emptyDataSetDelegate = self;
    //  添加刷新控件
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (refresh) {
            refresh();
        }

    }];

    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (loadMore) {
            loadMore();
        }
    }];
}

- (void)reloadData
{
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
    [self reloadEmptyDataSet];
    [super reloadData];
}


#pragma mark - PublIc Method
- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    if (_cellForKeyPath.length > 0 && _dataArray.count > 0 ) {
        [self reloadData];
    }
}

- (void)setCellForKeyPath:(NSString *)cellForKeyPath
{
    _cellForKeyPath = cellForKeyPath;
    if (_cellForKeyPath.length > 0 && _dataArray.count > 0 ) {
        [self reloadData];
    }
}

- (void)setupDataArray:(NSMutableArray *)dataArray cellForKeyPath:(NSString *)cellForKeyPath
{
    _dataArray = dataArray;
    _cellForKeyPath= cellForKeyPath;
    if (_cellForKeyPath.length > 0 && self.dataArray.count > 0 ) {
        [self reloadData];
    }
}

- (void)setNibCellName:(NSString *)nibCellName
{
    _nibCellName = nibCellName;
     [self registerNib:[UINib nibWithNibName:_nibCellName bundle:nil] forCellWithReuseIdentifier:_nibCellName];
}

- (void)setNormalCellName:(NSString *)normalCellName
{
    _normalCellName = normalCellName;
    [self registerClass:NSClassFromString(normalCellName) forCellWithReuseIdentifier:normalCellName];
}

- (void)setSectionInset:(UIEdgeInsets)sectionInset
{
    _sectionInset = sectionInset;
    self.layout.sectionInset = sectionInset;
}

#pragma mark - UICollectionView Delegate
/*！
 返回视图的个数
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

/*！
 返回cell
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {


     UICollectionViewCell * (^collectionCellBlock)(UICollectionView * ,NSIndexPath *) = self.collectionCellBlock;
    if (collectionCellBlock) {
        return collectionCellBlock(collectionView,indexPath);
    } else {
        NSAssert((_normalCellName == nil || _nibCellName == nil), @"必须设置一个cell 的名称, setNormalCellName: 或 setNibCellName:  设置一个cell");
        Class cellClass;
        if (_normalCellName) {
            cellClass = NSClassFromString(_normalCellName);
        } else
        {
            cellClass = NSClassFromString(_nibCellName);
        }

        NSAssert(cellClass != nil, @"必须设置一个cell 的名称, setNormalCellName: 或 setNibCellName:  设置一个cell");

        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(cellClass) forIndexPath:indexPath];
        if (self.cellForKeyPath)
        {
            [cell setValue:self.dataArray[indexPath.row] forKey:self.cellForKeyPath];
        }
        return cell;
    }
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *view =   [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UICollectionElementKindSectionHeader forIndexPath:indexPath];
        return view;
    }else{
        UICollectionReusableView *view =   [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:UICollectionElementKindSectionFooter forIndexPath:indexPath];
        return view;
    }
    return nil;
}

/*！
 当前点击的item
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.collectionDidSelectedCellBlock) {
        self.collectionDidSelectedCellBlock(collectionView,indexPath);
    }
}


#pragma mark - CHTCollectionViewDelegateWaterfallLayout

/*！
 返回瀑布流item的大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGSize  (^collectionCellSizeBlock)(UICollectionView * ,NSIndexPath *) =  self.collectionCellSizeBlock;
    if (collectionCellSizeBlock) {
      return  collectionCellSizeBlock(collectionView ,indexPath);
    }
    return CGSizeMake(150, 150);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout columnCountForSection:(NSInteger)section
{
    if (self.collectionCellColumnCountForSectionBlock)
    {
        NSInteger count = self.collectionCellColumnCountForSectionBlock(collectionView,section);
        return  count > 0 ? count:1;
    }
    return 2;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollView contentSize %lf",scrollView.contentSize.height);
    NSLog(@"scrollView contentOffset %lf",scrollView.contentOffset.y);

}

#pragma mark - DZNEmptyDataSetSource,DZNEmptyDataSetDelegate
/// 空白页显示图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"no_data_img_150"];
}

/// 空白页显示标题
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *title = @"暂无数据";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont adjustFont:28],
                                 NSForegroundColorAttributeName:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}


- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return SJAdapter(44);
}

//// 向上偏移量为表头视图高度/2
//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
//    return - SJAdapter(280);
//}



#pragma mark - Public Methods
+ (instancetype)collectionDataSourceRefresh:(void(^)())refresh
                                   loadMore:(void(^)())loadMore
                               sectionInset:(UIEdgeInsets)sectionInset collectionCellSizeBlock:(CGSize(^)(UICollectionView *collectionView ,NSIndexPath *indexPath))collectionCellSizeBlock
                        collectionCellBlock:(UICollectionViewCell * (^)(UICollectionView *collectionView ,NSIndexPath *indexPath))collectionCellBlock
{
    xq_CollectionView *collection = [[xq_CollectionView alloc] init];
    [collection refresh:refresh loadMore:loadMore];
    collection.backgroundColor = [UIColor colorWithRed:243.0f/255.0f green:243.0f/255.0f blue:243.0f/255.0f alpha:1.0];
     [collection setSectionInset:sectionInset];
    [collection setCollectionCellSizeBlock:collectionCellSizeBlock];
    [collection setCollectionCellBlock:collectionCellBlock];
    return collection;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

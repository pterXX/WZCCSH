//
//  Xq_ImagePickerCollectionView.m
//  city
//
//  Created by asdasd on 2017/10/13.
//  Copyright © 2017年 sjw. All rights reserved.
//

#import "Xq_ImagePickerCollectionView.h"

#import "Xq_ImagePickerCollectionImagePicker.h"
#import <Masonry/Masonry.h>
//#import "ImagePickerCollectionFormView.h"


static NSString * const kCell = @"Xq_ImagePickerCollectionViewCell";


@interface Xq_ImagePickerCollectionView ()

@property (nonatomic ,strong) NSMutableArray *didSelectedAssest; //  已选中的数组
@end


@implementation Xq_ImagePickerCollectionView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}


+ (instancetype)collectionViewWIthFrame:(CGRect)frame maxItemCount:(NSInteger)itemCount{
    CGFloat leftSpacing = SJAdapter(40);
    Xq_ImagePickerCollectionViewFlowLayout *layout = [[Xq_ImagePickerCollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = Xq_ImagePickerCollectionViewCell.cell_minimumLineSpacing;
    layout.minimumInteritemSpacing = 0.1;
    layout.itemSize = CGSizeMake(Xq_ImagePickerCollectionViewCell.cell_fixedWidth, Xq_ImagePickerCollectionViewCell.cell_fixedHeight);

    Xq_ImagePickerCollectionView *collection = [[Xq_ImagePickerCollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    collection.subItemCount = itemCount;
    collection.contentInset = UIEdgeInsetsMake(SJAdapter(30), leftSpacing, SJAdapter(30), leftSpacing);
    return collection;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[Xq_ImagePickerCollectionViewCell class] forCellWithReuseIdentifier:kCell];
    }
    return self;
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count = 0;
    if (_ImgDataSource.count >= self.subItemCount ) {
        count = self.subItemCount;
    }else if (_ImgDataSource.count < self.subItemCount ){
        count = _ImgDataSource.count  + 1;
    }else {
        count = 1;
    }

    if (self.Xq_imagePickerUpdateCount) {
        self.Xq_imagePickerUpdateCount(count);
    }
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Xq_ImagePickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCell forIndexPath:indexPath];
    if (self.ImgDataSource.count < self.subItemCount && indexPath.row == self.ImgDataSource.count){
        cell.imageView.image = nil;
        cell.isDel = NO;
    }else{
        cell.imageView.image = self.ImgDataSource[indexPath.row];
        cell.isDel = YES;
        cell.index = indexPath.row;
        __weak typeof(self) weakSelf = self;
        //  删除当前cell

        [cell setDeleteCurrentCell:^(NSInteger index) {
            //  删除当前数据
            [weakSelf.ImgDataSource removeObjectAtIndex:index];
            [weakSelf.ImgSrcDataSource removeObjectAtIndex:index];
            [weakSelf.didSelectedAssest removeObjectAtIndex:index];
            [collectionView reloadData];

            if (weakSelf.Xq_ImagePickerEdit) {
                weakSelf.Xq_ImagePickerEdit(weakSelf.ImgDataSource,weakSelf.ImgSrcDataSource);
            }
        }];
    }
    return cell;
}



#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

     __weak typeof(self) weakSelf = self;
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
//    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        if (self.ImgDataSource.count < self.subItemCount && indexPath.row == self.ImgDataSource.count) {
//            [Xq_ImagePickerCollectionImagePicker  Xq_ImagePickerControllerWithMaxImagesCount:9 didSelectedAssest:self.didSelectedAssest successBlock:^(NSArray<UIImage *> *photos, NSArray *assets, NSArray<NSString *> *imageSrcs) {
//                weakSelf.ImgDataSource = photos.mutableCopy;
//                weakSelf.ImgSrcDataSource = imageSrcs.mutableCopy;
//                weakSelf.didSelectedAssest = assets.mutableCopy;
//                [collectionView reloadData];
//
//                if (weakSelf.Xq_ImagePickerEdit) {
//                    weakSelf.Xq_ImagePickerEdit(weakSelf.ImgDataSource,weakSelf.ImgSrcDataSource);
//                }
//            }];
//        }
//
//         [alert dismissViewControllerAnimated:YES completion:nil];
//    }]];
//
//    [alert addAction:[UIAlertAction actionWithTitle:@"选取照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.ImgDataSource.count < self.subItemCount && indexPath.row == self.ImgDataSource.count) {
            [Xq_ImagePickerCollectionImagePicker  Xq_ImagePickerControllerWithMaxImagesCount:self.subItemCount didSelectedAssest:self.didSelectedAssest successBlock:^(NSArray<UIImage *> *photos, NSArray *assets, NSArray<NSString *> *imageSrcs) {
                weakSelf.ImgDataSource = photos.mutableCopy;
                weakSelf.ImgSrcDataSource = imageSrcs.mutableCopy;
                weakSelf.didSelectedAssest = assets.mutableCopy;
                [collectionView reloadData];

                if (weakSelf.Xq_ImagePickerEdit) {
                    weakSelf.Xq_ImagePickerEdit(weakSelf.ImgDataSource,weakSelf.ImgSrcDataSource);
                }
            }];
        }

//        [alert dismissViewControllerAnimated:YES completion:nil];
//    }]];
//
//    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [alert dismissViewControllerAnimated:YES completion:nil];
//    }]];
//
//    [self.viewController.parentViewController presentViewController:alert animated:YES completion:nil];
    //  隐藏所有响应者的键盘
//    [ImagePickerCollectionFormView hideAllResponderKeyboard];
}



#pragma mark - Getter 
- (UICollectionViewFlowLayout *)flowLayout
{
    return (UICollectionViewFlowLayout *)self.collectionViewLayout;
}

- (NSInteger)subItemCount{
    if (_subItemCount == 0) {
        _subItemCount = 5;
    }
    return _subItemCount;
}


- (NSMutableArray<UIImage *> *)ImgDataSource{
    if (_ImgDataSource == nil) {
        _ImgDataSource = [NSMutableArray array];
    }
    return _ImgDataSource;
}


- (NSMutableArray<NSString *> *)ImgSrcDataSource{
    if (_ImgSrcDataSource == nil) {
        _ImgSrcDataSource = [NSMutableArray array];
    }
    return _ImgSrcDataSource;
}

    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     - (void)drawRect:(CGRect)rect {
     // Drawing code
     }
     */
/**
 获取参数，用这个方法得到的值是字典

 @return 字典
 */
- (NSDictionary *)_getText{
    if (self.callbackField && self.ImgSrcDataSource ) {
        return @{self.callbackField:self.ImgSrcDataSource};
    }
    return nil;
}
@end


@implementation Xq_ImagePickerCollectionViewFlowLayout

@end


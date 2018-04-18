//
//  CELL.m
//  city
//
//  Created by asdasd on 2017/10/13.
//  Copyright © 2017年 sjw. All rights reserved.
//

#import "Xq_ImagePickerCollectionViewCell.h"

#define CELL Xq_ImagePickerCollectionViewCell
@implementation Xq_ImagePickerCollectionViewCell
static UIImage* _release_pic_icon = nil;
static UIColor* _fontColor = nil;
static UIColor* bgColor = nil;

+ (void)initialize
{
    // Colors Initialization
    bgColor = [UIColor colorWithRed: 0.941 green: 0.941 blue: 0.969 alpha: 1];
    _fontColor = [UIColor colorWithRed: 0.735 green: 0.735 blue: 0.769 alpha: 1];
}



- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setUI];
    }
    return self;
}


- (void)_setUI{
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"evluation_ImagePicker"]];
    self.imageView.frame = self.contentView.frame;
    self.imageView.contentMode =  UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    [self.contentView addSubview:self.imageView];
   [self.contentView addSubview:self.closeButton];
}

- (xq_CloseButton *)closeButton{
    if (_closeButton == nil) {
        _closeButton = [xq_CloseButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(self.contentView.frame.size.width - 25,  0, 25, 25);
        _closeButton.hidden = YES;
        [_closeButton addTarget:self action:@selector(closeCurrentCell:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (void)setIsDel:(BOOL)isDel{
    _isDel = isDel;
    self.closeButton.hidden = !isDel;
}

- (void)closeCurrentCell:(UIButton *)sender{
    if (self.deleteCurrentCell) {
        self.deleteCurrentCell(self.index)
        ;    }
}

- (void)drawRect:(CGRect)rect{
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    //// Resize to Target Frame
    CGContextSaveGState(context);
    CGRect resizedFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    CGContextTranslateCTM(context, resizedFrame.origin.x, resizedFrame.origin.y);


    //// 矩形 10 Drawing
    UIBezierPath* _10Path = [UIBezierPath bezierPath];
    [_10Path moveToPoint: CGPointMake(0, 0)];
    [_10Path addLineToPoint: CGPointMake(self.width, 0)];
    [_10Path addLineToPoint: CGPointMake(self.width, self.height)];
    [_10Path addLineToPoint: CGPointMake(0, self.height)];
    [_10Path addLineToPoint: CGPointMake(0, 0)];
    [_10Path closePath];
    [CELL.bgColor setFill];
    [_10Path fill];

    CGFloat imageSizeWidth = SJAdapter(60);
    CGFloat imageSizeHeight = SJAdapter(60);
    CGFloat imageOrginLeft =  (self.width - imageSizeWidth) / 2;
    CGFloat imageOrginTop =  SJAdapter(36);

    //// 图层 4 Drawing
    UIBezierPath* _4Path = [UIBezierPath bezierPathWithRect: CGRectMake(imageOrginLeft, imageOrginTop, imageSizeWidth, imageSizeHeight)];
    CGContextSaveGState(context);
    [_4Path addClip];
    CGContextScaleCTM(context, 1, -1);
    // 图片
    CGContextDrawTiledImage(context, CGRectMake(imageOrginLeft, - imageOrginTop, imageSizeWidth, imageSizeHeight), CELL.release_pic_icon.CGImage);
    CGContextRestoreGState(context);

    UIFont *font =  [UIFont fontWithName: @"HelveticaNeue" size: SJAdapter(22)];

    CGFloat titleSizeWidth = SJAdapter(90);
    CGFloat titleSizeHeight = font.lineHeight;
    CGFloat titleOrginLeft =  (self.width - titleSizeWidth) / 2;
    CGFloat titleOrginTop =  SJAdapter(112);
    
    //// Graphic 上传照片 4 Drawing
    CGRect graphic4Rect = CGRectMake(titleOrginLeft, titleOrginTop, titleSizeWidth, titleSizeHeight);
    NSMutableParagraphStyle* graphic4Style = [[
NSMutableParagraphStyle alloc] init];
    graphic4Style.alignment = NSTextAlignmentLeft;
    NSDictionary* graphic4FontAttributes = @{NSFontAttributeName:font, NSForegroundColorAttributeName: CELL.fontColor, NSParagraphStyleAttributeName: graphic4Style};

    [@"上传照片" drawInRect: graphic4Rect withAttributes: graphic4FontAttributes];

    CGContextRestoreGState(context);
}


#pragma mark Images
+ (UIImage*)release_pic_icon
{
    return _release_pic_icon ?: (_release_pic_icon = [UIImage imageNamed: @"release_pic_icon_30.png"]);
}

#pragma mark Colors

+ (UIColor*)fontColor { return _fontColor; }
+ (UIColor*)bgColor { return bgColor; }

#pragma mark Sizes
+ (CGFloat)cell_fixedWidth {
    return SJAdapter(162);
}

+ (CGFloat)cell_fixedHeight {
    return SJAdapter(162);
}

+ (CGFloat)cell_minimumLineSpacing
{
    return SJAdapter(30);
}
@end

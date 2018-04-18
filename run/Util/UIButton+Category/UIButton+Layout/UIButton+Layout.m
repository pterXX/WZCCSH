//
//  UIButton+Layout.m
//  YLButton
//
//  Created by HelloYeah on 2016/12/5.
//  Copyright © 2016年 YL. All rights reserved.
//

#import "UIButton+Layout.h"
#import <objc/runtime.h>

@implementation UIButton (Layout)

#pragma mark - ************* 通过运行时动态添加关联 ******************
//定义关联的Key
static const char * titleRectKey = "yl_titleRectKey";
- (CGRect)titleRect {
    return [objc_getAssociatedObject(self, titleRectKey) CGRectValue];
}

- (void)setTitleRect:(CGRect)rect {
    objc_setAssociatedObject(self, titleRectKey, [NSValue valueWithCGRect:rect], OBJC_ASSOCIATION_RETAIN);
}

//定义关联的Key
static const char * imageRectKey = "yl_imageRectKey";
- (CGRect)imageRect {

    NSValue * rectValue = objc_getAssociatedObject(self, imageRectKey);

    return [rectValue CGRectValue];
}

- (void)setImageRect:(CGRect)rect {

    objc_setAssociatedObject(self, imageRectKey, [NSValue valueWithCGRect:rect], OBJC_ASSOCIATION_RETAIN);
}

#pragma mark - ************* 通过运行时动态替换方法 ******************
+ (void)load {
    MethodSwizzle(self,@selector(titleRectForContentRect:),@selector(override_titleRectForContentRect:));
    MethodSwizzle(self,@selector(imageRectForContentRect:),@selector(override_imageRectForContentRect:));

    MethodSwizzle(self,@selector(layoutSubviews),@selector(override_layoutSubviews));
}

void MethodSwizzle(Class c,SEL origSEL,SEL overrideSEL)
{
    Method origMethod = class_getInstanceMethod(c, origSEL);
    Method overrideMethod= class_getInstanceMethod(c, overrideSEL);

    //运行时函数class_addMethod 如果发现方法已经存在，会失败返回，也可以用来做检查用:
    if(class_addMethod(c, origSEL, method_getImplementation(overrideMethod),method_getTypeEncoding(overrideMethod)))
    {
        //如果添加成功(在父类中重写的方法)，再把目标类中的方法替换为旧有的实现:
        class_replaceMethod(c,overrideSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }
    else
    {
        //addMethod会让目标类的方法指向新的实现，使用replaceMethod再将新的方法指向原先的实现，这样就完成了交换操作。
        method_exchangeImplementations(origMethod,overrideMethod);
    }
}

- (CGRect)override_titleRectForContentRect:(CGRect)contentRect {

    if (!CGRectIsEmpty(self.titleRect) && !CGRectEqualToRect(self.titleRect, CGRectZero))
    {
        return self.titleRect;
    }
    return [self override_titleRectForContentRect:contentRect];

}

- (CGRect)override_imageRectForContentRect:(CGRect)contentRect {

    if (!CGRectIsEmpty(self.imageRect) && !CGRectEqualToRect(self.imageRect, CGRectZero))
    {
        return self.imageRect;
    }
    return [self override_imageRectForContentRect:contentRect];
}


- (void)override_layoutSubviews
{
    [self override_layoutSubviews];
    self.layoutWidth = self.frame.size.width;
    self.layoutHeight = self.frame.size.height;
}

- (void)setLayoutWidth:(CGFloat)layoutWidth
{
    objc_setAssociatedObject(self, @selector(layoutWidth), @(layoutWidth), OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)layoutWidth{
    NSNumber * value = objc_getAssociatedObject(self, _cmd);

    return [value floatValue];
}



- (void)setLayoutHeight:(CGFloat)layoutHeight
{
    objc_setAssociatedObject(self, @selector(layoutHeight), @(layoutHeight), OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)layoutHeight
{
    NSNumber * value = objc_getAssociatedObject(self, _cmd);

    return [value floatValue];
}


- (CGSize)titleSize
{
    NSDictionary *attrs = @{NSFontAttributeName : self.titleLabel.font};
    return [self.currentTitle boundingRectWithSize:CGSizeMake(self.layoutWidth, self.layoutHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (void)setImgePosition:(UIButtonImagePosition)position  spacer:(CGFloat)spacer{
    [self setImgePosition:position spacer:spacer imageSize:CGSizeZero];
}


- (void)setImgePosition:(UIButtonImagePosition)position spacer:(CGFloat)spacer imageSize:(CGSize)size{
    [self layoutIfNeeded];

    CGFloat imageSizeWidth = self.currentImage.size.width;
    CGFloat imageSizeHeight = self.currentImage.size.height;
    if (CGSizeEqualToSize(size, CGSizeZero) == NO) {
        imageSizeWidth = size.width;
        imageSizeHeight = size.height;
    }


    CGSize titleSize = [self titleSize];
    CGFloat titleSizeWidth = titleSize.width;
    CGFloat titleSizeHeight = titleSize.height;

    if (position  == UIButtonImagePositionLeft)
    { // 在左边
        CGFloat imageOrginTop = (self.layoutHeight - imageSizeHeight) / 2;

        if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentTop)
        {
            imageOrginTop = 0;
        }else if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentBottom)
        {
            imageOrginTop = self.layoutHeight - imageSizeHeight;
        }else
        {
            imageOrginTop = imageOrginTop;
        }

        CGFloat imageOrginLeft = (self.layoutWidth - imageSizeWidth - spacer - titleSizeWidth) / 2;

        if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft)
        {
            imageOrginLeft = 0;
        } else if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentRight)
        {
            imageOrginLeft = self.layoutWidth - imageSizeWidth - titleSizeWidth - spacer;
        }else
        {
            imageOrginLeft = imageOrginLeft;
        }

        [self setImageRect:CGRectMake(imageOrginLeft, imageOrginTop, imageSizeWidth, imageSizeHeight)];

        CGFloat titleOrginTop = (self.layoutHeight - titleSizeHeight) / 2;

        if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentTop)
        {
            titleOrginTop = 0;
        }else if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentBottom)
        {
            titleOrginTop = self.layoutHeight - titleSizeHeight;
        }else
        {
            titleOrginTop = titleOrginTop;
        }

        CGFloat titleOrginLeft = imageOrginLeft + imageSizeWidth + spacer;
        [self setTitleRect:CGRectMake(titleOrginLeft, titleOrginTop, titleSizeWidth, titleSizeHeight)];

    }else if(position  == UIButtonImagePositionRight)
    { // 在右边

        CGFloat titleOrginTop = (self.layoutHeight - titleSizeHeight) / 2;

        if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentTop)
        {
            titleOrginTop = 0;
        }else if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentBottom)
        {
            titleOrginTop = self.layoutHeight - titleSizeHeight;
        }else
        {
            titleOrginTop = titleOrginTop;
        }

        CGFloat titleOrginLeft = (self.layoutWidth - imageSizeWidth - spacer - titleSize.width) / 2;

        if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft)
        {
            titleOrginLeft = 0;
        } else if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentRight)
        {
            titleOrginLeft = self.layoutWidth - imageSizeWidth - titleSizeWidth - spacer;
        }else
        {
            titleOrginLeft = titleOrginLeft;
        }

        [self setTitleRect:CGRectMake(titleOrginLeft, titleOrginTop, titleSizeWidth, titleSizeHeight)];

        CGFloat imageOrginTop = (self.layoutHeight - imageSizeHeight) / 2;

        if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentTop)
        {
            imageOrginTop = 0;
        }else if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentBottom)
        {
            imageOrginTop = self.layoutHeight - imageSizeWidth;
        }else
        {
            imageOrginTop = imageOrginTop;
        }
        CGFloat imageOrginLeft =  titleOrginLeft + titleSizeWidth + spacer;
        [self setImageRect:CGRectMake(imageOrginLeft, imageOrginTop, imageSizeWidth, imageSizeHeight)];

    }else if(position  == UIButtonImagePositionTop)
    { // 在上边
        CGFloat imageOrginTop = (self.layoutHeight - titleSizeHeight - imageSizeHeight - spacer) / 2;

        if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentTop)
        {
            imageOrginTop = 0;
        }else if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentBottom)
        {
            imageOrginTop = self.layoutHeight - imageSizeHeight -  titleSizeHeight - spacer;
        }else
        {
            imageOrginTop = imageOrginTop;
        }


        CGFloat imageOrginLeft =  (self.layoutWidth - imageSizeWidth) / 2;
        if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft)
        {
            imageOrginLeft = 0;
        } else if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentRight)
        {
            imageOrginLeft = self.layoutWidth - imageSizeWidth;
        }else
        {
            imageOrginLeft = imageOrginLeft;
        }

        [self setImageRect:CGRectMake(imageOrginLeft, imageOrginTop, imageSizeWidth, imageSizeHeight)];

        CGFloat titleOrginTop = imageOrginTop + imageSizeHeight + spacer;
        CGFloat titleOrginLeft = (self.layoutWidth - titleSizeWidth) / 2;
        if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft)
        {
            titleOrginLeft = 0;
        } else if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentRight)
        {
            titleOrginLeft = self.layoutWidth - titleSizeWidth;
        }else
        {
            titleOrginLeft = titleOrginLeft;
        }

        [self setTitleRect:CGRectMake(titleOrginLeft, titleOrginTop, titleSizeWidth, titleSizeHeight)];
    }else
    { // 在下边

        CGFloat titleOrginTop = (self.layoutHeight - titleSizeHeight - imageSizeHeight - spacer) / 2;
        if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentTop)
        {
            titleOrginTop = 0;
        }else if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentBottom)
        {
            titleOrginTop = self.layoutHeight - imageSizeHeight -  titleSizeHeight - spacer;
        }else
        {
            titleOrginTop = titleOrginTop;
        }

        CGFloat titleOrginLeft = (self.layoutWidth - titleSizeWidth) / 2;

        if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft)
        {
            titleOrginLeft = 0;
        } else if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentRight)
        {
            titleOrginLeft = self.layoutWidth - titleSizeWidth;
        }else
        {
            titleOrginLeft = titleOrginLeft;
        }

        [self setTitleRect:CGRectMake(titleOrginLeft, titleOrginTop, titleSizeWidth, titleSizeHeight)];

        CGFloat imageOrginTop = titleSizeHeight + titleOrginTop + spacer;

        CGFloat imageOrginLeft =  (self.layoutWidth - imageSizeWidth) / 2;

        if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft)
        {
            imageOrginLeft = 0;
        } else if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentRight)
        {
            imageOrginLeft = self.layoutWidth - imageSizeWidth;
        }else
        {
            imageOrginLeft = imageOrginLeft;
        }
        
        [self setImageRect:CGRectMake(imageOrginLeft, imageOrginTop, imageSizeWidth, imageSizeHeight)];
    }
    
}

@end

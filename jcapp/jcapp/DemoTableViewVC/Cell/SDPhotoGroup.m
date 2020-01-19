//
//  SDPhotoGroup.m
//  SDPhotoBrowser
//
//  Created by aier on 15-2-4.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import "SDPhotoGroup.h"
#import "SDPhotoItem.h"
#import "UIButton+WebCache.h"
#import "SDPhotoBrowser.h"
#import "Masonry.h"

#define SDPhotoGroupImageMargin 15

@interface SDPhotoGroup () <SDPhotoBrowserDelegate>

@property (nonatomic, strong) UILabel *lblcount;

@end

@implementation SDPhotoGroup 

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 清除图片缓存，便于测试
//        [[SDWebImageManager sharedManager].imageCache clearDisk];
    }
    return self;
}
 
- (UILabel *)lblcount {
    
    if (!_lblcount) {
        _lblcount = [[UILabel alloc] init];
        _lblcount.font = kFont_Lable_12;
        _lblcount.textColor =kColor_White;
        _lblcount.backgroundColor = kColor_Gray;
        _lblcount.textAlignment = NSTextAlignmentCenter;
    }
    return _lblcount;
}

- (void)setPhotoItemArray:(NSArray *)photoItemArray
{
    _photoItemArray = photoItemArray;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [photoItemArray enumerateObjectsUsingBlock:^(SDPhotoItem *obj, NSUInteger idx, BOOL *stop) {
        UIButton *btn = [[UIButton alloc] init];
        [btn sd_setImageWithURL:[NSURL URLWithString:obj.thumbnail_pic] forState:UIControlStateNormal];
        
        btn.tag = idx;
        
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:btn];
    }];
    
    //可以根据idx设置位置
    
    NSInteger imageCount = photoItemArray.count;
    
    int perRowImageCount = ((imageCount == 4) ? 2 : 3);
    CGFloat perRowImageCountF = (CGFloat)perRowImageCount;
    //  int totalRowCount = ceil(imageCount / perRowImageCountF);
    //self.frame = CGRectMake(10, 10, 300, totalRowCount * (SDPhotoGroupImageMargin + h));
    //self.width=kScreenWidth-20;
    self.frame = CGRectMake(0, 0, kScreenWidth-10, Common_ImageTableRowHeight);
    if(imageCount>=4)
    {
        imageCount = 4;
        
         [self addSubview:self.lblcount];
        
        //x 为 4个图片宽度 + 前面空白 + 3个间隔 - lbl宽度, y 为图片高度 - 文字高度
  //       self.lblcount.frame = CGRectMake(20+15*3+80*4 - 60, 60, 60, 60);
//        self.lblcount.frame = CGRectMake(kScreenWidth-50, 80-22, 40, 22);
        [self.lblcount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-30);
            make.right.mas_equalTo(-15);
            make.size.mas_equalTo(CGSizeMake(40,22));
        }];
        [self bringSubviewToFront:self.lblcount];
        NSString *str_C = [[NSString alloc] initWithFormat:@"%@%d%@", @"共",photoItemArray.count,@"张" ];
        self.lblcount.text = str_C;
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    long imageCount = self.photoItemArray.count;
    int perRowImageCount = ((imageCount == 4) ? 2 : 3);
    CGFloat w = (kScreenWidth-40)/4;
    CGFloat h = 70;
    
    [self.subviews enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        
        long rowIndex = idx / perRowImageCount;
      //  int columnIndex = idx % perRowImageCount;
      //  CGFloat x = columnIndex * (w + SDPhotoGroupImageMargin);
      //  CGFloat y = rowIndex * (h + SDPhotoGroupImageMargin);
        if(idx < 4)
        {
            //目前请假x为38
            //btn.frame = CGRectMake(idx*15 + idx*w + 10, 0, w, h);
            btn.frame = CGRectMake(idx*5 + idx*w+10, 0, w-10, h);
        }
//        btn.frame = CGRectMake(idx*5 + idx*w+10, 0, w-10, h);
    }];
}

- (void)buttonClick:(UIButton *)button
{
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = self; // 原图的父控件
    browser.imageCount = self.photoItemArray.count; // 图片总数
    browser.currentImageIndex = button.tag;
    browser.delegate = self;
    [browser show];
    
}

#pragma mark - photobrowser代理方法

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    //将共几张字样置于最外层
    //[self bringSubviewToFront:self.lblcount];
    return [self.subviews[index] currentImage];
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    //将共几张字样置于最外层
    //[self bringSubviewToFront:self.lblcount];
    NSString *urlStr = [[self.photoItemArray[index] thumbnail_pic] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    return [NSURL URLWithString:urlStr];
}

@end

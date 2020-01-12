//
//  AutoLableView.m
//  JPet
//
//  Created by apple on 2017/5/24.
//  Copyright © 2017年 DingXiaoLei. All rights reserved.
//

#import "AutoLableView.h"

@implementation AutoLableView
{
//    UIButton *_btn;
    UILabel *_titlelb;
    UILabel *_countlb;
}
- (void)setTitle:(NSString *)title
{
    _title = title;
    _titlelb.text = title;
}
- (void)setCount:(NSString *)count
{
    _count = count;
    _countlb.text = count;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [_titlelb setTextAlignment:NSTextAlignmentCenter];
    _titlelb.font = [UIFont systemFontOfSize:14];
    //_titlelb.adjustsFontSizeToFitWidth = YES;    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _titlelb = [UILabel new];
        _titlelb.textColor = kColor_BlackTitle;
        _titlelb.textAlignment = NSTextAlignmentCenter;
        _titlelb.width=43;//self.size.width/2;
        _titlelb.height=self.size.height-20;
        _titlelb.backgroundColor= UIColor.orangeColor;
        _titlelb.layer.cornerRadius = 10.f;
        _titlelb.layer.masksToBounds = YES;

        //_titlelb.font = kFont_Lable_14;
        
        [_titlelb setTextAlignment:NSTextAlignmentCenter];
        _titlelb.font = [UIFont systemFontOfSize:14];
        _titlelb.adjustsFontSizeToFitWidth = YES;
        
        [self addSubview:_titlelb];
        _countlb = [UILabel new];
        //_countlb.textColor = kColor_BlackTitle;
        //_countlb.textAlignment = NSTextAlignmentCenter;
        _countlb.font = [UIFont systemFontOfSize:14];
        //[_countlb sizeToFit];
        [self addSubview:_countlb];

        
        _titlelb.sd_layout
        //.widthRatioToView(self, 0.5)
        .centerXEqualToView(self)
        .topSpaceToView(self, 5)
        .heightRatioToView(self, 0.5);
        
        _countlb.sd_layout
        .widthRatioToView(self, 0.5)
        .topSpaceToView(_titlelb, 0)
        .leftEqualToView(_titlelb)
        .rightEqualToView(_titlelb)
        .bottomSpaceToView(self, 0);
        //_countlb.frame=CGRectMake(_titlelb.left,_titlelb.top+_titlelb.height+10.0, _countlb.width, _countlb.height);
   
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  PendingListCell.m
//  jcapp
//
//  Created by lh on 2019/12/3.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "PendingsListCell.h"
#import "../SDWebImage/UIImageView+WebCache.h"
#define kMargin 10

@interface PendingsListCell()
@property (nonatomic, strong) UILabel *pendingsCaseName;
@property (nonatomic, strong) UILabel *pendingsDateLable;
@property (nonatomic, strong) UILabel *beignDateLable;
@property (nonatomic, strong) UILabel *endDateLable;
@property (nonatomic, strong) UILabel *pendingsTypeLable;
@property (nonatomic, strong) UILabel *pendingsStatusLable;

// (nonatomic, strong)   (nonatomic,weak)
@end

@implementation PendingsListCell

- (UILabel *)pendingsStatusLable {
    
    if (!_pendingsStatusLable) {
        _pendingsStatusLable = [[UILabel alloc] init];
        _pendingsStatusLable.font = kFont_Lable_14;
        _pendingsStatusLable.textColor = Color_ProcessStutasColor;
    }
    return _pendingsStatusLable;
}
- (UILabel *)pendingsDateLable {
    
    if (!_pendingsDateLable) {
        _pendingsDateLable = [[UILabel alloc] init];
        _pendingsDateLable.font = kFont_Lable_12;
        _pendingsDateLable.textColor = kColor_Gray;
    }
    return _pendingsDateLable;
}
- (UILabel *)beignDateLable {
    
    if (!_beignDateLable) {
        _beignDateLable = [[UILabel alloc] init];
        _beignDateLable.font = kFont_Lable_13;
        _beignDateLable.textColor = kColor_Gray;
    }
    return _beignDateLable;
}
- (UILabel *)endDateLable {
    
    if (!_endDateLable) {
        _endDateLable = [[UILabel alloc] init];
        _endDateLable.font = kFont_Lable_13;
        _endDateLable.textColor =kColor_Gray;
    }
    return _endDateLable;
}
- (UILabel *)pendingsTypeLable {
    
    if (!_pendingsTypeLable) {
        _pendingsTypeLable = [[UILabel alloc] init];
        _pendingsTypeLable.font = kFont_Lable_13;
        _pendingsTypeLable.textColor = kColor_Gray;
    }
    return _pendingsTypeLable;
}
//自定义cell 需要重写的方法
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.endDateLable];
        [self.contentView  addSubview:self.pendingsTypeLable];
        [self.contentView  addSubview:self.beignDateLable];
        [self.contentView  addSubview:self.pendingsStatusLable];
        [self.contentView  addSubview:self.pendingsDateLable];
    }
    return self;
}

-(void)setPendingslistitem:(Pending *)pendingslistitem
{
    _pendingslistitem =pendingslistitem;
    self.textLabel.text = _pendingslistitem.CaseName;
    self.pendingsStatusLable.text = _pendingslistitem.CaseStatusTxt;
    self.pendingsDateLable.text = _pendingslistitem.CaseDate;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    NSString *userurlString =[NSString stringWithFormat:Common_UserPhotoUrl,_pendingslistitem.ApplyManPhoto];
    [imageView sd_setImageWithURL:[NSURL URLWithString:userurlString]];
    self.imageView.image=imageView.image;
    self.beignDateLable.text = _pendingslistitem.BeignDate;
    self.endDateLable.text = _pendingslistitem.EndDate;
    if(_pendingslistitem.CaseTypeTxt!=NULL)
    {
        self.pendingsTypeLable.text = [NSString stringWithFormat:@"请假类型:%@",_pendingslistitem.CaseTypeTxt];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat imageWH=  width/5;
    CGFloat leaveDateWidth = 80;
    //每行的文本的高度
    CGFloat txtH = (height - 6*kMargin)/5;
    self.imageView.frame = CGRectMake(kMargin,(height - 2*kMargin-imageWH)/2, imageWH, imageWH );
    self.pendingsDateLable.frame = CGRectMake(width-leaveDateWidth-kMargin,kMargin, leaveDateWidth, txtH);
    self.pendingsTypeLable.frame = CGRectMake(2*kMargin+imageWH, txtH+2*kMargin, width - leaveDateWidth - kMargin - imageWH, txtH);
    self.beignDateLable.frame = CGRectMake(2*kMargin+imageWH, 2*txtH+3*kMargin, width - leaveDateWidth - kMargin - imageWH, txtH);
    self.endDateLable.frame = CGRectMake(2*kMargin+imageWH, 3*txtH+4*kMargin, width - leaveDateWidth - kMargin - imageWH, txtH);
    self.pendingsStatusLable.frame = CGRectMake(2*kMargin+imageWH, 4*txtH+5*kMargin, width - leaveDateWidth - kMargin - imageWH, txtH);
    self.textLabel.frame = CGRectMake(2*kMargin+imageWH,kMargin, imageWH*2, txtH);
    
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = imageWH * 0.5;
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

//
//  PendingListCell.m
//  jcapp
//
//  Created by lh on 2019/12/3.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "AgentListCell.h"
#import "../SDWebImage/UIImageView+WebCache.h"
#define kMargin 10

@interface AgentListCell()
@property (nonatomic, strong) UILabel *pendingCaseName;
@property (nonatomic, strong) UILabel *beignDateLable;
@property (nonatomic, strong) UILabel *endDateLable;
@property (nonatomic, strong) UILabel *pendingTypeLable;
@property (nonatomic, strong) UILabel *pendingStatusLable;

// (nonatomic, strong)   (nonatomic,weak)
@end

@implementation AgentListCell

- (UILabel *)pendingStatusLable {
    
    if (!_pendingStatusLable) {
        _pendingStatusLable = [[UILabel alloc] init];
        _pendingStatusLable.font = kFont_Lable_14;
        _pendingStatusLable.textColor = Color_ProcessStutasColor;
    }
    return _pendingStatusLable;
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
- (UILabel *)pendingTypeLable {
    
    if (!_pendingTypeLable) {
        _pendingTypeLable = [[UILabel alloc] init];
        _pendingTypeLable.font = kFont_Lable_13;
        _pendingTypeLable.textColor = kColor_Gray;
    }
    return _pendingTypeLable;
}
//自定义cell 需要重写的方法
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.endDateLable];
        [self.contentView  addSubview:self.pendingTypeLable];
        [self.contentView  addSubview:self.beignDateLable];
        [self.contentView  addSubview:self.pendingStatusLable];
        
    }
    return self;
}

-(void)setPendinglistitem:(Agent *)pendinglistitem
{
    _pendinglistitem =pendinglistitem;
    self.textLabel.text = _pendinglistitem.DocumentTypeNM;
    self.pendingStatusLable.text = _pendinglistitem.AgentStatusNM;
     
    UIImageView *imageView = [[UIImageView alloc] init];
    NSString *userurlString =[NSString stringWithFormat:Common_UserPhotoUrl,_pendinglistitem.ApplyManPhoto];
    [imageView sd_setImageWithURL:[NSURL URLWithString:userurlString]];
    self.imageView.image=imageView.image;
    self.beignDateLable.text =  [@"开始时间：" stringByAppendingString: _pendinglistitem.AgentStartDate];
    self.endDateLable.text = [@"结束时间：" stringByAppendingString: _pendinglistitem.AgentEndDate];  ;
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat imageWH=  width/5;
    CGFloat leaveDateWidth = 80;
    //每行的文本的高度
    CGFloat txtH = (height - 6*kMargin)/4;
    self.imageView.frame = CGRectMake(kMargin,(height - 2*kMargin-imageWH)/2, imageWH, imageWH );
    //self.pendingDateLable.frame = CGRectMake(width-leaveDateWidth-kMargin,kMargin, leaveDateWidth, txtH);
    self.pendingTypeLable.frame = CGRectMake(2*kMargin+imageWH, txtH+2*kMargin, width - leaveDateWidth - kMargin - imageWH, txtH);
    self.beignDateLable.frame = CGRectMake(2*kMargin+imageWH, 1*txtH+3*kMargin, width - leaveDateWidth - kMargin - imageWH, txtH);
    self.endDateLable.frame = CGRectMake(2*kMargin+imageWH, 2*txtH+4*kMargin, width - leaveDateWidth - kMargin - imageWH, txtH);
    self.pendingStatusLable.frame = CGRectMake(2*kMargin+imageWH, 3*txtH+5*kMargin, width - leaveDateWidth - kMargin - imageWH, txtH);
    self.textLabel.frame = CGRectMake(2*kMargin+imageWH,kMargin, kScreenWidth-(2*kMargin+imageWH), txtH);
    
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
